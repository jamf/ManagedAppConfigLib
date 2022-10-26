# ``ManagedAppConfigLib/AppConfig``

## Example

Here is an example view that displays some text based on Managed App Configuration.  If the
key `title` doesn't exist or is not a String, the property will have the value "Default title".
The subtitle is optional and will only display if the key `subtitle` is present.

```swift
import ManagedAppConfigLib
import SwiftUI

struct ContentView: View {
    @AppConfig("title") private var displayTitle = "Default title"
    @AppConfig("subtitle") private var subTitle: String?

    var body: some View {
        VStack {
            Text(displayTitle).font(.headline)
            if let text = subTitle {
                Text(text).font(.subheadline)
            }
        }
        .padding()
    }
}
```

## Topics

### Reading a Managed App Configuration value with default

- ``init(wrappedValue:_:store:)``

### Reading an optional Managed App Configuration value

- ``init(_:store:)``

### Getting the value

- ``wrappedValue``

### DynamicProperty Implementation

- ``update()``
