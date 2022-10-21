//
//  ReminderTableViewCell.swift
//  RemindersApp
//
//  Created by Andrey on 10.10.2022.
//

import UIKit

protocol ReminderCellProtocol: AnyObject {
    func checkBoxClick(_ cell: ReminderTableViewCell)
}

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet private weak var checkBox: UIButton!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var timeDateLbl: UILabel!
    @IBOutlet private weak var periodicityLbl: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var checkBoxDelegate: ReminderCellProtocol?
    
    let separator = UIView()
    
    func setViews(cellModel: ReminderRow) {
        
        if cellModel.name.count > 20 {
            nameLbl.font = UIFont.boldSystemFont(ofSize: 18)
        } else {
            nameLbl.font = UIFont.boldSystemFont(ofSize: 23)
        }
        
        let periodicity = cellModel.periodicityString
        let timeDate = cellModel.dateString
        
        nameLbl.text = cellModel.name
        checkBox.isSelected = cellModel.isChecked
        periodicityLbl.text = periodicity
        timeDateLbl.text = timeDate
        checkBox.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        
        timeDateLbl.isHidden = (timeDate == nil)
        periodicityLbl.isHidden = (periodicity == nil)
        
        if periodicity == nil, timeDate != nil {
            timeDateLbl.font = UIFont.boldSystemFont(ofSize: 26)
        } else if timeDate == nil, periodicity != nil {
            periodicityLbl.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            timeDateLbl.font = UIFont.boldSystemFont(ofSize: 20)
            periodicityLbl.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        setAccomplishment()
    }
    
    @objc
    private func checkMarkButtonClicked(sender: UIButton) {
        sender.isSelected.toggle()
        if let delegateObject = self.checkBoxDelegate {
            delegateObject.checkBoxClick(self)
        }
    }
    
    func setAccomplishment() {
        checkBox.isSelected ? (
            nameLbl.alpha = 0.5,
            timeDateLbl.alpha = 0.5,
            periodicityLbl.alpha = 0.5
        ) : (
            nameLbl.alpha = 1,
            timeDateLbl.alpha = 1,
            periodicityLbl.alpha = 1
        )
    }
}
