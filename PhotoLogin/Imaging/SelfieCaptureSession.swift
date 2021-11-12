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
    
    /// Called on the main queue since this is a User Action Item
    func sessionFailed(error: Error)
    
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
    
    private func inputsSetup() {
        
        guard let captureSession = captureSession else {
            delegate?.sessionFailed(error: CaptureError.captureSessionMissing)
            return
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            delegate?.sessionFailed(error: CaptureError.noCamera)
            return
        }
        self.camera = device
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            delegate?.sessionFailed(error: CaptureError.captureInput)
            return
        }
        self.input = input

        if !captureSession.canAddInput(input) {
            delegate?.sessionFailed(error: CaptureError.cameraError)
            return
        }
        
        captureSession.addInput(input)
    }
    
    private func outputsSetup() {
        guard let captureSession = captureSession else {
            delegate?.sessionFailed(error: CaptureError.captureSessionMissing)
            return
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            delegate?.sessionFailed(error: CaptureError.photoOutput)
            return
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
            delegate?.sessionFailed(error: CaptureError.photoParse)
            return
        }
        delegate?.sessionReturnedImage(cgImageFromOutput)
    }
}
