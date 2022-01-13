//
//  AppDelegate.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 07.09.2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCOntroller = UINavigationController(rootViewController: GreetingVC())
        navigationCOntroller.navigationBar.tintColor = .black
        window?.rootViewController = navigationCOntroller
        window?.makeKeyAndVisible()

        // включаем сторонюю библиотеку для клавы
        IQKeyboardManager.shared.enable = true
        // Выключаем тулбар Серая полоска
        IQKeyboardManager.shared.enableAutoToolbar = false
        // Убираем клаву при нажатии в сторону
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }
}
