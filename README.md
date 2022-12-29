<p align="center" >
</p>

[![Swift Version][swift-image]][swift-url]
![Platform OS X | iOS ](https://img.shields.io/badge/platform-Linux%20%7C%20OS%20X%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-orange.svg)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Build Status](https://app.travis-ci.com/ezefranca/SpeedManagerModule.svg?branch=main)](https://travis-ci.com/ezefranca/SpeedManagerModule)
![github workflow](https://github.com/ezefranca/SpeedManagerModule/actions/workflows/swift.yml/badge.svg)
[![License][license-image]][license-url]
[![Twitter](https://img.shields.io/badge/twitter-@ezefranca-blue.svg?style=flat)](http://twitter.com/ezefranca)

# SpeedManagerModule
> Simple Speedometer class to iOS and WatchOS.

Measure the speed using an iPhone or Apple Watch.

<p align="center" >
  <img src="https://github.com/ezefranca/SpeedManagerModule/blob/main/banner.jpg" alt="SpeedManagerModule" title="SpeedManagerModule">
</p>


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

```xml
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Your description why you should use NSLocationAlwaysAndWhenInUseUsageDescription</string>
```

Add the background location updates in xcode

![](https://raw.githubusercontent.com/ezefranca/SpeedManagerModule/main/.github/backgroundmodes.png)

Or add the info to the Info.plist

```xml
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

### Demo 

Check the ```Demo``` folder to see it in action.


https://user-images.githubusercontent.com/3648336/208701407-ebf7319f-32c1-45bc-adc7-aa8509f0336d.mov


## Meta

@ezefranca – [@ezefranca](https://twitter.com/ezefranca) 

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/ezefranca/SpeedManagerModule](https://github.com/ezefranca/SpeedManagerModule)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://github.com/git/git-scm.com/blob/main/MIT-LICENSE.txt
