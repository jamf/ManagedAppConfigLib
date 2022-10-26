/*
    SPDX-License-Identifier: MIT
    Copyright (c) 2022 Jamf Open Source Community
*/

import Foundation

/// A read-only property wrapper type that reflects a value from Managed App Configuration
/// (via `UserDefaults`) and keeps itself up to date with changes in value in that Managed App Configuration.
///
/// Can be used outside of SwiftUI.
///
/// If used in a SwiftUI view, does **not** trigger a SwiftUI view redraw when the
/// Managed App Configuration value changes.  See ``AppConfig`` if you want a SwiftUI view to redraw on update
/// of a Managed App Configuration value.
@available(macOS 11, iOS 7.0, tvOS 10.2, *)
@propertyWrapper public struct AppConfigPlain<Value> {
    // Very simple listener that observes AppConfig changes, and updates it's internal copy of the value as needed.
    private final class Listener<Value> {
        var subscriber: NSObjectProtocol?
        var value: Value?

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

    /// This object is the dynamic listener for changes to the app config and storage for the value.
    private var listener = Listener<Value>()
    private let defaultValue: Value

    /// The value from Managed App Configuration or the defaultValue provided to the initializer.
    public var wrappedValue: Value {
        listener.value ?? defaultValue
    }

    // MARK: - Initializers

    /// Initializer for standard types.
    ///
    /// The `store` parameter is useful for unit tests or reading values from other suites.
    /// - Parameters:
    ///   - defaultValue: The default value for the property if the Managed App Configuration value is not set.
    ///   - key: A key into the Managed App Configuration dictionary.
    ///   - store: A `UserDefaults` object; defaults to the `.standard` object if not given.
    public init(wrappedValue defaultValue: Value, _ key: String, store: UserDefaults = UserDefaults.standard) {
        self.defaultValue = defaultValue
        listener.listenTo(store: store, key: key, defaultValue: defaultValue)
    }

    /// Initializer for optional types; their default value is always nil.
    ///
    /// The `store` parameter is useful for unit tests or reading values from other suites.
    /// - Parameters:
    ///   - key: A key into the Managed App Configuration dictionary.
    ///   - store: A `UserDefaults` object; defaults to the `.standard` object if not given.
    public init(_ key: String, store: UserDefaults = UserDefaults.standard) where Value: ExpressibleByNilLiteral {
        self.defaultValue = nil
        listener.listenTo(store: store, key: key, defaultValue: nil)
    }
}
