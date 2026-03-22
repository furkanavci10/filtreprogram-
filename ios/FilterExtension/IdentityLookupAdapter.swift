import Foundation
import ClassificationCore

public struct IdentityLookupAdapter {
    private let service: SMSFilterClassifierService
    private let mapper: ExtensionClassificationMapper

    public init(
        service: SMSFilterClassifierService = .init(),
        mapper: ExtensionClassificationMapper = .init()
    ) {
        self.service = service
        self.mapper = mapper
    }

    public func classify(sender: String?, messageBody: String) -> (response: FilterClassificationResponse, action: ExtensionFilterAction) {
        let outcome = classifyOutcome(sender: sender, messageBody: messageBody)
        return (outcome.response, outcome.action)
    }

    public func classifyOutcome(sender: String?, messageBody: String) -> ExtensionClassificationOutcome {
        let request = FilterClassificationRequest(sender: sender, messageBody: messageBody)
        let response = service.classify(request)
        let action = mapper.action(for: response)
        return ExtensionClassificationOutcome(
            request: request,
            response: response,
            action: action
        )
    }
}
