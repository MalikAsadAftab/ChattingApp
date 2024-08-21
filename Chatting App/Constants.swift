//
//  Constants.swift
//  Chatting App
//
//  Created by Asad Aftab on 8/11/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

struct Constants{
    static let registersegue = "RegisterToChat"
    static let loginsegue = "LoginToChat"
    static let appName = "⚡️FlashChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
