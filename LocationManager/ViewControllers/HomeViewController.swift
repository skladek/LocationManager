//
//  HomeViewController.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let locationManager: LocationManager

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        locationManager = LocationManager(permissionType: .whenInUse)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func requestAvailiabilityTapped() {
        let availability = locationManager.requestAvailability()

        if let error = availability.error {
            print(error.localizedDescription)
            if error.code == LocationManager.ErrorCode.authorizationStatusNotDetermined.rawValue {
                // Request permission
            } else {
                // Handle denied/restricted/disabled state
            }

            return
        }

        // Location services is available
    }

    @IBAction func requestLocationOnce() {
        locationManager.requestLocation({ (location, error) in
            print("Location: \(String(describing: location))")
            print("Error: \(String(describing: error))")
        })
    }

    @IBAction func requestPermissionTapped() {
        locationManager.requestAuthorization()
    }
}
