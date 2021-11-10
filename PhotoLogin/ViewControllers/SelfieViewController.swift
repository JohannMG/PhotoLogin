//
//  SelfieViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//  I have done it, I've finally used the word `selfie` in code.
//

import UIKit

protocol SelfieViewDelegate : AnyObject {
    func didTakeImage(_ image: UIImage) 
}

class SelfieViewController: UIViewController {
    
    private let selfieView = UIView()
    private let buttonSnap = UIControl()
    
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
