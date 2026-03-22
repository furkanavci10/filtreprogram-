import Foundation
import MessageFilteringDomain

public protocol MessageClassifying: Sendable {
    func classify(_ request: FilterClassificationRequest) -> FilterClassificationResponse
}

public struct SMSFilterClassifierService: MessageClassifying, Sendable {
    private let classifier: SMSClassifier

    public init(classifier: SMSClassifier = .init()) {
        self.classifier = classifier
    }

    public func classify(_ request: FilterClassificationRequest) -> FilterClassificationResponse {
        let result = classifier.classify(request.input)
        return FilterClassificationResponse(
            disposition: Self.mapDisposition(for: result.category),
            result: result
        )
    }

    public static func mapDisposition(for category: MessageClassificationCategory) -> FilterDisposition {
        switch category {
        case .allowCritical, .allowTransactional, .allowNormal:
            return .allow
        case .reviewSuspicious:
            return .review
        case .filterPromotional, .filterSpam:
            return .junk
        }
    }
}
