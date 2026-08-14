# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 - Unreleased

### Added
- Swift 6 language mode in `Package.swift`.
- Main-actor isolation for public protocols and `SpeedManager`.
- Cross-platform compilation fallback when `CoreLocation` is unavailable.
- Expanded deterministic unit tests for trigger/delegate/state behavior.
- Swift Package Index configuration via `.spi.yml`.

### Changed
- `SpeedManagerAuthorizationStatus` now conforms to `Sendable` and `Equatable`.
- `SpeedManagerUnit` now conforms to `Sendable`.
- README rewritten with Swift 6, concurrency, testing, and documentation guidance.

### Breaking
- Public protocols and `SpeedManager` are now `@MainActor` isolated, which requires main-actor access from client code.
