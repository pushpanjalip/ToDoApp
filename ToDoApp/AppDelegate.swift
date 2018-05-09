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
        
        let config = Realm.Configuration(
            
            schemaVersion: 2,
            
            migrationBlock: { migration, oldSchemaVersion in
                
//                if (oldSchemaVersion < 2) {
//                    migration.enumerateObjects(ofType: Item.className()) { (old, new) in
//                        new!["dateCreated"] = Date()
//                    }
//                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }

}

