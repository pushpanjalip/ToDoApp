//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/9/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let realm = try Realm()
            
        }catch{
            print("Realm initialization Error \(error)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL)
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }

}

