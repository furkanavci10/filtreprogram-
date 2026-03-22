import Foundation
import MessageFilteringDomain

public struct NormalizationEngine: Sendable {
    private let scalarReplacements: [Character: Character] = [
        "\u{131}": "i",
        "\u{130}": "i",
        "@": "a",
        "$": "s",
        "!": "i",
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
        let lowered = cleanInvisibleCharacters(input.body)
            .folding(options: [.diacriticInsensitive, .widthInsensitive], locale: Locale(identifier: "tr_TR"))
            .lowercased(with: Locale(identifier: "tr_TR"))

        let replaced = String(lowered.map { scalarReplacements[$0] ?? $0 })
        let punctuationSimplified = replaced.replacingOccurrences(
            of: "[^a-z0-9]+",
            with: " ",
            options: .regularExpression
        )

        let normalized = punctuationSimplified
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let compact = normalized.replacingOccurrences(of: " ", with: "")
        let aggressive = String(normalized.map { aggressiveDigitReplacements[$0] ?? $0 })
        let aggressiveCompact = aggressive.replacingOccurrences(of: " ", with: "")

        return NormalizedMessage(
            rawText: input.body,
            loweredText: lowered,
            normalizedText: normalized,
            compactText: compact,
            aggressiveText: aggressive,
            aggressiveCompactText: aggressiveCompact
        )
    }

    private func cleanInvisibleCharacters(_ text: String) -> String {
        text.replacingOccurrences(
            of: "[\\u{200B}\\u{200C}\\u{200D}\\u{FEFF}]",
            with: "",
            options: .regularExpression
        )
    }
}
