//
//  ViewController.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let authService = appContext.authentication
    private var presenter: MainPresenter!
    private var sections: [SectionReminders] = []
    
    //private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RemindersApp"
        configureBarItems()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = MainPresenter(view: self)
        presenter.getReminders()
    }
    
 
    
    @objc private func signInSignOutClick() {
        presenter.tapOnSignInSignOut()
    }
    
    private func configureBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: nil)
        if AuthService.isAuthorized {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signInSignOutClick))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(signInSignOutClick))
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].reminders?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderTableViewCell
        
        let name = sections[indexPath.section].reminders?[indexPath.row].name
        let isSelected = sections[indexPath.section].reminders?[indexPath.row].isDone ?? false
        let timeDate = sections[indexPath.section].reminders?[indexPath.row].timeDate
        let periodicity = sections[indexPath.section].reminders?[indexPath.row].periodicity
        
        cell.nameLbl.text = name
        cell.checkBox.isSelected = isSelected
        cell.timeDateLbl.text = timeDate
        cell.periodicityLbl.text = periodicity
        cell.checkBox.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        
        cell.stackView.removeArrangedSubview(cell.periodicityLbl)
        cell.stackView.removeArrangedSubview(cell.timeDateLbl)
        
        if periodicity == nil, timeDate != nil {
            cell.stackView.addArrangedSubview(cell.timeDateLbl)
            cell.timeDateLbl.font = UIFont.boldSystemFont(ofSize: 26)
        } else if timeDate == nil, periodicity != nil {
            cell.stackView.addArrangedSubview(cell.periodicityLbl)
            cell.periodicityLbl.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            cell.stackView.addArrangedSubview(cell.timeDateLbl)
            cell.stackView.addArrangedSubview(cell.periodicityLbl)
            cell.timeDateLbl.font = UIFont.boldSystemFont(ofSize: 20)
            cell.periodicityLbl.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        return cell
    }
    
    @objc func checkMarkButtonClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapReminder(reminder: (sections[indexPath.section].reminders?[indexPath.row])!)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].section
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.gray,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)]
            as [NSAttributedString.Key : Any]
        
        let lbl = UILabel(frame: CGRect(x: 16, y: -30, width: view.frame.width - 16, height: 80))
        lbl.attributedText = NSAttributedString(string: sections[section].section ?? "", attributes: strokeTextAttributes)
        
        view.addSubview(lbl)
        return view
    }
    
}

extension MainViewController: MainViewProtocol {
   
    func move(to: MainViewNavigation) {
        switch to {
        case .goToSignIn:
            let signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignInVC")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        case .logoutUserGoToSignIn:
            authService.logoutUser()
            navigationController?.popToRootViewController(animated: true)
            
            let signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignInVC")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        case .createReminder: break
        case .detailsRemainder: break
        }
    }
    
    func presentReminders(reminders: [SectionReminders]) {
        self.sections = reminders
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

