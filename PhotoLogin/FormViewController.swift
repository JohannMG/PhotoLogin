//
//  FormViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

// TODO:  - add a delegate to signal if form is ready or not based on required fields

class FormViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let addAvatar = UIView()
    let firstNameField = UITextField()
    let emailAddressField = UITextField()
    let passwordField = UITextField()
    let websiteField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Scroll view
        view.addSubview(scrollView)
        
        // Imageview will have more to it soon
        addAvatar.backgroundColor = .lightGray
        scrollView.addSubview(addAvatar)
        
        // Then setup items that go into the scrollview
        [firstNameField, emailAddressField, passwordField, websiteField].forEach { field in
            field.layer.borderColor = CGColor(gray: 0.0, alpha: 1.0)
            field.layer.borderWidth = 1.0
            field.layer.cornerRadius = Constants.UI.cornerRadius
            scrollView.addSubview(field)
        }
        firstNameField.placeholder = "First Name"
        emailAddressField.placeholder = "Email"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        websiteField.placeholder = "Website"
        
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.frame = view.bounds
        
        let paddingY: CGFloat = 16.0
        
        // layout the image View
        let addAvatarSize = CGSize(width: 150, height: 150)
        addAvatar.frame = CGRect(x: scrollView.bounds.midX - (addAvatarSize.width / 2.0),
                                 y: 0 ,
                                 width: addAvatarSize.width,
                                 height: addAvatarSize.height)
        
        // fields
        let fieldHeights:CGFloat = 60.0
        firstNameField.frame = CGRect(x: 0, y: addAvatar.frame.maxY + paddingY, width: scrollView.bounds.width, height: fieldHeights)
        emailAddressField.frame = CGRect(x: 0, y: firstNameField.frame.maxY + paddingY, width: scrollView.bounds.width, height: fieldHeights)
        passwordField.frame = CGRect(x: 0, y: emailAddressField.frame.maxY + paddingY, width: scrollView.bounds.width, height: fieldHeights)
        websiteField.frame = CGRect(x: 0, y: passwordField.frame.maxY + paddingY, width: scrollView.bounds.width, height: fieldHeights)
        
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: websiteField.frame.maxY + paddingY)
        
    }

}
