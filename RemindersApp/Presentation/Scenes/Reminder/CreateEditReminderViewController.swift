//
//  CreateEditReminderViewController.swift
//  RemindersApp
//
//  Created by Андрей on 14.10.2022.
//

import UIKit

protocol CreateEditReminderDelegate: AnyObject {
    
    func didSaveReminder()
    
}

class CreateEditReminderViewController: UIViewController {
    
    private let textViewMaxHeight: CGFloat = 110.0
    private let textSize: CGFloat = 20.0
    
    weak var delegate: CreateEditReminderDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        return stackView
    }()
    
    private lazy var nameLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.text = "Reminder name"
        txtLbl.textColor = .black
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var nameErrorLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.text = "Enter name!"
        txtLbl.isHidden = true
        txtLbl.textColor = UIColor.systemRed
        txtLbl.font = UIFont.boldSystemFont(ofSize: 14)
        return txtLbl
    }()
    
    private lazy var nameTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.placeholder = "Enter name"
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    private lazy var remindAtLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Remind at"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var dateLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Date"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var dateSwitch: UISwitch = {
        let dateSw = UISwitch()
        dateSw.setOn(true, animated: true)
        return dateSw
    }()
    
    private lazy var selectedDateTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.placeholder = "Select date"
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var timeLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Time"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var timeSwitch: UISwitch = {
        let dateSw = UISwitch()
        dateSw.setOn(true, animated: true)
        return dateSw
    }()
    
    private lazy var selectedTimeTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.placeholder = "Select time"
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    private lazy var repeatLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Repeat at"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var repeatTxtField: UITextFieldWithPadding = {
        let txtField = UITextFieldWithPadding()
        txtField.textColor = .black
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.placeholder = "Select periodocity"
        txtField.font = UIFont.systemFont(ofSize: textSize)
        return txtField
    }()
    
    private lazy var notesLbl: UILabel = {
        let txtLbl = UILabel()
        txtLbl.textColor = .black
        txtLbl.text = "Notes"
        txtLbl.font = UIFont.boldSystemFont(ofSize: textSize)
        return txtLbl
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date()
        timePicker.timeZone = TimeZone.current
        
        return timePicker
    }()
    
    private lazy var notesTxtView: UITextViewWithPlaceholder = {
        let txtView = UITextViewWithPlaceholder()
        txtView.heightAnchor.constraint(equalToConstant: textViewMaxHeight).isActive = true
        txtView.sizeToFit()
        txtView.isScrollEnabled = true
        txtView.layer.borderColor = UIColor.lightGray.cgColor
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 8
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.textColor = .black
        txtView.delegate = self
        txtView.placeholderText = "Enter notes"
        txtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        txtView.contentInsetAdjustmentBehavior = .automatic
        txtView.font = UIFont.systemFont(ofSize: 16)
     
        return txtView
    }()
    
    private var selectedPeriod: Int?
    private var selectedDate: Date?
    
    var presenter: CreateEditPresenter?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = CreateEditPresenter(view: self, id: nil)
        }
    
        configureView()
        configureBarItems()
        configureDateTime()
        configurePeriodPickerView()
        
        if let isEdit = presenter?.isEditReminder(), isEdit {
            presentReminder()
        }
    }
    
    private func configureView() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
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
        
        let safeArea = self.view.safeAreaLayoutGuide
        let frameGuideScrollView = scrollView.frameLayoutGuide
        let contentGuideScrollView = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
          frameGuideScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
          frameGuideScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
          frameGuideScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
          frameGuideScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          contentGuideScrollView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
          contentGuideScrollView.topAnchor.constraint(equalTo: stackView.topAnchor),
          contentGuideScrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
          contentGuideScrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
          frameGuideScrollView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
        
    private func configureBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(cancelClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(createEditClick))
    }
    
    private func configureDateTime() {
        selectedDateTxtField.inputView = datePicker
        selectedTimeTxtField.inputView = timePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
        
        let doneDateButton = UIBarButtonItem.init(title: "Done",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(self.datePickerDone))
        let doneTimeButton = UIBarButtonItem.init(title: "Done",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(self.timePickerDone))
        
        let toolBarDate = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        
        toolBarDate.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                              doneDateButton],
                             animated: true)
        
        let toolBarTime = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        
        toolBarTime.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                              doneTimeButton],
                             animated: true)
        
        selectedDateTxtField.inputAccessoryView = toolBarDate
        selectedTimeTxtField.inputAccessoryView = toolBarTime
        dateSwitch.addTarget(self, action: #selector(dateSwitchChanged), for: .valueChanged)
        timeSwitch.addTarget(self, action: #selector(timeSwitchChanged), for: .valueChanged)
    }
    
    @objc
    func handleDatePicker(sender: UIDatePicker) {
        selectedDate = sender.date
        presenter?.updateDate(date: selectedDate)
    }
    
    @objc
    func handleTimePicker(sender: UIDatePicker) {
        selectedDate = sender.date
        presenter?.updateTime(date: selectedDate)
    }
    
    @objc
    private func dateSwitchChanged() {
        presenter?.dateSwitchChanged()
    }
    
    @objc
    private func timeSwitchChanged() {
        presenter?.timeSwitchChanged()
    }
    
    @objc
    func datePickerDone() {
        selectedDateTxtField.resignFirstResponder()
    }
    
    @objc
    func timePickerDone() {
        selectedTimeTxtField.resignFirstResponder()
    }
    
    @objc
    private func createEditClick() {
        presenter?.tapSaveEditReminder()
    }
    
    @objc
    private func cancelClick() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentReminder() {
        presenter?.getReminder()
    }
}

