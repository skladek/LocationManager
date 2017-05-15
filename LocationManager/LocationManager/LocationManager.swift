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

    private(set) var locationUpdate: LocationUpdate?

    let permissionType: PermissionType

    // MARK: Private Variables


    private let availability: Availability

    private let locationManager: CLLocationManager

    // MARK: Initialization Methods

    /// Initializes a Location Manager with the requested permission type.
    ///
    /// - Parameter permissionType: The permission type to initialize with.
    init(permissionType: PermissionType) {
        self.availability = LocationAvailability()
        self.locationManager = CLLocationManager()
        self.permissionType = permissionType

        super.init()

        locationManager.delegate = self
    }

    /// Iniializes a Location Manager with injectable properties for testing purposes only. Do not use this initializer in production.
    ///
    /// - Parameters:
    ///   - availability: Availability injectable
    ///   - locationManager: Location manager injectable
    ///   - permissionType: Permission type injectable
    init(availability: Availability, locationManager: CLLocationManager, permissionType: PermissionType) {
        self.availability = availability
        self.locationManager = locationManager
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
    func requestAvailability() -> Availability.AvailabilityStatus {
        let locationServicesAvailability = availability.servicesEnabled(CLLocationManager.locationServicesEnabled())
        let authorizationStatusAvailability = availability.authorizationStatus(CLLocationManager.authorizationStatus())

        if locationServicesAvailability.available == false {
            return locationServicesAvailability
        } else if authorizationStatusAvailability.available == false {
            return authorizationStatusAvailability
        }

        return (available: true, error: nil)
    }

    /// Starts updating the location and reports the location updates to the optional update object.
    ///
    /// - Parameter update: The closure to receive updates through.
    func startLocationUpdates(_ update: LocationUpdate?) {
        locationUpdate = update
        locationManager.startUpdatingLocation()
    }


    /// Stops updating the location.
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationUpdate = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError = LocationError(code: .unknown, message: error.localizedDescription)
        locationUpdate?(nil, locationError)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdate?(locations, nil)
    }
}
