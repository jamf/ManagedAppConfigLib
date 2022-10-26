# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
