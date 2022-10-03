//
//  ViewController.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func segueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAuthStoryboard", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAuthStoryboard" {
                    guard let vc = segue.destination as? AuthViewController else { return }
                }
    }
}

