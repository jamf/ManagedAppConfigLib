# ``ManagedAppConfigLib/ManagedAppConfig``

## Examples

#### Retrieve a Managed App Configuration value
```swift
if let deviceId = ManagedAppConfig.shared.getConfigValue(forKey: "deviceId") as? String {
    print(deviceId)
}
```

#### Register a closure to be executed when Managed App Configuration changes
```swift
let myClosure = { (configDict: [String: Any?]) -> Void in
    print("Managed App Configuration changed")
}
ManagedAppConfig.shared.addAppConfigChangedHook(myClosure)
```

#### Place a value into Managed App Feedback
```swift
let numberOfErrors = 0
ManagedAppConfig.shared.updateValue(numberOfErrors, forKey: "errorCount")
```

## Topics

### Getting the Shared ManagedAppConfig Object

- ``shared``

### Read Managed App Configuration

- ``getConfigValue(forKey:)``

### Access Managed App Feedback

- ``getFeedbackValue(forKey:)``
- ``updateValue(_:forKey:)``

### Be Called When Changes Occur

- ``HookFunction``
- ``addAppConfigChangedHook(_:)``
- ``addAppFeedbackChangedHook(_:)``

### UserDefaults Keys

- ``configurationKey``
- ``feedbackKey``
