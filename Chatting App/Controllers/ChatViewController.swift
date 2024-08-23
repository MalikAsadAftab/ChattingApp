//
//  MessageCell.swift
//  Chatting App
//
//  Created by Asad Aftab on 8/17/24.
//  Copyright © 2024 Asad Aftab. All rights reserved.
//
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageTextfieldBottomConstraint: NSLayoutConstraint! // Link this to the bottom constraint of the textfield
    @IBOutlet weak var sendButton: UIButton!
    
    
    let db = Firestore.firestore()
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        sendButton.isEnabled = false
        // Load messages
        loadMessages()
        messageTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        // Set up keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Dismiss keyboard when tapping outside the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.messageTextfieldBottomConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            }
            scrollToBottom()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            // Enable or disable the button based on whether the text field is empty
            if let text = textField.text, !text.isEmpty {
                sendButton.isEnabled = true
            } else {
                sendButton.isEnabled = false
            }
        }


    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.messageTextfieldBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func loadMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                if let error = error {
                    print("There was an issue retrieving data from Firebase: \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[Constants.FStore.senderField] as? String,
                               let messageBody = data[Constants.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    //self.scrollToBottom()
                                }
                            }
                        }
                    }
                }
            }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                    db.collection(Constants.FStore.collectionName).addDocument(data: [
                        Constants.FStore.senderField: messageSender,
                        Constants.FStore.bodyField: messageBody,
                        Constants.FStore.dateField: Date().timeIntervalSince1970
                    ]) { error in
                        if let error = error {
                            print("There was an issue storing data: \(error)")
                        } else {
                            print("Successfully saved data!")
                            self.messageTextfield.text = ""
                            self.textFieldDidChange(self.messageTextfield) // Re-check the text field to disable the button
                            self.scrollToBottom()
                        }
                    }
        }
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }

    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        
        // Message from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.blue)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lighBlue)
        }
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lighBlue)
            cell.label.textColor = UIColor(named: Constants.BrandColors.blue)
        }
        
        return cell
    }
    
}
