import Foundation
import ClassificationCore
import MessageFilteringDomain

public struct ExtensionClassificationOutcome: Sendable {
    public let request: FilterClassificationRequest
    public let response: FilterClassificationResponse
    public let action: ExtensionFilterAction

    public init(
        request: FilterClassificationRequest,
        response: FilterClassificationResponse,
        action: ExtensionFilterAction
    ) {
        self.request = request
        self.response = response
        self.action = action
    }

    public var category: MessageClassificationCategory {
        response.result.category
    }

    public var confidenceBand: ConfidenceBand {
        response.result.confidenceBand
    }

    public var explanation: String {
        response.result.explanation
    }
}