extension CreateEditReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.periodList.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.periodList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPeriod = row
        repeatTxtField.text = presenter?.periodList[row]
    }
    
    func configurePeriodPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        repeatTxtField.inputView = pickerView
        setupDoneToolbar()
    }
    
    func setupDoneToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([UIBarButtonItem(title: "Done",
                                          style: .plain,
                                          target: self,
                                          action: #selector(self.onDoneTapped))],
                         animated: true)
        toolBar.isUserInteractionEnabled = true
        repeatTxtField.inputAccessoryView = toolBar
    }
    
    @objc
    private func onDoneTapped() {
        view.endEditing(true)
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
            if newValue {
                selectedTimeTxtField.isHidden = newValue
            } else {
                selectedTimeTxtField.isHidden = !timeSwitch.isOn
            }
        }
    }
    
    var date: Date? {
        get {
            return selectedDate
        }
        set {
            selectedDate = newValue
            selectedDateTxtField.text = newValue?.dateFormat
        }
    }
    
    var dateString: String? {
        return selectedDateTxtField.text
    }
    
    var isTimeSelected: Bool {
        get {
            return timeSwitch.isOn
        }
        set {
            selectedTimeTxtField.isHidden = newValue
        }
    }
    
    var time: Date? {
        get {
            return selectedDate
        }
        set {
            selectedDate = newValue
            selectedTimeTxtField.text = newValue?.timeFormat
        }
    }
    
    var timeString: String? {
        return selectedTimeTxtField.text
    }
    
    var periodicity: Int? {
        return selectedPeriod
    }
    
    var notes: String? {
        return notesTxtView.text
    }
    
    func showReminder(reminder: Reminder?) {
        nameTxtField.text = reminder?.name
        selectedDateTxtField.text = reminder?.timeDate?.dateFormat
        selectedTimeTxtField.text = reminder?.timeDate?.timeFormat
        repeatTxtField.text = reminder?.periodicity?.displayValue
        notesTxtView.text = reminder?.notes
    }
    
    func save() {
        delegate?.didSaveReminder()
        navigationController?.popViewController(animated: true)
    }
    
    func update(nameError: String?) {
        nameErrorLbl.isHidden = nameError?.isEmpty != false
        if let error = nameError {
            nameErrorLbl.text = error
        }
    }
    
}

extension CreateEditReminderViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        notesTxtView.text = textView.text
    }
    
}
