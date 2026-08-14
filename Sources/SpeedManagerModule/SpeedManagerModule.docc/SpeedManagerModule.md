# ``SpeedManagerModule``

Read user speed from Core Location and expose updates through delegate callbacks and observable state.

## Overview

`SpeedManagerModule` provides a main-actor isolated ``SpeedManager`` type that requests location authorization, tracks speed updates, and converts speed values into a configured ``SpeedManagerUnit``.

Use this package when you need a lightweight abstraction over `CLLocationManager` focused on speed monitoring.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:AuthorizationAndBackgroundUpdates>

### Integration styles

- <doc:SwiftUIAndDelegateIntegration>

### Core APIs

- ``SpeedManager``
- ``SpeedManagerDelegate``
- ``SpeedManagerTrigger``
- ``SpeedManagerAuthorizationStatus``
- ``SpeedManagerUnit``
