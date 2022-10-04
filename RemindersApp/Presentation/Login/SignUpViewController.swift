//
//  SignUpViewController.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorEmailLbl: UILabel!
    
    @IBOutlet weak var errorPasswordLbl: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func validateEmailAndPassword(_ email: String, _ password: String) -> Bool {
        if email == "" && password == "" {
            errorEmailLbl.isHidden = false
            errorEmailLbl.text = "Enter Email!"
            errorPasswordLbl.isHidden = false
            errorPasswordLbl.text = "Enter Password!"
            signUpBtn.isEnabled = false
        } else {
            if email == "" {
                errorEmailLbl.isHidden = false
                errorEmailLbl.text = "Enter Email!"
                signUpBtn.isEnabled = false
            }
            if password == "" {
                errorPasswordLbl.isHidden = false
                errorPasswordLbl.text = "Enter Password!"
                signUpBtn.isEnabled = false
            } else {
                errorEmailLbl.isHidden = true
                errorPasswordLbl.isHidden = true
                if !isValidEmail(email) {
                    errorEmailLbl.isHidden = false
                    errorEmailLbl.text = "Invalide email"
                    signUpBtn.isEnabled = false
                }
                if !isPasswordHasEightCharacter(password) {
                    errorPasswordLbl.isHidden = false
                    errorPasswordLbl.text = "Password should have at least 8 characters!"
                    signUpBtn.isEnabled = false
                } else {
                    if !isPasswordHasNumberAndCharacter(password) {
                        errorPasswordLbl.isHidden = false
                        errorPasswordLbl.text = "Password should have at least 1 number and 1 character!"
                        signUpBtn.isEnabled = false
                    } else {
                        errorEmailLbl.isHidden = true
                        errorPasswordLbl.isHidden = true
                        signUpBtn.isEnabled = true
                        return true
                    }
                }
            }
        }
        return false
    }

    @IBAction func emailChanged(_ sender: Any) {
        signUpBtn.isEnabled = true
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        signUpBtn.isEnabled = true
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if validateEmailAndPassword(email, password) {
                createAccount(email, password)
            }
        }
    }
    
    func createAccount(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("Error \(error?.localizedDescription)")
                self.errorPasswordLbl.isHidden = false
                self.errorPasswordLbl.text = error?.localizedDescription
                return
            }
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        let signInStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "AuthVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
