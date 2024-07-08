/// Protocol defining the necessary methods for triggering speed updates.
public protocol SpeedManagerTrigger {
    /// Starts the process for updating speed.
    func startUpdatingSpeed()
    
    /// Starts monitoring the speed.
    func startMonitoringSpeed()
}
