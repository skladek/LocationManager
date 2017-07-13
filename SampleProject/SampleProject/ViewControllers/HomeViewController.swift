import SKLocationManager
import UIKit

class HomeViewController: UIViewController {
    let locationManager: LocationManager

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        locationManager = LocationManager(permissionType: .always)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func requestAvailiabilityTapped() {
        let availability = locationManager.requestAvailability()

        if let error = availability.error {
            print(error.localizedDescription)
            if error.code == LocationError.Code.authorizationStatusNotDetermined.rawValue {
                // Request permission
            } else {
                // Handle denied/restricted/disabled state
            }

            return
        }

        // Location services is available
        print(availability.available)
    }

    @IBAction func requestPermissionTapped() {
        locationManager.requestAuthorization { (_) in }
    }

    @IBAction func startUpdatingLocation() {
        locationManager.startLocationUpdates { (locations, error) in
            print(locations ?? "")
        }
    }

    @IBAction func stopUpdatingLocation() {
        locationManager.stopLocationUpdates()
    }
}
