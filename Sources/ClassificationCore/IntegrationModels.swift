import Foundation
import MessageFilteringDomain

public enum FilterDisposition: String, Codable, CaseIterable, Sendable {
    case allow
    case review
    case junk
}

public struct FilterClassificationRequest: Codable, Hashable, Sendable {
    public let sender: String?
    public let messageBody: String

    public init(sender: String? = nil, messageBody: String) {
        self.sender = sender
        self.messageBody = messageBody
    }

    public var input: ClassificationInput {
        ClassificationInput(sender: sender, body: messageBody)
    }
}

public struct FilterClassificationResponse: Codable, Sendable {
    public let disposition: FilterDisposition
    public let result: ClassificationResult

    public init(disposition: FilterDisposition, result: ClassificationResult) {
        self.disposition = disposition
        self.result = result
    }
}
