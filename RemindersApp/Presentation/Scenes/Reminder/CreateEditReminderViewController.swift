//
//  CreateEditReminderViewController.swift
//  RemindersApp
//
//  Created by Андрей on 14.10.2022.
//

import UIKit

class CreateEditReminderViewController: UIViewController {
    
    private let textViewMaxHeight: CGFloat = 110.0
    private let textSize: CGFloat = 20.0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        return stackView
    }()
    
    lazy var nameLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.text = "Reminder name"
        txtLbl.textColor = .black
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var nameErrorLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.text = "Enter name!"
        txtLbl.isHidden = true
        txtLbl.textColor = .red
        txtLbl.font = UIFont.boldSystemFont(ofSize: 14)
        return txtLbl
    }()
    
    lazy var nameTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.placeholder = "Enter name"
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    lazy var remindAtLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Remind at"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var dateLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Date"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var dateSwitch: UISwitch = {
        let dateSw = UISwitch()
        dateSw.setOn(false, animated: true)
        return dateSw
    }()
    
    lazy var selectedDateTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.text = "Select date"
        txtField.isHidden = true
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.isHidden = true
        return stackView
    }()
    
    lazy var timeLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Time"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var timeSwitch: UISwitch = {
        let dateSw = UISwitch()
        dateSw.setOn(false, animated: true)
        return dateSw
    }()
    
    lazy var selectedTimeTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.text = "Select time"
        txtField.isHidden = true
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    lazy var repeatLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Repeat at"
        txtLbl.isHidden = true
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var repeatTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.text = "Select periodocity"
        txtField.isHidden = true
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    lazy var notesLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Notes"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.timeZone = TimeZone.current
        
        return timePicker
    }()
    
    lazy var notesTxtView: UITextView = {
        let txtLbl = UITextView()
        txtLbl.heightAnchor.constraint(equalToConstant: textViewMaxHeight).isActive = true
        txtLbl.sizeToFit()
        txtLbl.isScrollEnabled = true
        txtLbl.layer.borderColor = UIColor.lightGray.cgColor
        txtLbl.layer.borderWidth = 1
        txtLbl.layer.cornerRadius = 8
        txtLbl.translatesAutoresizingMaskIntoConstraints = false
        txtLbl.textColor = .black
        txtLbl.delegate = self
        txtLbl.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        txtLbl.contentInsetAdjustmentBehavior = .automatic
        txtLbl.font = UIFont.systemFont(ofSize: 16)
     
        return txtLbl
    }()
    
    var reminderId: String?
    var selectedPeriod: String?
    
    private var presenter: CreateEditPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CreateEditPresenter(view: self)
    
        configureView()
        configureBarItems()
        configureDateTime()
        configurePeriodPickerView()
    }
    
    private func configureView() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        var scrollViewAnchors = [NSLayoutConstraint]()
        scrollViewAnchors.append(scrollView.topAnchor.constraint(equalTo: view.topAnchor))
        scrollViewAnchors.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        scrollViewAnchors.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        scrollViewAnchors.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(scrollViewAnchors)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        var stackViewAnchors = [NSLayoutConstraint]()
        stackViewAnchors.append(stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40))
        stackViewAnchors.append(stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20))
        stackViewAnchors.append(stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20))
        stackViewAnchors.append(stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20))
        stackViewAnchors.append(stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40))
        NSLayoutConstraint.activate(stackViewAnchors)
        
        dateStackView.addArrangedSubview(dateLbl)
        dateStackView.addArrangedSubview(dateSwitch)
        timeStackView.addArrangedSubview(timeLbl)
        timeStackView.addArrangedSubview(timeSwitch)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(nameTxtField)
        stackView.addArrangedSubview(nameErrorLbl)
        stackView.addArrangedSubview(remindAtLbl)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(selectedDateTxtField)
        stackView.addArrangedSubview(timeStackView)
        stackView.addArrangedSubview(selectedTimeTxtField)
        stackView.addArrangedSubview(repeatLbl)
        stackView.addArrangedSubview(repeatTxtField)
        stackView.addArrangedSubview(notesLbl)
        stackView.addArrangedSubview(notesTxtView)
    }
    
    private func configureBarItems() {
        title = "Create Reminder"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(createEditClick))
    }
    
    private func configureDateTime() {
        selectedDateTxtField.inputView = datePicker
        selectedTimeTxtField.inputView = timePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
        let doneDateButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let doneTimeButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.timePickerDone))
        let toolBarDate = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBarDate.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneDateButton], animated: true)
        let toolBarTime = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBarTime.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneTimeButton], animated: true)
        selectedDateTxtField.inputAccessoryView = toolBarDate
        selectedTimeTxtField.inputAccessoryView = toolBarTime
        dateSwitch.addTarget(self, action: #selector(dateSwitchChanged), for: .valueChanged)
        timeSwitch.addTarget(self, action: #selector(timeSwitchChanged), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        selectedDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleTimePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        selectedTimeTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func dateSwitchChanged() {
        presenter.dateSwitchChanged()
    }
    
    @objc private func timeSwitchChanged() {
        presenter.timeSwitchChanged()
    }
    
    @objc func datePickerDone() {
        selectedDateTxtField.resignFirstResponder()
    }
    
    @objc func timePickerDone() {
        selectedTimeTxtField.resignFirstResponder()
    }
    
    private func configurePeriodPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        repeatTxtField.inputView = pickerView
        createPeriodPickerView()
    }
    
    @objc private func createEditClick() {
        presenter.tapSaveEditReminder()
    }
    
    @objc private func cancelClick() {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateEditReminderViewController: UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.periodList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.periodList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPeriod = presenter.periodList[row]
        repeatTxtField.text = selectedPeriod
    }
    
    func createPeriodPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        repeatTxtField.inputView = pickerView
        dismissPickerView()
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))], animated: true)
        toolBar.isUserInteractionEnabled = true
        repeatTxtField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let isOversize = notesTxtView.contentSize.height > textViewMaxHeight
        notesTxtView.isScrollEnabled = isOversize
        notesTxtView.frame.size.height = textView.contentSize.height
    }
}

extension CreateEditReminderViewController: CreateEditProtocol {
    var name: String {
        return nameTxtField.text ?? ""
    }
    
    var isDateSelected: Bool {
        get {
            return dateSwitch.isOn
        }
        set {
            selectedDateTxtField.isHidden = newValue
            timeStackView.isHidden = newValue
            repeatLbl.isHidden = newValue
            repeatTxtField.isHidden = newValue
        }
    }
    
    var date: String {
        return selectedDateTxtField.text ?? ""
    }
    
    var isTimeSelected: Bool {
        get {
            return timeSwitch.isOn
        }
        set {
            selectedTimeTxtField.isHidden = newValue
        }
    }
    
    var time: String {
        return selectedTimeTxtField.text ?? ""
    }
    
    var nameError: String {
        get {
            return ""
        }
        set {
            if newValue.isEmpty {
                nameErrorLbl.isHidden = true
            } else {
                nameErrorLbl.isHidden = false
                nameErrorLbl.text = newValue
            }
        }
    }
    
    func presentReminder(reminder: Reminder?) {
        
    }
    
    func save() {
        navigationController?.popViewController(animated: true)
    }
    
    func update() {
        
    }
    
}

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
