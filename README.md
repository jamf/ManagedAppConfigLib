# ManagedAppConfigLib

## Overview
The purpose of ManagedAppConfigLib is to make it much easier to work with Apple's
[Managed App Configuration](https://developer.apple.com/library/content/samplecode/sc2279/Introduction/Intro.html)
by providing a class that manages access to it, as well as some property wrappers for modern Swift usage.
 
## Installation

### CocoaPods

Install via [Cocoapods](https://guides.cocoapods.org/using/getting-started.html) by adding the following to your Podfile under your desired targets:

```ruby
pod 'ManagedAppConfigLib'
```

### Swift Package Manager

Install with [Swift Package Manager](https://github.com/apple/swift-package-manager) by adding the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/jamf/ManagedAppConfigLib")
],
```

## Usage
You will need to `import ManagedAppConfigLib` in each Swift file you wish to use it.  You can choose
to use the property wrappers, or make use of the `ManagedAppConfig` class.

###  SwiftUI Property Wrapper

Functions much like the [@AppStorage](https://developer.apple.com/documentation/swiftui/appstorage)
property wrapper built in to SwiftUI.  Provides a type-safe read-only property that keeps itself
current with any changes in the AppConfig value, and causes a SwiftUI redraw when it's value changes.

```swift
// If AppConfig "title" doesn't exist or is not a string, will have the value "Default title".
@AppConfig("title") var title = "Default title"
// If AppConfig "featureEnabled" doesn't exist or is not a boolean, will have the value `false`.
@AppConfig("featureEnabled") var isEnabled: Bool = false
// If AppConfig "orgColor" doesn't exist or is not a string, this will be nil.
@AppConfig("orgColor") var organizationHexColor: String?
```

###  Non-SwiftUI Property Wrapper

Functions much like the `@AppConfig` property wrapper except that it does not require SwiftUI.
Provides a read-only property that keeps itself current with any changes in the AppConfig value.
This is useful for UIKit or AppKit code or simple Foundation code in models or cli tools.

```swift
// If AppConfig "title" doesn't exist or is not a string, will have the value "Default title".
@AppConfigPlain("title") var title = "Default title"
```

###  Simple functional use

* Retrieve a value set by MDM from the Managed App Configuration:
```swift
if let deviceId = ManagedAppConfig.shared.getConfigValue(forKey: "deviceId") as? String {
    print(deviceId)
}
```

* Register a closure to be executed when the managed app configuration dictionary is changed:
```swift
let myClosure = { (configDict: [String: Any?]) -> Void in
    print("managed app configuration changed")
}
ManagedAppConfig.shared.addAppConfigChangedHook(myClosure)

```

* Place a value into the managed app feedback dictionary:
```swift
let exampleKey = "errorCount"
let exampleValue = 0
ManagedAppConfig.shared.updateValue(exampleValue, forKey: exampleKey)

```
