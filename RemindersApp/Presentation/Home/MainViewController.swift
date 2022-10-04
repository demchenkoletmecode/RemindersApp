//
//  ViewController.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var signInSignOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAuthorized() {
            signInSignOutBtn.setTitle("Sign Out", for: .normal)
        } else {
            signInSignOutBtn.setTitle("Sign In to save your reminders", for: .normal)
        }
    }
    
    @IBAction func signInSignOutClick(_ sender: Any) {
        if isAuthorized() {
            logoutUser()
        }
        
        let signInStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "AuthVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        }
        catch { print("already logged out") }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}

