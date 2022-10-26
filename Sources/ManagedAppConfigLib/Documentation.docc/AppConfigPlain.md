# ``ManagedAppConfigLib/AppConfigPlain``

## Example

This example has the property wrapper being used in a struct that represents the application
settings.  This lets an IT organization override the default title and the starting quantity.

```swift
import ManagedAppConfigLib

struct AppSettings {
    @AppConfigPlain("title") var defaultTitle = "Default title"
    @AppConfigPlain("quantity") var startingAmount: Int = 0

    var actualAmount: Int
}
```

## Topics

### Reading a Managed App Configuration value with default

- ``init(wrappedValue:_:store:)``

### Reading an optional Managed App Configuration value

- ``init(_:store:)``

### Getting the value

- ``wrappedValue``
