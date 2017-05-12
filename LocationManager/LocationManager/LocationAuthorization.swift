//
//  LocationAuthorization.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
import Foundation

class LocationAuthorization {
    typealias Availability = (available: Bool, error: NSError?)

    static func authorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> Availability? {
        let code: LocationError.ErrorCode
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

    static func locationSerivicesEnabled(_ enabled: Bool) -> Availability? {
        if !enabled {
            let error = LocationError(code: .locationServicesDisabled, message: "Location services is currently disabled")

            return (available: false, error: error)
        }

        return nil
    }
}
