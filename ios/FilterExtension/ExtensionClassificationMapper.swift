import Foundation
import ClassificationCore

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
}
