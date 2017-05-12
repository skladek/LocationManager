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
    enum ErrorCode: Int {
        case unknown = -1
        case locationServicesDisabled
        case authorizationStatusDenied
        case authorizationStatusNotDetermined
        case authorizationStatusRestricted
    }

    enum PermissionType {
        case always
        case whenInUse
    }

    typealias Availability = (available: Bool, error: NSError?)

    typealias LocationRequest = (_ locations: [CLLocation]?, _ error: NSError?) -> ()

    static let errorDomain = "com.skladek.locationManager"

    let locationManager = CLLocationManager()

    var locationRequest: LocationRequest?

    let permissionType: PermissionType


    init(permissionType: PermissionType) {
        self.permissionType = permissionType

        super.init()

        locationManager.delegate = self
    }

    func requestAuthorization() {
        if self.permissionType == .always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func requestAvailability() -> Availability {
        if let locationServicesUnavailability = locationSerivicesEnabled() {
            return locationServicesUnavailability
        }

        if let authorizationStatusUnavailability = authorizationStatus() {
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

    private func authorizationStatus() -> Availability? {
        let code: ErrorCode
        let message: String

        switch CLLocationManager.authorizationStatus() {
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

        let error = self.error(code: code, message: message)

        return (available: false, error: error)
    }

    fileprivate func error(code: ErrorCode, message: String?) -> NSError {
        var localizedDescription = message

        if code == .unknown && message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [AnyHashable : Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey : message]
        }

        return NSError(domain: LocationManager.errorDomain, code: code.rawValue, userInfo: userInfo)
    }

    private func locationSerivicesEnabled() -> Availability? {
        if !CLLocationManager.locationServicesEnabled() {
            let error = self.error(code: .locationServicesDisabled, message: "Location services is currently disabled")

            return (available: false, error: error)
        }

        return nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError = self.error(code: .unknown, message: error.localizedDescription)
        locationRequest?(nil, locationError)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationRequest?(locations, nil)
    }
}
