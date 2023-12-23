//
//  fff.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 23.12.2023.
//

import UIKit
import Firebase

struct Message {
    let text: String
    let isFromCurrentUser: Bool
    let fromID: String
    let toID: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == fromID
    }
}
