//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuth


class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        do {
            print("Asad")
            try Auth.auth().signOut()
            print("Asad")
            navigationController?.popToRootViewController(animated: true)
            print("Asad")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}
