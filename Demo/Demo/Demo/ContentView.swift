import SwiftUI
import SpeedManagerModule
import SpeedometerSwiftUI

extension Double {
    /// Returns the double value fixed to one decimal place.
    func fixedToOneDecimal() -> String {
        return String(format: "%.1f", self)
    }
}

struct ContentView: View {
    @StateObject var speedManager = SpeedManager(speedUnit: .kilometersPerHour)
    @State var progress: CGFloat = 0.0
    @State private var speed: TimeInterval = 0.01
    let maxSpeed: CGFloat = 200.0 // Define a constant maximum speed

    var body: some View {
        VStack {
            switch speedManager.authorizationStatus {
            case .authorized:
                Text("Your current speed is:")
                    .monospaced()
                Text("\(speedManager.speed.fixedToOneDecimal()) km/h")
                    .monospaced()
                
                TimelineView(.animation(minimumInterval: speed)) { context in
                    GaugeView(
                        animationDuration: speed,
                        progress: progress,
                        numberOfSegments: 200,
                        step: 20
                    )
                    .onChange(of: context.date) { oldValue, newValue in
                        updateProgress()
                    }
                    .frame(width: 300, height: 300)
                }
                
            default:
                Text("Check your location permissions...")
                ProgressView()
            }
        }
    }

    private func updateProgress() {
        withAnimation(.easeInOut(duration: 0.5)) {
            progress = CGFloat(speedManager.speed / maxSpeed)
        }
        speed = 0.01 // Adjust speed interval as needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
