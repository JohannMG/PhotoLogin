//
//  AvatarCaptureDisplayButton.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

class AvatarCaptureDisplayButton: UIControl {
    
    var label = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        label.numberOfLines = 0
        label.text = "Touch to add avatar"
        label.textAlignment = .center
        addSubview(label)
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        clipsToBounds = true
        
        layer.cornerRadius = Constants.UI.cornerRadius
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        imageView.frame = self.bounds
        label.frame = self.bounds
    }

}
