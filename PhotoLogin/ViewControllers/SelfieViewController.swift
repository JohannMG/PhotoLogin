//
//  SelfieViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//  I have done it, I've finally used the word `selfie` in code.
//

import UIKit
import AVFoundation

protocol SelfieViewDelegate : AnyObject {
    func didTakeImage(_ image: UIImage) 
}

class SelfieViewController: UIViewController {
    
    private let selfieView = UIView()
    private let buttonSnap = UIControl()
    private let buttonCancel = UIButton(type: .system)
    private lazy var selfieCaptureSession = { SelfieCaptureSession() }()
    private var captureLayer: AVCaptureVideoPreviewLayer?
    
    let buttonSize = CGSize(width: 100, height: 100)
    
    weak var delegate: SelfieViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        view.addSubview(selfieView)
        selfieView.backgroundColor = .gray
        selfieView.clipsToBounds = true
        
        view.addSubview(buttonSnap)
        buttonSnap.backgroundColor = .white
        buttonSnap.layer.borderWidth = 8.0
        buttonSnap.layer.borderColor = UIColor.gray.cgColor
        buttonSnap.layer.cornerRadius = buttonSize.width / 2.0
        buttonSnap.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        view.addSubview(buttonCancel)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.setTitleColor(.yellow, for: .normal)
        buttonCancel.addTarget(self, action: #selector(closeButton), for: .touchUpInside)
        
        selfieCaptureSession.delegate = self
        selfieCaptureSession.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Cheating a little, out app right now is portrait only
        selfieView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)
        
        buttonSnap.frame = CGRect(x: view.frame.midX - (buttonSize.width / 2.0) ,
                                  y: view.bounds.maxY - 200,
                                  width: buttonSize.width,
                                  height: buttonSize.height)
        
        let buttonSize = buttonCancel.intrinsicContentSize
        buttonCancel.frame = CGRect(x: 50,
                                    y: buttonSnap.frame.midY - (buttonSize.height / 2.0),
                                    width: buttonSize.width,
                                    height: buttonSize.height)
    }
    
    @objc
    func takePhoto() {
        selfieCaptureSession.takePhoto()
    }
    
    @objc
    func closeButton() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SelfieViewController: SelfieCaptureDelegate {
    
    func sessionFailed(error: Error) {
        let alert = UIAlertController(title: "Camera Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func sessionReadyForLayer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.captureLayer != nil { return } // already in layer
            
            guard let captureSession = self.selfieCaptureSession.captureSession else { return }
            
            self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.selfieView.layer.addSublayer(self.captureLayer!)
            
            // this is a hack for layout but I don't want to sink too much time here
            let edge = max(self.selfieView.layer.frame.height, self.selfieView.layer.frame.width)
            self.captureLayer!.frame = CGRect(x: -edge * 0.2 , y: 0, width: edge * 1.4, height: edge * 1.4)
            
        }
    }
    
    func sessionReturnedImage(_ image: CGImage) {
        self.dismiss(animated: true, completion: nil)
        let friendlyImage = ImageHelpers.prepareSelfieToSquare(image)
        delegate?.didTakeImage(friendlyImage)
    }
}
