//
//  CustomHeader.swift
//  RemindersApp
//
//  Created by Андрей on 12.10.2022.
//

import UIKit

class ReminderSectionHeader: UITableViewHeaderFooterView {

    static let reuseIdentifier = "CustomHeader"
    
    @IBOutlet private weak var nameLbl: UILabel!
    
    func setHeaderText(text: NSAttributedString) {
        nameLbl.attributedText = text
    }
    
}
