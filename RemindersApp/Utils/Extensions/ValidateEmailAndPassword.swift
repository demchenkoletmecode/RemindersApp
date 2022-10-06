//
//  ValidateEmailAndPassword.swift
//  RemindersApp
//
//  Created by Andrey on 04.10.2022.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isPasswordHasEightCharacter(_ password: String) -> Bool {
    let passWordRegEx = "^.{8,}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passWordRegEx)
    return passwordTest.evaluate(with: password)
}
func isPasswordHasNumberAndCharacter(_ password: String) -> Bool {
    let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
    return passwordTest.evaluate(with: password)
}