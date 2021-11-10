//
//  AvatarCaptureDisplayButton.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

class AvatarCaptureDisplayButton: UIControl {

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
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        imageView.frame = self.bounds
    }

}
