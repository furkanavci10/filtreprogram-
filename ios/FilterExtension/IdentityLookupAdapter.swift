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
        let response = service.classify(.init(sender: sender, messageBody: messageBody))
        let action = mapper.action(for: response)
        return (response, action)
    }
}
