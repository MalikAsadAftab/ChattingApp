# Flash Chat iOS App

## Overview

Welcome to the Flash Chat iOS App project! This project demonstrates the creation of a fully functional real-time messaging app, utilizing Firebase as the backend service. The app is designed with a focus on user authentication, real-time data handling, and a polished, user-friendly interface. We combined the power of UIKit and SwiftUI to build a dynamic chat application that showcases modern iOS development practices.

## Project Goal

The primary objectives of this project were to:

- **Implement real-time messaging** using Firebase Firestore.
- **Secure user authentication** through Firebase Authentication.
- **Design a custom chat interface** using UITableView and custom cells.
- **Seamlessly integrate UIKit and SwiftUI** to create a responsive user interface.
- **Manage asynchronous data operations** efficiently with GCD (Grand Central Dispatch).
- **Provide smooth user navigation** with a well-structured navigation stack.

## What We Created

In this project, we developed Flash Chat, an internet-based messaging app that allows users to communicate in real-time. The app leverages Firebase Firestore as its backend database to store and retrieve chat messages instantaneously, while Firebase Authentication handles user registration and login. We built a polished, scalable user interface that adapts seamlessly across different iOS devices.

## Key Features and Functions

### Real-Time Messaging with Firebase Firestore

- **Firestore Setup**:
  - We initialized Firestore using `let db = Firestore.firestore()`.
  - Messages are stored in a Firestore collection and are retrieved in real-time using `addSnapshotListener`.

- **Loading Messages**:
  - The `loadMessages()` function retrieves messages from Firestore and sorts them by timestamp:
    ```swift
    func loadMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                // Handling data retrieval and UI updates
            }
    }
    ```

- **Sending Messages**:
  - The `sendPressed(_ sender: UIButton)` function sends messages to the Firestore database, ensuring real-time updates across all connected clients:
    ```swift
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ]) {
                // Handling success or error
            }
        }
    }
    ```

### User Authentication with Firebase

- **User Login and Registration**:
  - We used Firebase Authentication to manage user sessions securely. The `Auth.auth().signIn` and `Auth.auth().createUser` functions handle login and registration, respectively:
    ```swift
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        // Handle sign-in
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        // Handle user creation
    }
    ```

- **Sign Out**:
  - Users can log out securely using the `logoutPressed(_ sender: UIBarButtonItem)` function, which calls `try Auth.auth().signOut()` to terminate the session.

### Custom UITableView Cells

- **Custom Cell Design**:
  - We created custom UITableView cells using a `.xib` file to enhance the appearance of chat messages. This was implemented with the following line in `viewDidLoad()`:
    ```swift
    tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    ```

- **Configuring Cells**:
  - The `tableView(_:cellForRowAt:)` function configures each cell based on whether the message was sent or received, applying different colors and aligning text appropriately:
    ```swift
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        // Customize the cell based on sender
        return cell
    }
    ```

### Navigation and View Controllers

- **Navigation Setup**:
  - We embedded view controllers within a Navigation Controller to manage the flow between screens. The navigation stack was used to push and pop view controllers as needed, ensuring smooth transitions.

- **Direct Segues**:
  - We utilized direct segues to navigate between screens. For instance, `performSegue(withIdentifier:sender:)` was used to transition from the login screen to the chat screen after successful authentication.

### Keyboard Management

- **Adjusting UI for Keyboard**:
  - We managed the keyboard appearance and ensured the text field and send button were not obscured by the keyboard using the following methods:
    ```swift
    @objc func keyboardWillShow(notification: NSNotification) {
        // Adjust UI when keyboard appears
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Adjust UI when keyboard hides
    }
    ```

- **Dismissing Keyboard**:
  - The `dismissKeyboard()` function was used to dismiss the keyboard when the user taps outside the text field, providing a smoother user experience:
    ```swift
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    ```

### Asynchronous Data Handling with GCD

- **Handling Concurrent Tasks**:
  - We utilized Grand Central Dispatch (GCD) to handle concurrent tasks, ensuring that UI updates are performed on the main thread:
    ```swift
    DispatchQueue.main.async {
        self.tableView.reloadData()
        // Scroll to the latest message
    }
    ```

- **Main Thread UI Updates**:
  - UI elements were updated on the main thread after data operations to avoid conflicts and ensure a smooth user interface.

### SwiftUI and UIKit Integration

- **Using Both Frameworks**:
  - The app seamlessly integrates SwiftUI and UIKit components, leveraging the strengths of each framework to create a dynamic and responsive user interface.

- **UI Components**:
  - UIKit was primarily used for the chat interface, while SwiftUI handled some of the modern UI elements, combining the best of both worlds.

## Getting Started

To explore this project, follow these steps:

1. **Clone the Repository**: Clone the repository to your local machine using `git clone`.
2. **Configure Firebase**: Set up a Firebase project and download the `GoogleService-Info.plist` file. Add this file to your Xcode project.
3. **Open in Xcode**: Open the project in Xcode.
4. **Run the App**: Build and run the app on an iOS Simulator or an iOS device.

## Conclusion

This project provided an in-depth exploration of building a real-time chat application using Firebase and Swift. We covered everything from secure user authentication and real-time data handling to custom UI design and keyboard management. The resulting Flash Chat app is a robust messaging platform that integrates modern iOS development practices, demonstrating the ability to build scalable, interactive applications.

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Swift Documentation](https://developer.apple.com/documentation/swift)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)
- [UITableView Documentation](https://developer.apple.com/documentation/uikit/uitableview)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Location Documentation](https://developer.apple.com/documentation/corelocation)
- [URLSession Documentation](https://developer.apple.com/documentation/foundation/urlsession)

---

Feel free to reach out if you have any questions or need further assistance.

Happy Coding!

For further queries or help, don't hesitate to get in touch via email: [asad.aftab@tuwien.ac.at](mailto:asad.aftab@tuwien.ac.at) or through [LinkedIn: Asad Aftab](https://www.linkedin.com/in/asad-aftab-malak/).

[![Email](https://img.icons8.com/color/48/000000/email.png)](mailto:asad.aftab@tuwien.ac.at)
[![LinkedIn](https://img.icons8.com/color/48/000000/linkedin.png)](https://www.linkedin.com/in/asad-aftab-malak/)

