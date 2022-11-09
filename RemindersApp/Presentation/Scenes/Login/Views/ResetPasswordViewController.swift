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
    @IBOutlet private weak var sendEmailBtn: UIButton!
    
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
    
    @IBAction private func emailChanged(_ sender: Any) {
        presenter.emailChanged()
    }
    
}

extension ResetPasswordViewController: ResetPasswordProtocol {
    
    var email: String {
        return emailTextField.text ?? ""
    }
    
    var emailError: String {
        get {
            return ""
        }
        set {
            errorEmailLbl.isHidden = false
            errorEmailLbl.text = newValue
        }
    }
    
    var isBtnEnabled: Bool {
        get {
            return true
        }
        set {
            sendEmailBtn.isEnabled = newValue
        }
    }
    
    func move(to: ResetPasswordNavigation) {
        switch to {
        case .goBack:
            navigationController?.popViewController(animated: true)
        case .goToLoginWithResetesPass:
            let alert = UIAlertController(title: "Resetting password",
                                          message: "Check your email account. We have sent you a link. Follow the link and create a new password",
                                          preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okBtn)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
    }
    
}
