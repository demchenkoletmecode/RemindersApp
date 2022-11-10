//
//  ResetPasswordPresenter.swift
//  RemindersApp
//
//  Created by Андрей on 09.11.2022.
//

import Foundation

enum ResetPasswordNavigation {
    case goBack
    case goToLoginWithResetedPass
}

protocol ResetPasswordProtocol: AnyObject {
    var email: String { get }
    var emailError: String { get set }
    var isBtnEnabled: Bool { get set }
    
    func move(to: ResetPasswordNavigation)
}

class ResetPasswordPresenter {
    
    var view: ResetPasswordProtocol
    let authService: AuthServiceProtocol
    
    init(view: ResetPasswordProtocol, authService: AuthServiceProtocol) {
        self.view = view
        self.authService = authService
    }
    
    private func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            self.view.emailError = "Enter Email!".localized
            self.view.isBtnEnabled = false
        } else {
            if email.isEmpty {
                self.view.emailError = "Enter Email!".localized
                self.view.isBtnEnabled = false
            } else {
                if !email.isValidEmail {
                    self.view.emailError = "Invalide Email!".localized
                    self.view.isBtnEnabled = false
                } else {
                    self.view.emailError = ""
                    self.view.isBtnEnabled = true
                    return true
                }
            }
        }
        return false
    }
    
    func tapSendEmail() {
        let email = view.email
        if validateEmail(email) {
            authService.resetPassword(email: email) { [weak self] result in
                switch result {
                case .success:
                    self?.view.move(to: .goToLoginWithResetedPass)
                case .failure(let error):
                    self?.view.emailError = error.localizedDescription
                }
            }
        }
    }
    
    func emailChanged() {
        self.view.isBtnEnabled = true
    }
    
    func tapGoBack() {
        view.move(to: .goBack)
    }
}
