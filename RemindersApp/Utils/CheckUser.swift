//
//  CheckUser.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import Firebase
import FirebaseAuth
import Foundation

static var isAuthorized: Bool {
   if currentUser != nil {
         return true
     } else {
         return false
     }
}
