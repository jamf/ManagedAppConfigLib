/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2017-2022 Jamf Open Source Community
*/

import Foundation

public class ManagedAppConfig {
    
    enum DictionaryType {
        case AppConfig
        case Feedback
    }
    
   	// singleton
    public static let shared = ManagedAppConfig()
    
    private let kFeedbackKey = "com.apple.feedback.managed"
    private let kConfigurationKey = "com.apple.configuration.managed"
    
    private var configHooks = [([String:Any?]) -> Void]()
    private var feedbackHooks = [([String:Any?]) -> Void]()

    init() {
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(ManagedAppConfig.didChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    // instead of modifying this file's didChange event, allow the registration of closures
    public func addAppConfigChangedHook(_ appConfigChangedHook: @escaping ([String:Any?]) -> Void) {
        configHooks.append(appConfigChangedHook)
    }
    
    // called when the userdefaults did change notification fires
    @objc func didChange() {
        if let configDict = UserDefaults.standard.dictionary(forKey: kConfigurationKey) {
            for hook in configHooks {
                hook(configDict)
            }
        }
        if let feedbackDict = UserDefaults.standard.dictionary(forKey: kFeedbackKey) {
            for hook in feedbackHooks {
                hook(feedbackDict)
            }
        }
    }
    
    // MARK - Dictionary getters/setters
    public func getConfigValue(forKey: String) -> Any? {
        if let myAppConfig = UserDefaults.standard.dictionary(forKey: kConfigurationKey) {
            return myAppConfig[forKey]
        }
        return nil
    }
    
    public func getFeedbackValue(forKey: String) -> Any? {
        if let myAppConfigFeedback = UserDefaults.standard.dictionary(forKey: kFeedbackKey) {
            return myAppConfigFeedback[forKey]
        }
        return nil
    }
    
    public func updateValue(_ value: Any, forKey: String) {
        if var myAppConfigFeedback = UserDefaults.standard.dictionary(forKey: kFeedbackKey) {
            myAppConfigFeedback[forKey] = value
            UserDefaults.standard.set(myAppConfigFeedback, forKey: kFeedbackKey)
        } else {
            // there was no dictionary at all, create one and place the key/value pair in it
            let feedbackDict = [forKey: value]
            UserDefaults.standard.set(feedbackDict, forKey: kFeedbackKey)
        }
    }
    
    

}
