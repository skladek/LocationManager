//
//  LocationAvailability.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
import Foundation

class LocationAvailability {

    // MARK: Class Types

    // A tuple to describe location availability with an error if location is unavailable.
    typealias Availability = (available: Bool, error: NSError?)

    /// Returns an availability object to describe availiability in reference to the authorization status.
    ///
    /// - Parameter authorizationStatus: The authorization status to check availiability against
    /// - Returns: The current availability
    static func authorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> Availability? {
        let code: LocationError.Code
        let message: String

        switch authorizationStatus {
        case .authorizedAlways,
             .authorizedWhenInUse:
            return (available: true, error: nil)
        case .denied:
            code = .authorizationStatusDenied
            message = "Location services permission denied."
        case .notDetermined:
            code = .authorizationStatusNotDetermined
            message = "Location services authorization is not yet determined."
        case .restricted:
            code = .authorizationStatusRestricted
            message = "This app is not authorized to use location services."
        }

        let error = LocationError(code: code, message: message)

        return (available: false, error: error)
    }

    /// Returns an availability object to describe availiability as it relates to the enabled status of Location Services.
    ///
    /// - Parameter enabled: A boolean describing if location services are enabled
    /// - Returns: The current availability
    static func locationServicesEnabled(_ enabled: Bool) -> Availability? {
        if !enabled {
            let error = LocationError(code: .locationServicesDisabled, message: "Location services is currently disabled")

            return (available: false, error: error)
        }

        return nil
    }
}
