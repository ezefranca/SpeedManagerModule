//
//  ContentView.swift
//  Demo
//
//  Created by Ezequiel Santos on 19/12/2022.
//

import SwiftUI
import SpeedManagerModule

struct ContentView: View {
    @StateObject var speedManager = SpeedManager(.kilometersPerHour)
    
    var body: some View {
        VStack {
            switch speedManager.authorizationStatus {
            case .authorized:
                Text("Your current speed is:")
                Text("\(speedManager.speed.fixed())")
                Text("km/h")
                
                CustomGauge(currentSpeed: $speedManager.speed)
                
            default:
                Text("Check your location permissions...")
                ProgressView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

