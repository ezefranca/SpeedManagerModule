/// Protocol defining the necessary methods for triggering speed updates.
/// Implementations are called from the main actor.
@MainActor
public protocol SpeedManagerTrigger {
    /// Starts the process for updating speed.
    func startUpdatingSpeed()
    
    /// Starts monitoring the speed.
    func startMonitoringSpeed()
}
