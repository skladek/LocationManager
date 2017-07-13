import Foundation
import Nimble
import Quick

@testable import SKLocationManager

class LocationErrorSpec: QuickSpec {

    override func spec() {
        describe("LocationError") {
            var unitUnderTest: LocationError!

            context("init(code:message:)") {
                it("Should return an error with the specified code and message") {
                    let code: LocationError.Code = .unknown
                    let message = "testMessage"
                    unitUnderTest = LocationError(code: code, message: message)

                    expect(unitUnderTest.code).to(equal(LocationError.Code.unknown.rawValue))
                    expect(unitUnderTest.localizedDescription).to(equal(message))
                }

                it("Should use a default message if the code equals unknown and message is nil") {
                    unitUnderTest = LocationError(code: .unknown, message: nil)
                    expect(unitUnderTest.localizedDescription).to(equal("An unknown error occurred."))
                }

                it("Should not use a default message if the code does not equal unknown and message is nil") {
                    unitUnderTest = LocationError(code: .authorizationStatusDenied, message: nil)
                    expect(unitUnderTest.localizedDescription).toNot(equal("An unknown error occurred."))
                }
            }

            context("init(aDecoder:)") {
                it("should return nil") {
                    expect(LocationError(coder: NSCoder())).to(beNil())
                }
            }
        }
    }
}
