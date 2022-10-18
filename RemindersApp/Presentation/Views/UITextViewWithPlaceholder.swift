//
//  UITextViewWithPlaceholder.swift
//  RemindersApp
//
//  Created by Андрей on 18.10.2022.
//

import Foundation
import UIKit

@IBDesignable class UITextViewWithPlaceholder: UITextView {
    
    override var text: String! {
        get {
            if showingPlaceholder {
                return ""
            } else { return super.text }
        }
        set { super.text = newValue }
    }
    
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    @IBInspectable var placeholderTextFont: UIFont = UIFont.systemFont(ofSize: 20)
    //@IBInspectable var isSetScrollEnabledAfterCertainHeight: Bool = false
    //@IBInspectable var heightForEnabledScroll: CGFloat = 110.0
    
    private var showingPlaceholder: Bool = true
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        if showingPlaceholder {
            text = nil
            textColor = nil
            font = UIFont.systemFont(ofSize: 16)
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        font = placeholderTextFont
        text = placeholderText
    }
    
}

