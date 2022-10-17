//
//  TestViewController.swift
//  RemindersApp
//
//  Created by Андрей on 13.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let authService = appContext.authentication
    private var presenter: MainPresenter!
    private var sections: [SectionReminders] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RemindersApp"
        configureBarItems()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ReminderCell", bundle: .main), forCellReuseIdentifier: "ReminderCell")
        tableView.register(UINib(nibName: "ReminderSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeader")
        
        presenter = MainPresenter(view: self)
        presenter.getReminders()
    }
    
    @objc private func signInSignOutClick() {
        presenter.tapOnSignInSignOut()
    }
    
    @objc private func addReminder() {
        presenter.tapAddReminder()
    }
    
    private func configureBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(addReminder))
        if AuthService.isAuthorized {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signInSignOutClick))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(signInSignOutClick))
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderTableViewCell

        cell.checkBoxDelegate = self
  
        cell.setViews(cellModel: sections[indexPath.section].rows[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding / 2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapReminder(reminderId: (sections[indexPath.section].rows[indexPath.row].objectId))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! ReminderSectionHeader
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.gray,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)]
            as [NSAttributedString.Key : Any]

        view.nameLbl.attributedText = NSAttributedString(string: sections[section].type.displayString, attributes: strokeTextAttributes)
        return view
    }
    
}

extension MainViewController: ReminderCellProtocol {
    
    func checkBoxClick(_ cell: ReminderTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            var reminder = sections[indexPath.section].rows[indexPath.row]
            reminder.changeAccomplishment()
        }
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
        case .createReminder:
            let createReminderViewController = CreateEditReminderViewController()
            createReminderViewController.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(createReminderViewController, animated: true)
            
        case .detailsRemainder:
            let createViewController = CreateEditReminderViewController()
            createViewController.reminderId = "id"
            createViewController.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(createViewController, animated: true)
        }
    }
    
    func presentReminders(reminders: [SectionReminders]) {
        self.sections = reminders
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

