/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2017-2022 Jamf Open Source Community
*/

import Foundation

/// A class for working with Managed App Configuration values and Managed App Feedback.
///
/// The `ManagedAppConfig` class provides a programmatic interface for interacting with Managed App
/// Configuration and Managed App Feedback values.
@available(macOS 11.0, iOS 7.0, tvOS 10.2, *)
public class ManagedAppConfig {
    /// The `UserDefaults` key for Managed AppConfig
    public static let defaultsKey = "com.apple.configuration.managed"
    /// The `UserDefaults` key for Managed App Feedback
    public static let feedbackKey = "com.apple.feedback.managed"

   	/// Returns the shared Managed App Configuration object.
    /// - Returns: The shared Managed App Configuration object.
    ///
    /// If the shared Managed App Configuration object does not exist yet, it is created and listens for changes
    /// in the standard `UserDefaults`.
    public static let shared = ManagedAppConfig()

    /// A type representing a function to be called when Managed App Configuration or Feedback changes.
    ///
    /// It will receive the complete Managed App Configuration or Managed App Feedback dictionary.
    public typealias HookFunction = ([String: Any?]) -> Void

    private var configHooks = [HookFunction]()
    private var feedbackHooks = [HookFunction]()

    init() {
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(ManagedAppConfig.didChange),
                                               name: UserDefaults.didChangeNotification, object: nil)
    }

    /// Register a closure to be called when Managed App Configuration has values and may have been changed.
    /// - Parameter appConfigChangedHook: A closure to be called; receives the complete Managed App Configuration dictionary.
    public func addAppConfigChangedHook(_ appConfigChangedHook: @escaping HookFunction) {
        configHooks.append(appConfigChangedHook)
    }

    /// Register a closure to be called when Managed App Feedback has values and may have been changed.
    /// - Parameter appFeedbackChangedHook: A closure to be called; receives the complete Managed App Feedback dictionary.
    public func addAppFeedbackChangedHook(_ appFeedbackChangedHook: @escaping HookFunction) {
        feedbackHooks.append(appFeedbackChangedHook)
    }

    // called when the userdefaults did change notification fires
    @objc func didChange() {
        if let configDict = UserDefaults.standard.dictionary(forKey: Self.defaultsKey) {
            for hook in configHooks {
                hook(configDict)
            }
        }
        if let feedbackDict = UserDefaults.standard.dictionary(forKey: Self.feedbackKey) {
            for hook in feedbackHooks {
                hook(feedbackDict)
            }
        }
    }

    // MARK: - Dictionary getters/setters

    /// Gets the Managed App Configuration value for the given key.
    /// - Parameter forKey: The key to look for within Managed App Configuration.
    /// - Returns: The value within the Managed App Configuration dictionary, if any.
    public func getConfigValue(forKey: String) -> Any? {
        if let myAppConfig = UserDefaults.standard.dictionary(forKey: Self.defaultsKey) {
            return myAppConfig[forKey]
        }
        return nil
    }

    /// Gets the Managed App Feedback value for the given key.
    /// - Parameter forKey: The key to look for within Managed App Feedback.
    /// - Returns: The value within the Managed App Feedback dictionary.
    public func getFeedbackValue(forKey: String) -> Any? {
        if let myAppConfigFeedback = UserDefaults.standard.dictionary(forKey: Self.feedbackKey) {
            return myAppConfigFeedback[forKey]
        }
        return nil
    }

    /// Set or update a value within the Managed App Feedback dictionary.
    /// - Parameters:
    ///   - value: Set into the Managed App Feedback dictionary; must be one of the types supported by `UserDefaults`.
    ///   - forKey: The key to assign to within Managed App Feedback.
    public func updateValue(_ value: Any, forKey: String) {
        if var myAppConfigFeedback = UserDefaults.standard.dictionary(forKey: Self.feedbackKey) {
            myAppConfigFeedback[forKey] = value
            UserDefaults.standard.set(myAppConfigFeedback, forKey: Self.feedbackKey)
        } else {
            // there was no dictionary at all, create one and place the key/value pair in it
            let feedbackDict = [forKey: value]
            UserDefaults.standard.set(feedbackDict, forKey: Self.feedbackKey)
        }
    }
}
