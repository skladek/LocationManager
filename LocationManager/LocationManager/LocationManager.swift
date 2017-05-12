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

    // MARK: Class Types

    /// The location permission level.
    ///
    /// - always: Location permission is always available.
    /// - whenInUse: Location permission is only available when the app is in use.
    enum PermissionType {
        case always
        case whenInUse
    }

    /// An object to send and receive location updates through.
    typealias LocationUpdate = (_ locations: [CLLocation]?, _ error: NSError?) -> ()

    // MARK: Public Variables

    let permissionType: PermissionType

    // MARK: Private Variables

    fileprivate var locationUpdater: LocationUpdate?

    private let locationManager = CLLocationManager()

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

    /// Requests authorization with the current permission type from the location manager object.
    func requestAuthorization() {
        if self.permissionType == .always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /// Requests an availability object describing the current availability state.
    ///
    /// - Returns: An availability object describing the current state.
    func requestAvailability() -> LocationAvailability.Availability {
        if let locationServicesUnavailability = LocationAvailability.locationServicesEnabled(CLLocationManager.locationServicesEnabled()) {
            return locationServicesUnavailability
        }

        if let authorizationStatusUnavailability = LocationAvailability.authorizationStatus(CLLocationManager.authorizationStatus()) {
            return authorizationStatusUnavailability
        }

        return (available: true, error: nil)
    }

    /// Starts updating the location and reports the location updates to the optional update object.
    ///
    /// - Parameter update: The closure to receive updates through.
    func startLocationUpdates(_ update: LocationUpdate?) {
        locationUpdater = update
        locationManager.startUpdatingLocation()
    }


    /// Stops updating the location.
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationUpdater = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError = LocationError(code: .unknown, message: error.localizedDescription)
        locationUpdater?(nil, locationError)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdater?(locations, nil)
    }
}
