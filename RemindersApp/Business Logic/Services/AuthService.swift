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

protocol AuthServiceProtocol {
    func createAccount(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logoutUser()
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    static var isAuthorized: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var userId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func createAccount(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(User(user)))
            }
        }
    }
    
    func login(_ email: String, _ password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(User(user)))
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch { print("already logged out") }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
