//
//  LocationManagerSpec.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import CoreLocation
import Foundation
import Nimble
import Quick

@testable import LocationManager

class LocationManagerSpec: QuickSpec {

    override func spec() {
        describe("LocationManager") {
            var availability: MockAvailability!
            var locationManager: MockLocationManager!
            var unitUnderTest: LocationManager!

            beforeEach {
                availability = MockAvailability()
                locationManager = MockLocationManager()
                unitUnderTest = LocationManager(availability: availability, locationManager: locationManager, permissionType: .always)
            }

            context("init(permissionType:)") {
                it("Should set the availability") {
                    unitUnderTest = LocationManager(permissionType: .always)
                    expect(unitUnderTest.availability).to(beAnInstanceOf(LocationAvailability.self))
                }

                it("Should set the location manager") {
                    unitUnderTest = LocationManager(permissionType: .always)
                    expect(unitUnderTest.locationManager).to(beAnInstanceOf(CLLocationManager.self))
                }

                it("Should set the permission type") {
                    unitUnderTest = LocationManager(permissionType: .always)
                    expect(unitUnderTest.permissionType.hashValue).to(equal(LocationManager.PermissionType.always.hashValue))
                }

                it("Should set the location manager delegate to self") {
                    unitUnderTest = LocationManager(permissionType: .always)
                    expect(unitUnderTest.locationManager.delegate).to(be(unitUnderTest))
                }
            }

            context("requestAvailability()") {
                it("Should return an availability status of true if authorization status and enabled return nil.") {
                    expect(unitUnderTest.requestAvailability().available).to(beTrue())
                }

                it("it should return the authorization availability status if enabled returns nil") {
                    availability.authorized = false
                    expect(unitUnderTest.requestAvailability().available).to(beFalse())
                }

                it("should return the enabled status if enabled returns a value") {
                    availability.servicesEnabled = false
                    expect(unitUnderTest.requestAvailability().available).to(beFalse())
                }
            }

            context("requestAuthorization()") {
                it("should call requestAlwaysAuthorization when permission type is set to always") {
                    unitUnderTest = LocationManager(availability: availability, locationManager: locationManager, permissionType: .always)
                    unitUnderTest.requestAuthorization()
                    expect(locationManager.requestAlwaysAuthorizationCalled).to(beTrue())
                }

                it("should call requestWhenInUseAuthorization when permission type is set to whenInUse") {
                    unitUnderTest = LocationManager(availability: availability, locationManager: locationManager, permissionType: .whenInUse)
                    unitUnderTest.requestAuthorization()
                    expect(locationManager.requestWhenInUseAuthorizationCalled).to(beTrue())
                }
            }

            context("startLocationUpdates(_:)") {
                it("should call start location updates") {
                    unitUnderTest.startLocationUpdates(nil)
                    expect(locationManager.startUpdatingLocationCalled).to(beTrue())
                }

                it("should set the location update property") {
                    unitUnderTest.startLocationUpdates({ (locations, error) in })
                    expect(unitUnderTest.locationUpdate).toNot(beNil())
                }
            }

            context("stopLocationUpdates()") {
                it("should call stop location updates") {
                    unitUnderTest.stopLocationUpdates()
                    expect(locationManager.stopUpdatingLocationCalled).to(beTrue())
                }

                it("should clear the location update") {
                    unitUnderTest.startLocationUpdates({ (locations, error) in })
                    unitUnderTest.stopLocationUpdates()
                    expect(unitUnderTest.locationUpdate).to(beNil())
                }
            }

            context("locationManager(_:didFailWithError:)") {
                it("should set the error in the location update variable") {
                    waitUntil(timeout: 10) { done in
                        unitUnderTest.startLocationUpdates({ (locations, error) in
                            expect(error?.localizedDescription).to(equal("testErrorDescription"))
                            done()
                        })

                        let error = NSError(domain: "test.Error.Domain", code: 0, userInfo: [NSLocalizedDescriptionKey : "testErrorDescription"])
                        unitUnderTest.locationManager(locationManager, didFailWithError: error)
                    }
                }
            }

            context("locationManager(_:didUpdateLocations:)") {
                it("should set the locations in the location update variable") {
                    waitUntil(timeout: 10) { done in
                        unitUnderTest.startLocationUpdates({ (locations, error) in
                            expect(locations?.first?.coordinate.latitude).to(equal(20))
                            expect(locations?.first?.coordinate.longitude).to(equal(40))
                            done()
                        })

                        let location = CLLocation(latitude: 20, longitude: 40)
                        unitUnderTest.locationManager(locationManager, didUpdateLocations: [location])
                    }
                }
            }
        }
    }
}
