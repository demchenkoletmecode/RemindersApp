//
//  AuthPresenter.swift
//  RemindersApp
//
//  Created by Andrey on 06.10.2022.
//

import Firebase
import FirebaseAuth
import Foundation
import UIKit

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
    private let defaults = UserDefaults.standard
    
    init(view: AuthViewProtocol, authService: AuthServiceProtocol) {
        self.view = view
        self.authService = authService
    }
    
    func getUserId() {
        if let userId = defaults.string(forKey: "user_id") {
            appContext.userId = userId
        }
    }
    
    func setUserId(id: String) {
        defaults.set(id, forKey: "user_id")
        appContext.userId = id
    }
    
    func show() {
        if AuthService.isAuthorized {
            getUserId()
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
                if password.count < 8 {
                    self.view.passwordError = "Password should have at least 8 characters!"
                    self.view.isBtnEnabled = false
                } else if email.isValidEmail && password.count >= 8 {
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
    
        if isCorrect {
            authService.login(email, password) { [weak self] result in
                switch result {
                case let .success(user):
                    self?.setUserId(id: user.uid)
                    self?.view.move(to: .mainWithUser)
                case .failure(let error):
                    self?.view.passwordError = error.localizedDescription
                }
            }
        }
    }
    
    func tapSignUpButton() {
        let email = view.email
        let password = view.password

        let isCorrect = validateEmailAndPassword(email, password)

        if isCorrect {
            authService.createAccount(view.email, view.password) { [weak self] result in
                switch result {
                case let .success(user):
                    self?.setUserId(id: user.uid)
                    self?.view.move(to: .mainWithUser)
                case .failure(let error):
                    self?.view.passwordError = error.localizedDescription
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
