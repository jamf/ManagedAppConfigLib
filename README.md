# ManagedAppConfigLib

## Overview
The purpose of ManagedAppConfigLib is to make it that much easier to work with Apple's [Managed App Configuration](https://developer.apple.com/library/content/samplecode/sc2279/Introduction/Intro.html) by providing a few convenience methods.
 
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
You will need to `import ManagedAppConfigLib` in each Swift file you wish to use it.

* Retrieve a value set by MDM from the Managed App Configuration:
```swift
if let deviceId = ManagedAppConfig.shared.getConfigValue(forKey: "deviceId") as? String {
    print(deviceId)
}
```

* Register a closure to be executed when the managed app configuration dictionary is changed:
```swift
let myClosure = { (configDict: [String : Any?]) -> Void in
    print("mannaged app configuration changed")
}
ManagedAppConfig.shared.addAppConfigChangedHook(myClosure)

```

* Place a value into the managed app feedback dictionary:
```swift
let exampleKey = "errorCount"
let exampleValue = 0
ManagedAppConfig.shared.updateValue(exampleValue, forKey: exampleKey)

```

