//
//  LoginService.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Firebase
import FirebaseAuth
import FirebaseCore
import Foundation

enum Result<User, Error> {
    case success
    case failure(Error)
}

protocol AuthServiceProtocol {
    func createAccount(_ email: String, _ password: String, completion: @escaping (Result<User, Error?>) -> Void)
    func login(_ email: String, _ password: String, completion: @escaping (Result<User, Error?>) -> Void)
    func logoutUser()
}

class AuthService: AuthServiceProtocol {
    
    static var isAuthorized: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func createAccount(_ email: String, _ password: String, completion: @escaping (Result<User, Error?>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error == nil {
                completion(.success)
            } else {
                print("Error \(error?.localizedDescription ?? "something with creating account")")
                completion(.failure(error))
            }
        }
        
    }
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<User, Error?>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error == nil {
                completion(.success)
            } else {
                print("Error \(error?.localizedDescription ?? "something with login")")
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch { print("already logged out") }
    }
    
}
