//
//  LocationManager.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject {
    enum PermissionType {
        case always
        case whenInUse
    }

    typealias LocationRequest = (_ locations: [CLLocation]?, _ error: NSError?) -> ()

    let locationManager = CLLocationManager()

    var locationRequest: LocationRequest?

    let permissionType: PermissionType

    // MARK: Initialization Methods

    /// Initializes a Location Manager with the requested permission type.
    ///
    /// - Parameter permissionType: The permission type to initialize with.
    init(permissionType: PermissionType) {
        self.permissionType = permissionType

        super.init()

        locationManager.delegate = self
    }

    // MARK: Public Methods

    func requestAuthorization() {
        if self.permissionType == .always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func requestAvailability() -> LocationAuthorization.Availability {
        if let locationServicesUnavailability = LocationAuthorization.locationSerivicesEnabled(CLLocationManager.locationServicesEnabled()) {
            return locationServicesUnavailability
        }

        if let authorizationStatusUnavailability = LocationAuthorization.authorizationStatus(CLLocationManager.authorizationStatus()) {
            return authorizationStatusUnavailability
        }

        return (available: true, error: nil)
    }

    func startLocationUpdates(_ completion: @escaping LocationRequest) {
        locationRequest = completion
        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationRequest = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError = LocationError(code: .unknown, message: error.localizedDescription)
        locationRequest?(nil, locationError)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationRequest?(locations, nil)
    }
}
