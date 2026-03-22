import Foundation
import MessageFilteringDomain

public struct NormalizationEngine: Sendable {
    private struct CanonicalTarget: Sendable {
        let replacement: String
        let anchoredPatterns: [String]
    }

    private let scalarReplacements: [Character: Character] = [
        "\u{131}": "i",
        "\u{130}": "i",
        "@": "a",
        "$": "s",
        "!": "i",
        "+": "t",
        "\u{20AC}": "e"
    ]

    private let aggressiveDigitReplacements: [Character: Character] = [
        "0": "o",
        "1": "i",
        "3": "e",
        "4": "a",
        "5": "s",
        "7": "t"
    ]

    private let aggressiveCanonicalTargets: [CanonicalTarget] = [
        .init(replacement: "bahis", anchoredPatterns: ["^ba+h+i+s+$", "^b[a4]+h[i!]+s+$"]),
        .init(replacement: "iddaa", anchoredPatterns: ["^i+d+d+a+a+$"]),
        .init(replacement: "freebet", anchoredPatterns: ["^fr+e+e+bet$"]),
        .init(replacement: "casino", anchoredPatterns: ["^cas+i+n+o+$"]),
        .init(replacement: "bonus", anchoredPatterns: ["^bon+u+s+$"]),
        .init(replacement: "linke", anchoredPatterns: ["^lin+ke+$"]),
        .init(replacement: "tiklayin", anchoredPatterns: ["^tik+layin$"]),
        .init(replacement: "kargonuz", anchoredPatterns: ["^karg+onuz$"]),
        .init(replacement: "onaykodu", anchoredPatterns: ["^onaykodu$"]),
        .init(replacement: "dogrulamakodu", anchoredPatterns: ["^dogrulamakodu$"])
    ]

    private let suspiciousJoinedTokenPatterns: [String] = [
        "^bahis$",
        "^iddaa$",
        "^freebet$",
        "^casino$",
        "^bonus$",
        "^linke$",
        "^tiklayin$"
    ]

    public init() {}

    public func normalize(_ input: ClassificationInput) -> NormalizedMessage {
        let cleaned = cleanInvisibleCharacters(input.body)
        let lowered = cleaned
            .folding(options: [.diacriticInsensitive, .widthInsensitive], locale: Locale(identifier: "tr_TR"))
            .lowercased(with: Locale(identifier: "tr_TR"))

        let replaced = String(lowered.map { scalarReplacements[$0] ?? $0 })
        let punctuationSimplified = replaced.replacingOccurrences(
            of: "[^a-z0-9]+",
            with: " ",
            options: .regularExpression
        )

        let baseTokens = punctuationSimplified
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map(String.init)

        let joinedTokens = joinSuspiciousSingleCharacterRuns(in: baseTokens)
        let normalizedTokens = joinedTokens.map(normalizeSafeToken)
        let aggressiveTokens = normalizedTokens.map(normalizeAggressiveToken)

        let normalizedText = normalizedTokens.joined(separator: " ")
        let compactText = normalizedTokens.joined()
        let aggressiveText = aggressiveTokens.joined(separator: " ")
        let aggressiveCompactText = aggressiveTokens.joined()

        return NormalizedMessage(
            rawText: input.body,
            loweredText: lowered,
            normalizedText: normalizedText,
            compactText: compactText,
            aggressiveText: aggressiveText,
            aggressiveCompactText: aggressiveCompactText,
            tokens: normalizedTokens
        )
    }

    private func cleanInvisibleCharacters(_ text: String) -> String {
        text.replacingOccurrences(
            of: "[\\u{00AD}\\u{034F}\\u{061C}\\u{180E}\\u{200B}\\u{200C}\\u{200D}\\u{200E}\\u{200F}\\u{202A}\\u{202B}\\u{202C}\\u{202D}\\u{202E}\\u{2060}\\u{2066}\\u{2067}\\u{2068}\\u{2069}\\u{FE0E}\\u{FE0F}\\u{FEFF}]",
            with: "",
            options: .regularExpression
        )
    }

    private func joinSuspiciousSingleCharacterRuns(in tokens: [String]) -> [String] {
        var result: [String] = []
        var buffer: [String] = []

        func flushBuffer() {
            let candidate = buffer.joined()
            if buffer.count >= 3, shouldJoinSingleCharacterRun(candidate: candidate) {
                result.append(candidate)
            } else {
                result.append(contentsOf: buffer)
            }
            buffer.removeAll(keepingCapacity: true)
        }

        for token in tokens {
            if token.count == 1, token.range(of: "[a-z0-9]", options: .regularExpression) != nil {
                buffer.append(token)
            } else {
                flushBuffer()
                result.append(token)
            }
        }

        flushBuffer()
        return result
    }

    private func normalizeSafeToken(_ token: String) -> String {
        token
    }

    private func normalizeAggressiveToken(_ token: String) -> String {
        let mapped = String(token.map { aggressiveDigitReplacements[$0] ?? $0 })
        let collapsed = shouldCollapseRepeatedCharacters(in: mapped)
            ? collapseRepeatedCharacters(in: mapped, maximumRunLength: 2)
            : mapped
        return canonicalizeAggressiveToken(collapsed)
    }

    private func collapseRepeatedCharacters(in token: String, maximumRunLength: Int) -> String {
        guard maximumRunLength > 0 else { return token }

        var output = ""
        var previous: Character?
        var runLength = 0

        for character in token {
            if character == previous {
                runLength += 1
            } else {
                previous = character
                runLength = 1
            }

            if runLength <= maximumRunLength {
                output.append(character)
            }
        }

        return output
    }

    private func canonicalizeAggressiveToken(_ token: String) -> String {
        for candidate in aggressiveCanonicalTargets {
            if candidate.anchoredPatterns.contains(where: { token.range(of: $0, options: .regularExpression) != nil }) {
                return candidate.replacement
            }
        }

        return token
    }

    private func shouldJoinSingleCharacterRun(candidate: String) -> Bool {
        guard (4...10).contains(candidate.count) else {
            return false
        }

        suspiciousJoinedTokenPatterns.contains { candidate.range(of: $0, options: .regularExpression) != nil }
    }

    private func shouldCollapseRepeatedCharacters(in token: String) -> Bool {
        guard token.range(of: "(.)\\1{2,}", options: .regularExpression) != nil else {
            return false
        }

        let collapsed = collapseRepeatedCharacters(in: token, maximumRunLength: 2)
        return aggressiveCanonicalTargets.contains { target in
            target.anchoredPatterns.contains { collapsed.range(of: $0, options: .regularExpression) != nil }
        }
    }
}
