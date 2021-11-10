//
//  MainViewController.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import UIKit

class MainViewController: UIViewController {
    
    let titleLabel = UILabel()
    let subheadingLabel = UILabel()
    let filledButton = UIButton(type: .system)
    
    let formViewController = FormViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(formViewController)
        view.addSubview(formViewController.view)
        formViewController.didMove(toParent: self)
        formViewController.view.backgroundColor = .gray
        
        view.backgroundColor = .white
        
        titleLabel.text = "Profile Creation"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.addSubview(titleLabel)

        
        subheadingLabel.text = "User the form below to submit your portfolio. \nAn email and password are required."
        subheadingLabel.numberOfLines = 2
        subheadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.addSubview(subheadingLabel)
        
        filledButton.setTitle("Create Profile", for: .normal)
        filledButton.setTitleColor(.white, for: .normal)
        filledButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        filledButton.backgroundColor = .red
        filledButton.layer.cornerRadius = Constants.UI.cornerRadius
        filledButton.clipsToBounds = true
        view.addSubview(filledButton)
    }
    
    
    override func viewWillLayoutSubviews() {
        
        // I am using frame setting bc that's what i'm used to working with.
        
        let appAreaInsets = view.window?.safeAreaInsets ?? UIEdgeInsets()
        
        // Top down Layout ----
        
        let titleSize = titleLabel.intrinsicContentSize
        titleLabel.frame = CGRect(x: 8, y: 8 + appAreaInsets.top, width: view.bounds.width - 16, height: titleSize.height)
        
        let subSize = subheadingLabel.intrinsicContentSize
        subheadingLabel.frame = CGRect(x: 8,
                                       y: titleLabel.frame.maxY + 8 ,
                                       width: view.bounds.width - 16 ,
                                       height: subSize.height)
        
        // Bottom Up Layout ---
        
        let buttonSize = CGSize(width: view.bounds.width, height: 45)
        filledButton.frame = CGRect(x: 8,
                                    y: view.bounds.height - buttonSize.height - 16 - appAreaInsets.bottom ,
                                    width: view.bounds.width - 16,
                                    height: buttonSize.height)
        
        formViewController.view.frame = CGRect(x: 8,
                                               y: subheadingLabel.frame.maxY + 16 ,
                                               width: view.bounds.width - 16 ,
                                               height: (filledButton.frame.minY - subheadingLabel.frame.maxY) - 32 )
        
    }
}
