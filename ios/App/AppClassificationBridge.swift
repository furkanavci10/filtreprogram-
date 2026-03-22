import Foundation
import ClassificationCore

public struct AppClassificationBridge {
    private let service: SMSFilterClassifierService

    public init(service: SMSFilterClassifierService = .init()) {
        self.service = service
    }

    public func classifyPreview(sender: String?, body: String) -> FilterClassificationResponse {
        service.classify(.init(sender: sender, messageBody: body))
    }

    public func classifyPreview(request: FilterClassificationRequest) -> FilterClassificationResponse {
        service.classify(request)
    }
}
