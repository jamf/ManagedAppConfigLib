/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2022 Jamf Open Source Community
*/

import Foundation
import SwiftUI

/// A property wrapper type that reflects a value from Managed App Config (via `UserDefaults`) and
/// invalidates a SwiftUI view on a change in value in that Managed App Config.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper public struct AppConfig<Value>: DynamicProperty {
    // Very simple listener that observes AppConfig changes, and has a local copy of the AppConfig's value.
    private final class Listener<Value>: ObservableObject {
        var subscriber: NSObjectProtocol?
        var value: Value? {
            willSet {
                self.objectWillChange.send()
            }
        }

        func listenTo(store: UserDefaults, key: String, defaultValue: Value) {
            if subscriber == nil {
                AppConfigService.shared.use(userDefaults: store)
                value = AppConfigService.shared.value(for: key, store) ?? defaultValue
                subscriber = NotificationCenter.default.addObserver(forName: .appConfigMayHaveChanged,
                                                    object: store, queue: nil) { [weak self] _ in
                    guard let self = self else { return }
                    self.value = AppConfigService.shared.value(for: key, store) ?? defaultValue
                }
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self, name: .appConfigMayHaveChanged, object: nil)
        }
    }

    /// This object is the dynamic listener for changes to the app config.
    ///
    /// Thanks to `DynamicProperty` conformance, when this object sends it's `objectWillChange` message
    /// SwiftUI will redraw any views depending on this property wrapper.
    @StateObject private var core = Listener<Value>()
    private let key: String
    private let defaults: UserDefaults
    private let defaultValue: Value

    /// The value from AppConfig or the defaultValue provided to the initializer.
    public var wrappedValue: Value {
        core.value ?? defaultValue
    }

    /// Update the value by reading the `UserDefaults` and listening for changes.
    ///
    /// SwiftUI will call this automatically before drawing views with `@AppConfig` properties.
    public func update() {
        core.listenTo(store: self.defaults, key: key, defaultValue: defaultValue)
    }

    // MARK: Initializers

    /// Initializer for standard types
    public init(wrappedValue defaultValue: Value, _ key: String, store: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaults = store
        self.defaultValue = defaultValue
    }

    /// Initializer for optional types; the default value is always nil
    public init(_ key: String, store: UserDefaults = UserDefaults.standard) where Value: ExpressibleByNilLiteral {
        self.key = key
        self.defaultValue = nil
        self.defaults = store
    }
}
