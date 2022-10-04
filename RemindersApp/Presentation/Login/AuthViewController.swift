//
//  AuthViewController.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorEmailLbl: UILabel!
    
    @IBOutlet weak var errorPasswordLbl: UILabel!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func signInClick(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if validateEmailAndPassword(email, password) {
               login(email, password)
            }
        }
    }
    
    func validateEmailAndPassword(_ email: String, _ password: String) -> Bool {
        if email == "" && password == "" {
            errorEmailLbl.isHidden = false
            errorEmailLbl.text = "Enter Email!"
            errorPasswordLbl.isHidden = false
            errorPasswordLbl.text = "Enter Password!"
            signInBtn.isEnabled = false
        } else {
            if email == "" {
                errorEmailLbl.isHidden = false
                errorEmailLbl.text = "Enter Email!"
                signInBtn.isEnabled = false
            }
            if password == "" {
                errorPasswordLbl.isHidden = false
                errorPasswordLbl.text = "Enter Password!"
                signInBtn.isEnabled = false
            } else {
                errorEmailLbl.isHidden = true
                errorPasswordLbl.isHidden = true
                if !isValidEmail(email) {
                    errorEmailLbl.isHidden = false
                    errorEmailLbl.text = "Invalide email"
                    signInBtn.isEnabled = false
                }
                if !isPasswordHasEightCharacter(password) {
                    errorPasswordLbl.isHidden = false
                    errorPasswordLbl.text = "Password should have at least 8 characters!"
                    signInBtn.isEnabled = false
                } else {
                    if !isPasswordHasNumberAndCharacter(password) {
                        errorPasswordLbl.isHidden = false
                        errorPasswordLbl.text = "Password should have at least 1 number and 1 character!"
                        signInBtn.isEnabled = false
                    } else {
                        errorEmailLbl.isHidden = true
                        errorPasswordLbl.isHidden = true
                        signInBtn.isEnabled = true
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        signInBtn.isEnabled = true
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        signInBtn.isEnabled = true
    }
    
    @IBAction func laterClick(_ sender: UIButton) {
        let signInStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "MainVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }


    @IBAction func signUpClick(_ sender: Any) {
        let signUpStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = signUpStoryboard.instantiateViewController(withIdentifier: "SignUpVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func login(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {return}
            
            if let error = error {
                print("Error \(error.localizedDescription)")
                self?.errorPasswordLbl.isHidden = false
                //self?.errorPasswordLbl.text = error.localizedDescription
                self?.errorPasswordLbl.text = "Email or Password are incorrect"
                self?.signInBtn.isEnabled = false
            } else {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
        }
    }
}
