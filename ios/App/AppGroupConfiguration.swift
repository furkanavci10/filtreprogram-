import Foundation

public struct AppGroupConfiguration: Sendable, Codable, Hashable {
    public let suiteName: String?

    public init(suiteName: String? = nil) {
        self.suiteName = suiteName
    }

    public var userDefaults: UserDefaults {
        guard let suiteName, let defaults = UserDefaults(suiteName: suiteName) else {
            return .standard
        }

        return defaults
    }
}

public struct HostAppIntegrationEnvironment: Sendable {
    public let classificationBridge: AppClassificationBridge
    public let appGroupConfiguration: AppGroupConfiguration

    public init(
        classificationBridge: AppClassificationBridge = .init(),
        appGroupConfiguration: AppGroupConfiguration = .init()
    ) {
        self.classificationBridge = classificationBridge
        self.appGroupConfiguration = appGroupConfiguration
    }
}
