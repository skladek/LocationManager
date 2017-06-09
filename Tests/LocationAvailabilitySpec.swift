//
//  LocationAvailabilitySpec.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SKLocationManager

class LocationAvailabilitySpec: QuickSpec {

    override func spec() {
        describe("LocationAvailability") {
            var unitUnderTest: LocationAvailability!

            beforeEach {
                unitUnderTest = LocationAvailability()
            }

            context("authorizationStatus(_:)") {
                it("should return an availability object with a true availability and nil error for authorization status always") {
                    expect(unitUnderTest.authorizationStatus(.authorizedAlways).available).to(beTrue())
                    expect(unitUnderTest.authorizationStatus(.authorizedAlways).error).to(beNil())
                }

                it("should return an availability object with a true availability and nil error for authorization status when in use") {
                    expect(unitUnderTest.authorizationStatus(.authorizedWhenInUse).available).to(beTrue())
                    expect(unitUnderTest.authorizationStatus(.authorizedWhenInUse).error).to(beNil())
                }

                it("should retun an availability object with a configured error for authorization status denied") {
                    let availability = unitUnderTest.authorizationStatus(.denied)
                    expect(availability.error?.code).to(equal(LocationError.Code.authorizationStatusDenied.rawValue))
                }

                it("should retun an availability object with a configured error for authorization status not determined") {
                    let availability = unitUnderTest.authorizationStatus(.notDetermined)
                    expect(availability.error?.code).to(equal(LocationError.Code.authorizationStatusNotDetermined.rawValue))
                }

                it("should retun an availability object with a configured error for authorization status restricted") {
                    let availability = unitUnderTest.authorizationStatus(.restricted)
                    expect(availability.error?.code).to(equal(LocationError.Code.authorizationStatusRestricted.rawValue))
                }
            }

            context("locationServicesEnabled(_:)") {
                it("should return an availability object with a true availability and nil error for an enabled value of true") {
                    expect(unitUnderTest.servicesEnabled(true).available).to(beTrue())
                    expect(unitUnderTest.servicesEnabled(true).error).to(beNil())
                }

                it("should return an availability object with a configured error for an enabled value of false") {
                    let availability = unitUnderTest.servicesEnabled(false)
                    expect(availability.error?.code).to(equal(LocationError.Code.locationServicesDisabled.rawValue))
                }
            }
        }
    }
}
