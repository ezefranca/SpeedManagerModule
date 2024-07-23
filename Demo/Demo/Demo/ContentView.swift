import SwiftUI
import SpeedManagerModule
import SpeedometerSwiftUI

struct ContentView: View {
    @StateObject var speedManager = SpeedManager(speedUnit: .kilometersPerHour)
    @State var progress: CGFloat = 0.0
    let maxSpeed: CGFloat = 200.0

    var body: some View {
        VStack {
            switch speedManager.authorizationStatus {
            case .authorized:
                Text("Your current speed is:")
                    .monospaced()
                Text("\(speedManager.speed.fixedToOneDecimal()) km/h")
                    .monospaced()
                
                GaugeView(
                    animationDuration: 0.1,
                    progress: progress,
                    numberOfSegments: 200,
                    step: 20
                )
                .frame(width: 300, height: 300)
                .onAppear {
                    updateProgress()
                }
                .onChange(of: speedManager.speed) { newSpeed in
                    updateProgress()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Double {
    /// Returns the double value fixed to one decimal place.
    func fixedToOneDecimal() -> String {
        return String(format: "%.1f", self)
    }
}
