/// Protocol defining the necessary methods for triggering speed updates.
/// Implementations are called from the main actor.
@MainActor
public protocol SpeedManagerTrigger {
    /// Starts the process for updating speed.
    ///
    /// Use this method to begin your custom trigger flow before calling ``startMonitoringSpeed()``.
    func startUpdatingSpeed()
    
    /// Starts monitoring the speed.
    ///
    /// Implementations should invoke the concrete speed-monitoring behavior.
    func startMonitoringSpeed()
}
