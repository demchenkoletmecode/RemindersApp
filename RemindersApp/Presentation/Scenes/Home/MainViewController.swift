//
//  TestViewController.swift
//  RemindersApp
//
//  Created by Андрей on 13.10.2022.
//

import Firebase
import FirebaseAuth
import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let authService = appContext.authentication
    private var sections: [SectionReminders] = []
    private let refreshControl = UIRefreshControl()
    var presenter: MainPresenter!
    
    var cellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        
        title = "RemindersApp"
        configureBarItems()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        let header = "ReminderSectionHeader"
        tableView.register(UINib(nibName: "ReminderCell", bundle: .main), forCellReuseIdentifier: "ReminderCell")
        tableView.register(UINib(nibName: header, bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeader")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc
    private func refresh(_ sender: AnyObject) {
        presenter.getReminders()
        refreshControl.endRefreshing()
    }
    
    @objc
    private func signInSignOutClick() {
        presenter.tapOnSignInSignOut()
    }
    
    @objc
    private func addReminder() {
        presenter.tapAddReminder()
    }
    
    private func refreshData() {
        presenter.getReminders()
    }
    
    private func configureBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(addReminder))
        if AuthService.isAuthorized {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out".localized,
                                                                    style: .done,
                                                                    target: self,
                                                                    action: #selector(signInSignOutClick))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In".localized,
                                                                    style: .done,
                                                                    target: self,
                                                                    action: #selector(signInSignOutClick))
        }
    }
    
    func changeBackground(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell {
            cell.changeBackground()
        } else {
            cellIndexPath = indexPath
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as? ReminderTableViewCell else {
           fatalError("Could not dequeue cell of type ReminderTableViewCell")
        }
        cell.checkBoxDelegate = self
        cell.setViews(cellModel: sections[indexPath.section].rows[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellIndexPath, let reminderCell = cell as? ReminderTableViewCell, indexPath == cellIndexPath {
            reminderCell.changeBackground()
            self.cellIndexPath = nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapReminder(reminderId: (sections[indexPath.section].rows[indexPath.row].objectId))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as? ReminderSectionHeader
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.gray,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4.0,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26)]
        as [NSAttributedString.Key: Any]
        
        let nameSection = sections[section].type.displayString

        view?.setHeaderText(text: NSAttributedString(string: nameSection, attributes: strokeTextAttributes))
        return view
    }
    
}

extension MainViewController: ReminderCellProtocol {
    
    func checkBoxClick(_ cell: ReminderTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            var reminder = sections[indexPath.section].rows[indexPath.row]
            reminder.changeAccomplishment()
            presenter?.didTapAccomplishment(reminderId: (reminder.objectId))
            cell.setAccomplishment()
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
            let vc = CreateEditReminderViewController()
            vc.delegate = self
            vc.title = "Create Reminder".localized
            navigationController?.pushViewController(vc, animated: true)
            
        case let .detailsReminder(reminderId):
            let vc = CreateEditReminderViewController()
            vc.delegate = self
            vc.title = "Edit Reminder".localized
            vc.presenter = CreateEditPresenter(view: vc, reminderService: appContext.firebaseDatabase, id: reminderId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentReminders(reminders: [SectionReminders]) {
        sections = reminders
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension MainViewController: CreateEditReminderDelegate {
    
    func didSaveReminder() {
        refreshData()
    }
    
}
