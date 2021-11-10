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
    private lazy var selfieCaptureSession = { SelfieCaptureSession() }()
    private var captureLayer: AVCaptureVideoPreviewLayer?
    
    let buttonSize = CGSize(width: 100, height: 100)
    
    weak var delegate: SelfieViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        view.addSubview(selfieView)
        selfieView.backgroundColor = .green
        
        view.addSubview(buttonSnap)
        buttonSnap.backgroundColor = .white
        buttonSnap.layer.borderWidth = 8.0
        buttonSnap.layer.borderColor = UIColor.gray.cgColor
        buttonSnap.layer.cornerRadius = buttonSize.width / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    }
    
    @objc
    func takePhoto() {
        print("Click")
    }

}

extension SelfieViewController: SelfieCaptureDelegate {
    func sessionReadyForLayer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.captureLayer != nil { return } // already in layer
            
            guard let captureSession = self.selfieCaptureSession.captureSession else { return }
            
            self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.selfieView.layer.addSublayer(self.captureLayer!)
            self.captureLayer!.frame = self.selfieView.layer.frame
            
        }
    }
}
