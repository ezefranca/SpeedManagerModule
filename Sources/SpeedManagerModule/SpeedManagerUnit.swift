import Foundation

/// Enumeration representing the units of speed measurement.
public enum SpeedManagerUnit: Double, Sendable {
    /// Meters per second.
    case metersPerSecond = 1.0

    /// Kilometers per hour.
    case kilometersPerHour = 3.6

    /// Miles per hour.
    case milesPerHour = 2.23694
}
