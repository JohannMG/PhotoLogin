//
//  MainViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let subheadingLabel = UILabel()
    private let filledButton = UIButton(type: .system)
    
    private let formViewController = FormViewController()
    private let profileCardViewController = ProfileCardViewController()
    
    private var keyboardOffset = 0.0
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(formViewController)
        view.addSubview(formViewController.view)
        formViewController.didMove(toParent: self)
        
        view.backgroundColor = .white
        
        titleLabel.text = "Profile Creation"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.addSubview(titleLabel)

        
        subheadingLabel.text = "User the form below to submit your portfolio. \nAn email and password are required."
        subheadingLabel.numberOfLines = -1
        subheadingLabel.lineBreakMode = .byWordWrapping
        subheadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.addSubview(subheadingLabel)
        
        filledButton.setTitle("Create Profile", for: .normal)
        filledButton.setTitleColor(.white, for: .normal)
        filledButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        filledButton.backgroundColor = .red
        filledButton.layer.cornerRadius = Constants.UI.cornerRadius
        filledButton.clipsToBounds = true
        filledButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        view.addSubview(filledButton)
        
        addChild(profileCardViewController)
        // only add subview when showing
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // I am using frame setting bc that's what i'm used to working with.
        
        let appAreaInsets = view.window?.safeAreaInsets ?? UIEdgeInsets()
        
        // Top down Layout ----
        
        let titleSize = titleLabel.intrinsicContentSize
        titleLabel.frame = CGRect(x: 8, y: 8 + appAreaInsets.top, width: view.bounds.width - 16, height: titleSize.height)
        
        let subheadSize = subheadingLabel.sizeThatFits(CGSize(width: view.bounds.width, height: 9999))
        subheadingLabel.frame = CGRect(x: 8,
                                       y: titleLabel.frame.maxY + 8 ,
                                       width: view.bounds.width - 16 ,
                                       height: subheadSize.height)
        
        // Bottom Up Layout ---
        
        let buttonSize = CGSize(width: view.bounds.width, height: 45.0)
        filledButton.frame = CGRect(x: 8,
                                    y: view.bounds.height - buttonSize.height - 16.0 - appAreaInsets.bottom,
                                    width: view.bounds.width - 16.0,
                                    height: buttonSize.height)
        
        
        let formHeight = (keyboardOffset == 0) ? (filledButton.frame.minY - subheadingLabel.frame.maxY) - 32.0
                                            : (view.bounds.maxY - subheadingLabel.frame.maxY) - keyboardOffset
        formViewController.view.frame = CGRect(x: 8,
                                               y: subheadingLabel.frame.maxY + 16.0 ,
                                               width: view.bounds.width - 16.0,
                                               height: formHeight)
        profileCardViewController.view.frame = formViewController.view.frame
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        keyboardOffset = keyboardHeight
        view.setNeedsLayout()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        keyboardOffset = 0.0
        view.setNeedsLayout()
    }
    
    @objc
    func didSubmit() {
        self.user = formViewController.createUserFromForm()
        profileCardViewController.user = self.user
        
        titleLabel.text = "Hello, \(self.user?.name ?? "")"
        subheadingLabel.text = "Your super-awesome portfolio has been successfully submmitted! The preview below is what the community will see!"
        
        formViewController.view.removeFromSuperview()
        formViewController.removeFromParent()
        
        self.view.addSubview(profileCardViewController.view)
        profileCardViewController.didMove(toParent: self)
        
        filledButton.isHidden = true
        
        
    }
    
}
