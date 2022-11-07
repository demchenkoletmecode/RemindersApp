//
//  SceneDelegate.swift
//  RemindersApp
//
//  Created by Andrey on 03.10.2022.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var pendingNotification: UNNotificationResponse?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        appContext.notificationManager.showNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
        
        openTheDesiredController(isLater: false, isAuthorized: false)
    }
    
    func openTheDesiredController(isLater: Bool, isAuthorized: Bool) {
        if isLater || isAuthorized {
            let vc = MainViewController(nibName: "MainViewController", bundle: nil)
            let presenter = MainPresenter(view: vc, reminderService: appContext.firebaseDatabase)
            vc.presenter = presenter
            let navController = UINavigationController(rootViewController: vc)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
            if let pendingNotification {
                proccess(notification: pendingNotification, mainPresenter: presenter)
                self.pendingNotification = nil
            }
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController
            let navController = UINavigationController(rootViewController: controller ?? SignInViewController())
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
    
    func proccess(notification: UNNotificationResponse, mainPresenter: MainPresenter? = nil) {
        var presenter: MainPresenter?
        if let mainPresenter {
            presenter = mainPresenter
        } else {
            if let navVC = window?.rootViewController as? UINavigationController,
               let mainVC = navVC.topViewController as? MainViewController {
                presenter = mainVC.presenter
            }
        }
        guard let presenter else { return }
        
        let reminderInfo = notification.notification.request.content.userInfo
        let reminderId = reminderInfo["REMINDER_ID"] as? String
        
        if let reminderId {
            presenter.highlightReminder(reminderId)
            if notification.actionIdentifier == "COMPLETED_ACTION" {
                presenter.didTapAccomplishment(reminderId: reminderId)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        appContext.coreDateManager.saveContext()
    }

}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void) {

            return completionHandler(UNNotificationPresentationOptions.alert)
        }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
                                @escaping () -> Void) {
        
        if let navVC = window?.rootViewController as? UINavigationController,
           navVC.topViewController is MainViewController {
            proccess(notification: response)
        } else {
            pendingNotification = response
        }
        
        completionHandler()
    }
    
}
