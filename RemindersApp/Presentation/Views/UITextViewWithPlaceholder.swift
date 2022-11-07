//
//  UITextViewWithPlaceholder.swift
//  RemindersApp
//
//  Created by Андрей on 18.10.2022.
//

import Foundation
import UIKit

class UITextViewWithPlaceholder: UITextView {
    
    override var text: String! {
        didSet {
            onTextChanged()
        }
    }
    
    var placeholderText: String = "Enter notes".localized
    var placeholderTextColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    var placeholderTextFont = UIFont.systemFont(ofSize: 20)
    
    private var showingPlaceholder = true
    private var placeholderLabel: UILabel!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = placeholderTextFont
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 15, y: 8)
        placeholderLabel.textColor = placeholderTextColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func onTextChanged() {
         placeholderLabel.isHidden = !text.isEmpty
    }
    
}
