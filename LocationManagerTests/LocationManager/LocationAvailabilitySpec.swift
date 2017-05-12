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

@testable import LocationManager

class LocationAvailabilitySpec: QuickSpec {

    override func spec() {
        describe("LocationAvailability") {
            context("authorizationStatus(_:)") {
                it("should return nil for authorization status always") {
                    expect(LocationAvailability.authorizationStatus(.authorizedAlways)).to(beNil())
                }

                it("should return nil for authorization status when in use") {
                    expect(LocationAvailability.authorizationStatus(.authorizedWhenInUse)).to(beNil())
                }

                it("should retun an availability object with a configured error for authorization status denied") {
                    let availability = LocationAvailability.authorizationStatus(.denied)
                    expect(availability?.error?.code).to(equal(LocationError.Code.authorizationStatusDenied.rawValue))
                }

                it("should retun an availability object with a configured error for authorization status not determined") {
                    let availability = LocationAvailability.authorizationStatus(.notDetermined)
                    expect(availability?.error?.code).to(equal(LocationError.Code.authorizationStatusNotDetermined.rawValue))
                }

                it("should retun an availability object with a configured error for authorization status restricted") {
                    let availability = LocationAvailability.authorizationStatus(.restricted)
                    expect(availability?.error?.code).to(equal(LocationError.Code.authorizationStatusRestricted.rawValue))
                }
            }

            context("locationServicesEnabled(_:)") {
                it("should return nil for an enabled value of true") {
                    expect(LocationAvailability.locationServicesEnabled(true)).to(beNil())
                }

                it("should return an availability object with a configured error for an enabled value of false") {
                    let availability = LocationAvailability.locationServicesEnabled(false)
                    expect(availability?.error?.code).to(equal(LocationError.Code.locationServicesDisabled.rawValue))
                }
            }
        }
    }
}
