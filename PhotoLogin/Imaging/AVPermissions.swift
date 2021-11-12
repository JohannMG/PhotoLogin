//
//  AVPermissions.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import Foundation
import AVFoundation

class AVPermissions {
    
    /// Little helper method to simplify permissions
    /// The completion handler is called on an arbitrary dispatch queue. It is the client's responsibility to ensure that any UIKit-related updates are called on the main queue or main thread as a result.
    static func getPermissionAsyncOnSuccess(_ onSuccess: @escaping ()-> Void, onFailure: @escaping () -> Void){
        let currentPermissions = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch currentPermissions {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if authorized { onSuccess() }
                else { onFailure() }
            }
        case .restricted:
            onFailure()
        case .denied:
            onFailure()
        case .authorized:
            onSuccess()
        @unknown default:
            fatalError() // in the case enum is expanded
        }
        
    }
    
}
