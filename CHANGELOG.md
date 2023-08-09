# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2023-08-11
### Fixed
- Updated podspec file to target iOS 9 and higher to work around a problem with CocoaPods and Xcode 14.3+ ([Issue #8](https://github.com/jamf/ManagedAppConfigLib/issues/8)) [@macblazer](https://github.com/macblazer).

### Changed
- Simplified the nested `Listener` type definition inside of the two property wrappers to be Swift 6 compatible.
- To improve code security, all commits going forward now require a [verified signature](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).

## [1.1.1] - 2023-05-08
### Added
- Added CODEOWNERS file.

### Fixed
- Fixed issue compiling for iOS and tvOS [PR #6](https://github.com/jamf/ManagedAppConfigLib/pull/6) [@crakaC](https://github.com/crakaC).

### Changed
- Updated GitHub action to run tests on macOS, iOS, and tvOS.
- Updated copyright to be simply "Jamf".

## [1.1.0] - 2022-10-28
### Added
- Property wrapper for SwiftUI and non-SwiftUI to make grabbing AppConfig values very simple.
- Additional documentation for use with DocC.
- Add unit tests and run them through GitHub Actions when swift files change.
- Publish docs from main branch in GitHub Actions.

### Changed
- Updated documentation for `ManagedAppConfig` class.
- Reorganized the source code to match Swift Package Manager standard folder structure.
- Marked all public types with appropriate `@available` tags based on OS support of Managed App Configuration.

## [1.0.0] - 2017-07-27
### Added
- Initial release.
