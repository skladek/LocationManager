//
//  Availability.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
import Foundation

public protocol Availability {
    // A tuple to describe availability status with an error if the service is unavailable.
    typealias AvailabilityStatus = (available: Bool, error: LocationError?)

    func authorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> AvailabilityStatus
    func servicesEnabled(_ enabled: Bool) -> AvailabilityStatus
}
