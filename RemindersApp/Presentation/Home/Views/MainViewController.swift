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
    
    private let authService = appContext.authentication
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RemindersApp"
        configureBarItems()
    }
    
    @objc private func signInSignOutClick() {
        if AuthService.isAuthorized {
            authService.logoutUser()
            navigationController?.popToRootViewController(animated: true)
        }
        
        let signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignInVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func configureBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: nil)
        if AuthService.isAuthorized {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signInSignOutClick))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(signInSignOutClick))
        }
    }
    
}

