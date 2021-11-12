//
//  FormViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

protocol FormViewDelegate : AnyObject
{
    func formValidityChanged(_ valid: Bool)
}

class FormViewController: UIViewController {
    
    var delegate: FormViewDelegate?
    
    private let scrollView = UIScrollView()
    
    private let addAvatar = AvatarCaptureDisplayButton()
    private let firstNameField = ProfileCreateTextField()
    private let emailAddressField = ProfileCreateTextField()
    private let passwordField = ProfileCreateTextField()
    private let websiteField = ProfileCreateTextField()
    private var isFormValid = false
    
    private lazy var selfieVC: SelfieViewController = { SelfieViewController() }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Scroll view
        view.addSubview(scrollView)
        scrollView.keyboardDismissMode = .interactive
        
        // Imageview will have more to it soon
        addAvatar.backgroundColor = .lightGray
        addAvatar.addTarget(self, action: #selector(didTapAddImage), for: .touchUpInside)
        scrollView.addSubview(addAvatar)
        
        // Then setup items that go into the scrollview
        [firstNameField, emailAddressField, passwordField, websiteField].forEach { field in
            field.delegate = self
            field.layer.borderColor = CGColor(gray: 0.0, alpha: 1.0)
            field.layer.borderWidth = 1.0
            field.layer.cornerRadius = Constants.UI.cornerRadius
            field.delegate = self
            scrollView.addSubview(field)
        }
        firstNameField.placeholder = "First Name"
        emailAddressField.placeholder = "Email"
        emailAddressField.autocapitalizationType = .none
        passwordField.placeholder = "Password"
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        websiteField.placeholder = "Website"
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
        
        let paddingY: CGFloat = 16.0
        
        // layout the image View
        let addAvatarSize = Constants.UI.avatarSize
        addAvatar.frame = CGRect(x: scrollView.bounds.midX - (addAvatarSize.width / 2.0),
                                 y: 0,
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
    
    @objc
    func didTapAddImage(){
        AVPermissions.getPermissionAsyncOnSuccess {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.selfieVC.delegate = self
                self.present(self.selfieVC, animated: true, completion: nil)
            }
        } onFailure: {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Permissions",
                                              message: "Camera permissions have been blocked. Go to settings and add permissions",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    func createUserFromForm() -> User {
        let user = User()
        user.userProfileImage = addAvatar.imageView.image
        user.name = firstNameField.text
        user.email = emailAddressField.text
        user.password = passwordField.text
        user.website = websiteField.text
        return user
    }
}

extension FormViewController : SelfieViewDelegate {
    func didTakeImage(_ image: UIImage) {
        addAvatar.imageView.image = image
    }
}

extension FormViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateValidState()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        updateValidState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        updateValidState()
        return false
    }
    
    private func updateValidState() {
        let newState = checkFormIsValid()
        if isFormValid != newState {
            delegate?.formValidityChanged(newState)
        }
        
        isFormValid = newState
    }
}

// Form Valildity
extension FormViewController {
    func checkFormIsValid() -> Bool {
        // Let's keep it simple
        // Name, email can be any length greater than zero
        let emailValid = (emailAddressField.text?.count ?? 0) >= 3
        let userValid = (firstNameField.text?.count ?? 0) >= 1
        
        // Password, must be at least 8 characters
        let passValid = (passwordField.text?.count ?? 0) >= 8
        
        return emailValid && userValid && passValid
    }
}
