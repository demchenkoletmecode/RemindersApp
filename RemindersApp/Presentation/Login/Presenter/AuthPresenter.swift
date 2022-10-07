//
//  AuthPresenter.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

enum AuthViewNavigation {
    case mainWithUser
    case mainWithoutUser
    case goToSignUp
    case goToSignIn
}

protocol AuthViewProtocol: AnyObject {
    var email: String { get }
    var password: String { get }
    var emailError: String { get set }
    var passwordError: String { get set }
    var isBtnEnabled: Bool { get set }
    
    func move(to: AuthViewNavigation)
}

class AuthPresenter {
    
    var view: AuthViewProtocol
    let authService: AuthServiceProtocol
    
    init(view: AuthViewProtocol, authService: AuthServiceProtocol) {
        self.view = view
        self.authService = authService
    }
    
    func show() {
        if AuthService.isAuthorized {
            view.move(to: .mainWithUser)
        }
    }
    
    func passwOrEmailChanged() {
        self.view.isBtnEnabled = true
    }
    
    func validateEmailAndPassword(_ email: String, _ password: String) -> Bool {
        if email.isEmpty && password.isEmpty {
            self.view.emailError = "Enter Email!"
            self.view.passwordError = "Enter Password!"
            self.view.isBtnEnabled = false
        } else {
            if email.isEmpty {
                self.view.emailError = "Enter Email!"
                self.view.isBtnEnabled = false
            }
            if password.isEmpty {
                self.view.passwordError = "Enter Password!"
                self.view.isBtnEnabled = false
            } else {
                if !email.isValidEmail {
                    self.view.emailError = "Invalide Email!"
                    self.view.isBtnEnabled = false
                }
                if !password.isPasswordHasEightCharacter {
                    self.view.passwordError = "Password should have at least 8 characters!"
                    self.view.isBtnEnabled = false
                } else if email.isValidEmail && password.isPasswordHasEightCharacter {
                    if !password.isPasswordHasNumberAndCharacter {
                        self.view.passwordError = "Password should have at least 1 number and 1 character!"
                        self.view.isBtnEnabled = false
                    } else {
                        self.view.emailError = ""
                        self.view.passwordError = ""
                        self.view.isBtnEnabled = true
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func tapLoginButton() {
        let email = view.email
        let password = view.password
        
        self.view.emailError = ""
        self.view.passwordError = ""
        
        let isCorrect = validateEmailAndPassword(email, password)
    
        //self.view.showSignInEmailError(message: self.view.emailError)
        //self.view.showSignInPasswordError(message: self.view.passwordError)
    
        if isCorrect {
            authService.login(email, password) { result in
                switch result {
                case .success(let user):
                    self.view.move(to: .mainWithUser)
                case .failure(let error):
                    self.view.passwordError = error?.localizedDescription ?? "Some error occurred"
                    //self.view.showSignInPasswordError(message: error?.localizedDescription ?? "Some error occurred")
                }
            }
        }
    }
    
    func tapSignUpButton() {
        let email = view.email
        let password = view.password

        let isCorrect = validateEmailAndPassword(email, password)
        //self.view.showSignUpEmailError(message: self.view.emailError)
        //self.view.showSignUpPasswordError(message: self.view.passwordError)

        if isCorrect {
            authService.createAccount(view.email, view.password) { result in
                switch result {
                case .success(let user):
                    self.view.move(to: .mainWithUser)
                case .failure(let error):
                    self.view.passwordError = error?.localizedDescription ?? "Some error occurred"
                    //self.view.showSignUpPasswordError(message: error?.localizedDescription ?? "Some error occurred")
                }
            }
        }
    }
    
    func tapLaterButton() {
        self.view.move(to: .mainWithoutUser)
    }
    
    func tapGoToSignUp() {
        self.view.move(to: .goToSignUp)
    }
    
    func tapGoToSignIn() {
        self.view.move(to: .goToSignIn)
    }
    
}
