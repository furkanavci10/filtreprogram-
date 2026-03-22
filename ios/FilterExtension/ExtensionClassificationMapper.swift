import Foundation
import ClassificationCore
#if canImport(IdentityLookup)
import IdentityLookup
#endif

public enum ExtensionFilterAction: String, Codable, CaseIterable {
    case allow
    case junk
}

public struct ExtensionClassificationMapper {
    public init() {}

    public func action(for response: FilterClassificationResponse) -> ExtensionFilterAction {
        switch response.disposition {
        case .allow, .review:
            return .allow
        case .junk:
            return .junk
        }
    }

#if canImport(IdentityLookup)
    public func identityLookupFilterAction(for response: FilterClassificationResponse) -> ILMessageFilterAction {
        switch action(for: response) {
        case .allow:
            return .allow
        case .junk:
            return .junk
        }
    }
#endif
}
