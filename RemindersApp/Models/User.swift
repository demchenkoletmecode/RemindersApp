//
//  User.swift
//  RemindersApp
//
//  Created by Andrey on 07.10.2022.
//

import FirebaseAuth
import Foundation

struct User {
    let email: String
}

extension User {
    init(_ user: FirebaseAuth.User?) {
        email = user?.email ?? ""
    }
}
