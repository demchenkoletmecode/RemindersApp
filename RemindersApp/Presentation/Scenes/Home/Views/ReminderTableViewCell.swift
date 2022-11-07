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

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var checkBox: UIButton!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var timeDateLbl: UILabel!
    @IBOutlet private weak var periodicityLbl: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var checkBoxDelegate: ReminderCellProtocol?
    
    let separator = UIView()
    
    func setViews(cellModel: ReminderRow) {
        
        view.backgroundColor = UIColor.systemGray6
        
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
        
        timeDateLbl.isHidden = timeDate == nil
        periodicityLbl.isHidden = periodicity == nil
        
        if periodicity == nil, timeDate != nil {
            timeDateLbl.font = UIFont.boldSystemFont(ofSize: 26)
        } else if timeDate == nil, periodicity != nil {
            periodicityLbl.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            timeDateLbl.font = UIFont.boldSystemFont(ofSize: 20)
            periodicityLbl.font = UIFont.boldSystemFont(ofSize: 20)
        }
    
        setAccomplishment()
        setOverdueItem(dateStr: timeDate)
    }
    
    @objc
    private func checkMarkButtonClicked(sender: UIButton) {
        sender.isSelected.toggle()
        if let delegateObject = self.checkBoxDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                delegateObject.checkBoxClick(self)
            }
        }
    }
    
    func setAccomplishment() {
        nameLbl.alpha = checkBox.isSelected ? 0.5 : 1
        timeDateLbl.alpha = checkBox.isSelected ? 0.5 : 1
        periodicityLbl.alpha = checkBox.isSelected ? 0.5 : 1
    }
    
    private func setOverdueItem(dateStr: String?) {
        if let dateStr = dateStr,
           let currentDate = Date().timeFormat.timeToDate,
           let date = dateStr.timeToDate,
           date < currentDate {
            nameLbl.textColor = UIColor.systemRed
            timeDateLbl.textColor = UIColor.systemRed
            checkBox.tintColor = UIColor.systemRed
        } else {
            nameLbl.textColor = UIColor.black
            timeDateLbl.textColor = UIColor.systemGray
            checkBox.tintColor = UIColor.systemGreen
        }
    }

    func changeBackground() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       animations: {() -> Void in
            self.view.backgroundColor = UIColor.systemGray4
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           animations: {() -> Void in
                self.view.backgroundColor = UIColor.systemGray6
            })
        }
    }
    
}
