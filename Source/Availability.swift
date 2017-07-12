import CoreLocation
import Foundation

public protocol Availability {
    // A tuple to describe availability status with an error if the service is unavailable.
    typealias AvailabilityStatus = (available: Bool, error: LocationError?)

    func authorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> AvailabilityStatus
    func servicesEnabled(_ enabled: Bool) -> AvailabilityStatus
}
