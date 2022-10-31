//
//  AuthViewController.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import Firebase
import FirebaseAuth
import UIKit

class SignInViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorEmailLbl: UILabel!
    @IBOutlet private weak var errorPasswordLbl: UILabel!
    @IBOutlet private weak var signInBtn: UIButton!
    
    private var presenter: AuthPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self, authService: appContext.authentication)
        presenter.show()
    }
    
    @IBAction private func signInClick(_ sender: UIButton) {
        presenter.tapLoginButton()
    }
    
    @IBAction private func emailChanged(_ sender: Any) {
        presenter.passwOrEmailChanged()
    }
    
    @IBAction private func passwordChanged(_ sender: Any) {
        presenter.passwOrEmailChanged()
    }
    
    @IBAction private func laterClick(_ sender: UIButton) {
        presenter.tapLaterButton()
    }

    @IBAction private func goToSignUpClick(_ sender: Any) {
        presenter.tapGoToSignUp()
    }
    
    @IBAction private func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SignInViewController: AuthViewProtocol {
    
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
            signInBtn.isEnabled = newValue
        }
    }
    
    func move(to: AuthViewNavigation) {
        switch to {
        case .mainWithUser:
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isLater: false, isAuthorized: true)
            }
        case .mainWithoutUser:
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.openTheDesiredController(isLater: true, isAuthorized: false)
            }
        case .goToSignUp:
            let signUpStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
            let vc = signUpStoryboard.instantiateViewController(withIdentifier: "SignUpVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .goToSignIn: break
        }
    }

}
