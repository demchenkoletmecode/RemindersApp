//
//  ResetPasswordPresenter.swift
//  RemindersApp
//
//  Created by Андрей on 09.11.2022.
//

import Foundation

enum ResetPasswordNavigation {
    case goBack
    case goToLoginWithResetesPass
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
    
    func tapSendEmail() {
        view.move(to: .goToLoginWithResetesPass)
    }
    
    func tapGoBack() {
        view.move(to: .goBack)
    }
}
