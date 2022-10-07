//
//  CheckUser.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import Foundation
import Firebase
import FirebaseAuth

static var isAuthorized: Bool {
   if currentUser != nil {
         return true
     } else {
         return false
     }
}
