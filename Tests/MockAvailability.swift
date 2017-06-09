//
//  MockAvailability.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
@testable import SKLocationManager

class MockAvailability: Availability {
    var authorized = true
    var servicesEnabled = true

    func authorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> AvailabilityStatus {
        return (available: authorized, error: nil)
    }

    func servicesEnabled(_ enabled: Bool) -> AvailabilityStatus {
        return (available: self.servicesEnabled, error: nil)
    }
}
