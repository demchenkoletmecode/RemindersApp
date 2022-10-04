//
//  CheckUser.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import Foundation
import Firebase
import FirebaseAuth

func isAuthorized() -> Bool {
    if Auth.auth().currentUser != nil {
        return true
    } else {
        return false
    }
}
