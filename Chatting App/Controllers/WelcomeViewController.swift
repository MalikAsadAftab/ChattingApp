//
//  WelcomeViewController.swift
//  Flash Chat
//
//  Created by Asad Aftab on 10/09/2024.
//  Copyright © 2024 Asad Aftab. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseCore
import CLTypingLabel
import Firebase


class WelcomeViewController: UIViewController {

    @IBOutlet weak var singupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButtonsAndView()
        FirebaseApp.configure()
    }
    
    
    
    
    func customizeButtonsAndView(){
        //singupButton.setTitleColor(.white, for: .normal)
        singupButton.layer.cornerRadius = singupButton.frame.height/2
        
        singupButton.layer.shadowColor = UIColor.gray.cgColor
        singupButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        singupButton.layer.shadowRadius = 10
        singupButton.layer.shadowOpacity = 0.5
        
        //Add gradient
        //let gradientLayer = CAGradientLayer()
        //gradientLayer.colors = [UIColor.purple.cgColor, UIColor.blue.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        //gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        //gradientLayer.frame = singupButton.bounds
        //gradientLayer.cornerRadius = singupButton.layer.cornerRadius
        //singupButton.layer.insertSublayer(gradientLayer, at: 0)
        
        
        loginButton.layer.cornerRadius = singupButton.frame.height/2
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 0.5
        
        //titleLabel.textColor = .white
        
        // Title Animation with the use of the timer
        titleLabel.text = "⚡️FlashChat"
        
        
    }

}
