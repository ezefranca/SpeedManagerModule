# SpeedManagerModule
> Simple Speedometer class to iOS and WatchOS.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

Measure the speed using an iPhone or Apple Watch.

![](https://github.com/ezefranca/SpeedManagerModule/blob/main/banner.jpg?raw=true)

### Motivation

I like to measure my speed inside trains and buses. When I was searching for a speedometer app, the majority of them were ugly, with tons of ads. I was searching for an Apple Watch Speedometer with complications, iOS App with Widgets and did not found. Because of that I decided to create my own app. First thing was measure speed using `CLLocationManager`.

## Installation

The Swift Package Manager is the easiest way to install and manage SpeedManagerModule as a dependecy.
Simply add SpeedManagerModule to your dependencies in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/ezefranca/SpeedManagerModule.git")
]
```

### Update Info.plist

Add the correct permission descriptions
```
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
```

Add the background location updates in xcode

Or add the info to the Info.plist

```
    <key>UIBackgroundModes</key>
    <array>
        <string>location</string>
    </array>
```

## Usage example


### @StateObject

```swift
import SwiftUI

struct ContentView: View {
    
    @StateObject var speedManager = SpeedManager(.kilometersPerHour)
    
    var body: some View {
        VStack {
            switch speedManager.authorizationStatus {
            case .authorized:
                Text("Your current speed is:")
                Text("\(speedManager.speed)")
                Text("km/h")
            default:
                Spacer()
            }
        }
    }
}
```

### Using Delegates

``` swift

import UIKit

class SpeedViewController: UIViewController {

    var speedManager = SpeedManager(.kilometersPerHour)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speedManager.delegate = self
        self.speedManager.startUpdatingSpeed()
    }
}

extension SpeedViewController: SpeedManagerDelegate {
    
    func speedManager(_ manager: SpeedManager, didUpdateSpeed speed: Double) {
    }
    
    func speedManager(_ manager: SpeedManager, didFailWithError error: Error) {
    }
}

```

### Changing Unit

Just choose the unit during the class init.

```swift

    var speedManagerKmh = SpeedManager(.kilometersPerHour)
    var speedManagerMs = SpeedManager(.meterPerSecond)
    var speedManagerMph = SpeedManager(.milesPerHour)

```

## Meta

@ezefranca – [@ezefranca](https://twitter.com/ezefranca) 

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/ezefranca/SpeedManagerModule](https://github.com/ezefranca/SpeedManagerModule)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://github.com/git/git-scm.com/blob/main/MIT-LICENSE.txt
