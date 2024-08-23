//
//  MessageCell.swift
//  Chatting App
//
//  Created by Asad Aftab on 8/17/24.
//  Copyright © 2024 Asad Aftab. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initially disable the login button
        loginButton.isEnabled = false

        // Set delegates for text fields
        emailTextfield.delegate = self
        passwordTextfield.delegate = self

        // Add target for text field changes to enable/disable login button
        emailTextfield.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)

        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func textFieldsChanged(_ textField: UITextField) {
        // Enable the login button only if both text fields have content
        let emailFilled = !(emailTextfield.text?.isEmpty ?? true)
        let passwordFilled = !(passwordTextfield.text?.isEmpty ?? true)

        loginButton.isEnabled = emailFilled && passwordFilled
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomOfLoginButton = self.loginButton.convert(self.loginButton.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardHeight

            if bottomOfLoginButton > topOfKeyboard {
                let offset = bottomOfLoginButton - topOfKeyboard + 20 // Add some padding
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = -offset
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        dismissKeyboard() // Dismiss the keyboard when the login button is pressed

        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty else {
            showAlert(title: "Error Logging In", message: "Please enter both email and password.")
            return
        }

        if !isValidEmail(email) {
            showAlert(title: "Error Logging In", message: "Please enter a valid email address.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error as NSError? {
                self?.handleFirebaseError(e)
            } else {
                self?.performSegue(withIdentifier: Constants.loginsegue, sender: self)
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func handleFirebaseError(_ error: NSError) {
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .userNotFound:
                showAlert(title: "Error Logging In", message: "No account found for this email. Please check the email or register.")
            case .wrongPassword:
                showAlert(title: "Error Logging In", message: "Incorrect password. Please try again.")
            case .invalidEmail:
                showAlert(title: "Error Logging In", message: "The email address is badly formatted.")
            case .userDisabled:
                showAlert(title: "Error Logging In", message: "This user account has been disabled.")
            default:
                showAlert(title: "Error Logging In", message: "An unknown error occurred. Please try again.")
            }
        } else {
            showAlert(title: "Error Logging In", message: "Either the email is invalid or password.")
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            loginPressed(loginButton)
        }
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
