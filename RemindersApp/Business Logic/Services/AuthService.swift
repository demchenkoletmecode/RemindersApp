//
//  LoginService.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Foundation
import FirebaseCore
import Firebase
import FirebaseAuth

enum Result<User, Error> {
    case success(User)
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
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let user = result?.user, error == nil {
                completion(.success(User(user)))
            } else {
                print("Error \(error?.localizedDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<User, Error?>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user, error == nil {
                completion(.success(User(user)))
            } else {
                print("Error \(error?.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        }
        catch { print("already logged out") }
    }
    
}
