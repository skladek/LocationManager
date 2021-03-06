import Foundation

public class LocationError: NSError {

    // MARK: Class Types

    /// Error codes to describe possible Location Services error states.
    ///
    /// - unknown: An error occurred for an unknown reason.
    /// - authorizationStatusDenied: The user has denied the app Location Services permission
    /// - authorizationStatusNotDetermined: The user has not yet made a choice regarding Location Services permission
    /// - authorizationStatusRestricted: The app is not allowed to use Location Services. The user cannot change this app status, possibly due to parental restrictions or similar.
    /// - locationServicesDisabled: Location services is currently disabled.
    public enum Code: Int {
        case unknown = -1
        case authorizationStatusDenied
        case authorizationStatusNotDetermined
        case authorizationStatusRestricted
        case locationServicesDisabled
    }

    // MARK: Static Variables

    /// The domain for errors. This should be updated to match the app Bundle Id on integration.
    public static let errorDomain = "com.skladek.locationManager"

    /// Initializes an error with the error code and an optional message.
    ///
    /// - Parameters:
    ///   - code: The error code to use to describe the error
    ///   - message: A string describing the error. If nil is passed as a message and code equals unknown, a generic message is used.
    public init(code: Code, message: String?) {
        var localizedDescription = message

        if code == .unknown && message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [String: Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey: message]
        }

        super.init(domain: LocationError.errorDomain, code: code.rawValue, userInfo: userInfo)
    }

    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
}
