//
//  SelfieCaptureSession.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//
//  (Thanks to Alex Barbulescu for a helpful medium article I found!)

import Foundation
import AVFoundation
import UIKit

protocol SelfieCaptureDelegate: AnyObject {
    
    /// Called when capture session ready to be attached to a Layer
    /// NOT guranteed to be on main queue
    func sessionReadyForLayer()
    
    func sessionReturnedImage(_ image: CGImage)
}

class SelfieCaptureSession: NSObject {
    
    var captureSession: AVCaptureSession?
    var camera: AVCaptureDevice?
    var input: AVCaptureInput?
    var photoOutput = AVCapturePhotoOutput()
    
    weak var delegate: SelfieCaptureDelegate?
    
    
    func setup() {
        
        if delegate == nil {
            fatalError("SelfieCaptureSession delegate not set on setup")
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession = AVCaptureSession()
            
            guard let captureSession = self.captureSession else { return }

            captureSession.beginConfiguration()
            
            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            
            self.inputsSetup()
            self.outputsSetup()
            
            captureSession.commitConfiguration()
            captureSession.startRunning()
            
            self.delegate?.sessionReadyForLayer()
        }
    }
    
    /// Todo - better error management
    private func inputsSetup() {
        
        guard let captureSession = captureSession else {
            fatalError("Capture session is null in inputsSetup and shouldn't be")
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("Camera doesn't exist, oh no.")
        }
        self.camera = device
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            fatalError("Error getting camera input")
        }
        self.input = input

        if !captureSession.canAddInput(input) {
            fatalError("Couldn't attach a camera")
        }
        
        captureSession.addInput(input)
    }
    
    private func outputsSetup() {
        guard let captureSession = captureSession else {
            fatalError("Capture session is null in inputsSetup and shouldn't be")
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            fatalError("Could not add photo output")
        }
        
    }
    
    func takePhoto() {
        let captureSettings = AVCapturePhotoSettings()
        captureSettings.previewPhotoFormat = [
            kCVPixelBufferPixelFormatTypeKey as String : captureSettings.availablePreviewPhotoPixelFormatTypes.first!,
            kCVPixelBufferWidthKey as String: 300,
            kCVPixelBufferHeightKey as String: 300
        ]
        photoOutput.capturePhoto(with: captureSettings, delegate: self)
    }
    
}

extension SelfieCaptureSession: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        guard let cgImageFromOutput = photo.cgImageRepresentation() else {
            fatalError("Could not turn pixelbuffer into CGPhoto")
        }
        delegate?.sessionReturnedImage(cgImageFromOutput)
    }
}
