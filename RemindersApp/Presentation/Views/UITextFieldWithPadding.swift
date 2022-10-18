//
//  UITextFieldWithPadding.swift
//  RemindersApp
//
//  Created by Андрей on 18.10.2022.
//

import Foundation
import UIKit

class UITextFieldWithPadding: UITextField {
    
    var textPadding = UIEdgeInsets(
           top: 10,
           left: 10,
           bottom: 10,
           right: 10
       )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
