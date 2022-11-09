//
//  ResetPasswordViewController.swift
//  RemindersApp
//
//  Created by Андрей on 09.11.2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var errorEmailLbl: UILabel!
    
    var presenter: ResetPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func sendEmailClick(_ sender: Any) {
        presenter.tapSendEmail()
    }
    
    @IBAction private func goBackClick(_ sender: Any) {
        presenter.tapGoBack()
    }
    
}

extension ResetPasswordViewController: ResetPasswordProtocol {
    
    var email: String {
        return ""
    }
    
    var emailError: String {
        get {
            return ""
        }
        set {
            
        }
    }
    
    var isBtnEnabled: Bool {
        get {
            return true
        }
        set {
            
        }
    }
    
    func move(to: ResetPasswordNavigation) {
        switch to {
        case .goBack:
            navigationController?.popViewController(animated: true)
        case .goToLoginWithResetesPass:
            navigationController?.popViewController(animated: true)
        }
    }
    
}
