//
//  LocationError.swift
//  LocationManager
//
//  Created by Sean on 5/12/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class LocationError: NSError {
    enum ErrorCode: Int {
        case unknown = -1
        case authorizationStatusDenied
        case authorizationStatusNotDetermined
        case authorizationStatusRestricted
        case locationServicesDisabled
    }

    static let errorDomain = "com.skladek.locationManager"

    init(code: ErrorCode, message: String?) {
        var localizedDescription = message

        if code == .unknown && message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [AnyHashable : Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey : message]
        }

        super.init(domain: LocationError.errorDomain, code: code.rawValue, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
