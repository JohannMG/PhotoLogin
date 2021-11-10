//
//  ProfileCreateTextField.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

class ProfileCreateTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

}
