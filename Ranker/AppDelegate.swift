//
//  AppDelegate.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import UIKit
import Firebase

enum UID: String {
    case uid
}

var uid: String?
var maxLocalDistance: Double = 5

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let defaults = UserDefaults.standard
        
        // get UID
        if let retUID = defaults.object(forKey: UID.uid.rawValue) as? String  {
            uid = retUID
        } else {
            uid = UUID().uuidString
            defaults.set(uid, forKey: UID.uid.rawValue)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

