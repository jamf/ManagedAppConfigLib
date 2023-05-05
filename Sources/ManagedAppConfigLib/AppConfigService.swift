/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2022-2023 Jamf
*/

import Foundation

extension Notification.Name {
    /// The notification that is sent when an ``AppConfig`` value may have been changed in the `UserDefaults` system.
    ///
    /// The specific values within AppConfig have not been tested for change, but they may have been modified.
    /// The `object` of the notification will be the `UserDefaults` object that generated the change.
    public static let appConfigMayHaveChanged = Self("appConfigMayHaveChanged")
}

/// An internal service class that keeps track of all used `UserDefaults` objects and listens for changes
/// to Managed App Configuration in them.
@available(macOS 11, iOS 7.0, tvOS 10.2, *)
class AppConfigService {
    static let shared = AppConfigService()

    private var dictionaries: [UserDefaults: [String: Any]] = [:]
    private var observers: [UserDefaults: any NSObjectProtocol] = [:]

    /// Tell the `AppConfigService` that a particular `UserDefaults` object should be used for app config.
    /// - Parameter userDefaults: The `UserDefaults` object to look for managed app config.
    func use(userDefaults: UserDefaults) {
        if dictionaries[userDefaults] == nil {
            // We haven't seen this user defaults previously;
            // load it's AppConfig dictionary and listen for changes to it.
            dictionaries[userDefaults] = userDefaults.dictionary(forKey: ManagedAppConfig.configurationKey) ?? [:]
            let center = NotificationCenter.default
            observers[userDefaults] = center.addObserver(forName: UserDefaults.didChangeNotification,
                                                         object: userDefaults,
                                                         queue: .main) { [weak self] (note: Notification) in
                guard let self = self else { return }
                if let defaults = note.object as? UserDefaults {
                    let newValues = defaults.dictionary(forKey: ManagedAppConfig.configurationKey) ?? [:]
                    // Because we can't easily check if specific values in the app config have changed,
                    // we send notifications when either
                    // 1) appConfig has been set with some values (maybe new, maybe something changed),
                    // or 2) previous appConfig was set but it is empty now (appConfig was removed).
                    let mustNotify = !newValues.isEmpty || !(self.dictionaries[defaults]?.isEmpty ?? true)
                    self.dictionaries[defaults] = newValues
                    if mustNotify {
                        // Need to let the ManagedAppConfig wrappers know we've possibly changed...
                        NotificationCenter.default.post(name: .appConfigMayHaveChanged, object: defaults)
                    }
                }
            }
        }
    }

    /// Grabs the appropriate AppConfig value for the key from the `UserDefaults` object.
    /// - Parameters:
    ///   - key: A key into the AppConfig dictionary
    ///   - defaults: The `UserDefaults` to use for AppConfig
    /// - Returns: Returns the value of the key whithin the AppConfig dictionary.
    func value<T>(for key: String, _ defaults: UserDefaults) -> T? {
        dictionaries[defaults]?[key] as? T
    }
}
