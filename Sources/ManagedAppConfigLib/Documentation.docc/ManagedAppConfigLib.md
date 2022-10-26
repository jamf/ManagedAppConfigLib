# ``ManagedAppConfigLib``

An interface to Managed App Configuration where apps can access key-value data managed by organizations.

## Overview

Managed App Configuration is a tool that organizational IT departments can use with a
[mobile device management (MDM) server](https://support.apple.com/guide/deployment/intro-to-mdm-depc0aadd3fe/web)
to deploy settings to apps on their employee's enrolled devices.   Managed App Configuration and
Feedback is supported on iOS 7+, macOS 11+, and tvOS 10.2+.

For more details, see the **Managed App Configuration and Feedback** section of the
 [Mobile Device Management Protocol Reference](https://developer.apple.com/business/documentation/MDM-Protocol-Reference.pdf).

#### Source Code

The source code for ManagedAppConfigLib can be found [on GitHub](https://github.com/jamf/ManagedAppConfigLib).

## Managed App Configuration

Settings applied by MDM servers are available within the app as a read-only dictionary of key-value pairs in
[`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults)
under the `com.apple.configuration.managed` key.

This library contains three different approaches to accessing the organization settings.  Use whichever
one most closely matches your app style, or mix and match any or all of them within the same app.

## Managed App Feedback

Some MDM servers support Managed App Feedback which allows the app to write values into `UserDefaults` under
the `com.apple.configuration.feedback` key and the operating system will asynchronously send those values
to the MDM server.  After the server has read the values they are typically removed from the feedback
dictionary by the system.  What the server does with the feedback values is dependent on the
specific MDM server implementation.

The object-oriented ``ManagedAppConfig`` can be used to easily set values into the feedback dictionary,
and be notified when the values have been removed by the system.

## Security Note

> Important: The managed app configuration and feedback dictionaries are stored as unencrypted files.
Do not store passwords or private keys in these dictionaries.

## Topics

### SwiftUI Property Wrapper

- ``AppConfig``

### AppKit/UIKit Property Wrapper (or Model Objects)

- ``AppConfigPlain``

### Object Oriented Access

- ``ManagedAppConfig``
