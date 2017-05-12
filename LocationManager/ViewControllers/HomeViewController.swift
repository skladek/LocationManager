//
//  HomeViewController.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var locationManager: LocationManager?

    @IBAction func requestLocationOnce() {
        locationManager?.requestLocation({ (location, error) in
            print("Location: \(String(describing: location))")
            print("Error: \(String(describing: error))")
        })
    }

    @IBAction func requestPermissionTapped() {
        locationManager?.requestAuthorization()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = LocationManager(permissionType: .whenInUse)
    }
}
