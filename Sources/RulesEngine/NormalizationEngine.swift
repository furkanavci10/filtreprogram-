import Foundation
import MessageFilteringDomain

public struct NormalizationEngine: Sendable {
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
            of: "[\\u{00AD}\\u{034F}\\u{061C}\\u{180E}\\u{200B}\\u{200C}\\u{200D}\\u{2060}\\u{FE0F}\\u{FEFF}]",
            with: "",
            options: .regularExpression
        )
    }

    private func joinSuspiciousSingleCharacterRuns(in tokens: [String]) -> [String] {
        var result: [String] = []
        var buffer: [String] = []

        func flushBuffer() {
            if buffer.count >= 3 {
                result.append(buffer.joined())
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
        guard !token.isEmpty else { return token }
        return collapseRepeatedCharacters(in: token, maximumRunLength: 2)
    }

    private func normalizeAggressiveToken(_ token: String) -> String {
        let mapped = String(token.map { aggressiveDigitReplacements[$0] ?? $0 })
        return collapseRepeatedCharacters(in: mapped, maximumRunLength: 1)
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
}
