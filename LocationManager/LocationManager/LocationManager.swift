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

    typealias LocationRequest = (_ location: CLLocation?, _ error: Error?) -> ()

    let locationManager = CLLocationManager()

    var oneTimeLocationRequestCompletion: LocationRequest?

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

    func requestLocation(_ completion: @escaping LocationRequest) {
        oneTimeLocationRequestCompletion = completion
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let oneTimeRequest = oneTimeLocationRequestCompletion {
            oneTimeRequest(nil, error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        if let oneTimeRequest = oneTimeLocationRequestCompletion {
            oneTimeRequest(location, nil)
        }
    }
}
