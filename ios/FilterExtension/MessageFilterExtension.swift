import Foundation
import ClassificationCore

#if canImport(IdentityLookup)
import IdentityLookup

public final class MessageFilterExtension: ILMessageFilterExtension, ILMessageFilterQueryHandling {
    private let adapter: IdentityLookupAdapter
    private let mapper: ExtensionClassificationMapper

    public override init() {
        self.adapter = IdentityLookupAdapter()
        self.mapper = ExtensionClassificationMapper()
        super.init()
    }

    public func handle(
        _ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest,
        context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void
    ) {
        let response = ILMessageFilterCapabilitiesQueryResponse()
        completion(response)
    }

    public func handle(
        _ queryRequest: ILMessageFilterQueryRequest,
        context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterQueryResponse) -> Void
    ) {
        let response = ILMessageFilterQueryResponse()

        guard let messageBody = queryRequest.messageBody, !messageBody.isEmpty else {
            response.filterAction = .allow
            completion(response)
            return
        }

        let outcome = adapter.classifyOutcome(
            sender: queryRequest.sender,
            messageBody: messageBody
        )

        response.filterAction = mapper.identityLookupFilterAction(for: outcome.response)
        completion(response)
    }
}
#endif
