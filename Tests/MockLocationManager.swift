import CoreLocation
import UIKit

class MockLocationManager: CLLocationManager {
    var requestAlwaysAuthorizationCalled = false
    var requestWhenInUseAuthorizationCalled = false
    var startUpdatingLocationCalled = false
    var stopUpdatingLocationCalled = false

    override func requestAlwaysAuthorization() {
        requestAlwaysAuthorizationCalled = true
    }

    override func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCalled = true
    }

    override func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }

    override func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }
}
