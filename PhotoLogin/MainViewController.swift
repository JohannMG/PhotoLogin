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
    let scrollView = UIScrollView()
    let filledButton = UIButton(type: .system)
    
    var keyboardOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.text = "Profile Creation"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.addSubview(titleLabel)

        
        subheadingLabel.text = "User the form below to submit your portfolio. \nAn email and passwrod are required."
        subheadingLabel.numberOfLines = 2
        subheadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.addSubview(subheadingLabel)
        
        scrollView.backgroundColor = .gray
        view.addSubview(scrollView)
        
        filledButton.titleLabel?.text = "Create"
        filledButton.titleLabel?.textColor = .white
        filledButton.backgroundColor = .red
        filledButton.layer.cornerRadius = 5.0
        filledButton.clipsToBounds = true
        view.addSubview(filledButton)
    }
    
    
    override func viewWillLayoutSubviews() {
        
        // I am using frame setting bc that's what i'm used to working with. I know contstraints enough, yes.
        
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
        
        scrollView.frame = CGRect(x: 8,
                                  y: subheadingLabel.frame.maxY + 16 ,
                                  width: view.bounds.width - 16 ,
                                  height: (filledButton.frame.minY - subheadingLabel.frame.maxY) - 32 )
        
    }
}
