//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Connor Boyce on 8/16/19.
//  Copyright © 2019 Connor Boyce. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

        print(Realm.Configuration.defaultConfiguration.fileURL)


        do{
        _ = try Realm()
        } catch {
            print("Error initializing new Realm \(error)")
        }
        return true
    }

}
