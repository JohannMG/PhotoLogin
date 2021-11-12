//
//  CaptureError.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/11/21.
//

import Foundation

enum CaptureError : Error {
    
    case captureSessionMissing
    case noCamera
    case captureInput
    case cameraError
    case photoOutput
    case photoParse
}


/// These are written to be user facing.
/// Keep technical details to error name and comment
extension CaptureError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .captureSessionMissing, .captureInput:
            return NSLocalizedString("Camera setup failed",
                                     comment: "Technical issue")
        case .noCamera:
            return NSLocalizedString("Cannot find connection to camera",
                                     comment: "Usually becuase in the simulator")
        case .cameraError:
            return NSLocalizedString("Cannot connect to the camera,", comment: "Camera input rejected")
        case .photoOutput:
            return NSLocalizedString("Cannot not setup photo saving.", comment: "Error adding photo output")
        case .photoParse:
            return NSLocalizedString("Could not save photo from camers.", comment: "Photo output failed")
        }
    }
}


