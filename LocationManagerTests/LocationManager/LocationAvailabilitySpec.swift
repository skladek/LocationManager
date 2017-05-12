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
            context("init(objects:cellReuseId:)") {
                it("should pass") {
                    expect(1).to(equal(1))
                }
            }
        }
    }
}
