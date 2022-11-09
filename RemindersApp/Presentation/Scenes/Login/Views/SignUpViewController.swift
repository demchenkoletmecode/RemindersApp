//
//  SignUpViewController.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import Firebase
import FirebaseAuth
import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorEmailLbl: UILabel!
    @IBOutlet private weak var errorPasswordLbl: UILabel!
    @IBOutlet private weak var signUpBtn: UIButton!
    
    private var presenter: AuthPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self, authService: appContext.authentication)
        presenter.show()
    }

    @IBAction private func emailChanged(_ sender: Any) {
        presenter.passwOrEmailChanged()
    }
    
    @IBAction private func passwordChanged(_ sender: Any) {
        presenter.passwOrEmailChanged()
    }
    
    @IBAction private func signUpClick(_ sender: Any) {
        presenter.tapSignUpButton()
    }
    
    @IBAction private func goToSignInClick(_ sender: Any) {
        presenter.tapGoToSignIn()
    }
    
    @IBAction private func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: AuthViewProtocol {
    
    var email: String {
        return emailTextField.text ?? ""
    }
    
    var password: String {
        return passwordTextField.text ?? ""
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
    
    var passwordError: String {
        get {
            return ""
        }
        set {
            errorPasswordLbl.isHidden = false
            errorPasswordLbl.text = newValue
        }
    }
    
    var isBtnEnabled: Bool {
        get {
            return true
        }
        set {
            signUpBtn.isEnabled = newValue
        }
    }
    
    func move(to: AuthViewNavigation) {
        switch to {
        case .mainWithUser:
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isLater: false, isAuthorized: true)
            }
        case .mainWithoutUser: break
        case .goToSignUp: break
        case .goToSignIn:
            let signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignInVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .goToResetPassword: break
        }

    }
    
}
