//
//  AppDelegate.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 07.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PreviewVC()
        window?.makeKeyAndVisible()
    
    
        return true
    }

}


