//
//  LocationManagerSpec.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import LocationManager

class LocationManagerSpec: QuickSpec {

    override func spec() {
        describe("LocationManager") {
            var availability: MockAvailability!
            var unitUnderTest: LocationManager!

            beforeEach {
                availability = MockAvailability()
                unitUnderTest = LocationManager(availability: availability, permissionType: .always)
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
        }
    }
}
