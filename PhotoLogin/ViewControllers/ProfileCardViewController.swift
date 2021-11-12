//
//  ProfileCardViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/10/21.
//

import UIKit

class ProfileCardViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let websiteLabel = UITextView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    
    var user: User? {
        didSet {
            updateInformation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(profileImageView)
        
        websiteLabel.isEditable = false
        websiteLabel.isUserInteractionEnabled = true
        websiteLabel.textAlignment = .center
        view.addSubview(websiteLabel)
        
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        emailLabel.numberOfLines = 1
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)
    }
    
    private func updateInformation() {
        profileImageView.image = user?.userProfileImage
        
        // TODO: Attributed string link
        websiteLabel.text = user?.website ?? ""
        
        nameLabel.text = user?.name ?? ""
        emailLabel.text = user?.email ?? ""
        
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let yPadding:CGFloat = 16.0
        // Top down, H centered
        
        let avatarSize = Constants.UI.avatarSize
        if profileImageView.image == nil {
            profileImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        } else {
            profileImageView.frame = CGRect(x: view.bounds.midX - (avatarSize.width / 2.0) ,
                                            y: 0,
                                            width: avatarSize.width,
                                            height: avatarSize.height)
        }
        
        websiteLabel.frame = CGRect(x: 0,
                                    y: profileImageView.frame.maxY + yPadding,
                                    width: view.bounds.width,
                                    height: websiteLabel.intrinsicContentSize.height)
        
        nameLabel.frame = CGRect(x: 0,
                                 y: websiteLabel.frame.maxY + yPadding,
                                 width: view.bounds.width,
                                 height: nameLabel.intrinsicContentSize.height)
        
        emailLabel.frame = CGRect(x: 0,
                                  y: nameLabel.frame.maxY + yPadding,
                                  width: view.bounds.width,
                                  height: emailLabel.intrinsicContentSize.height)
    }

}
