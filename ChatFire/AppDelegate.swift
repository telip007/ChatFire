//
//  AppDelegate.swift
//  ChatFire
//
//  Created by Talip Göksu on 27.08.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit
import Firebase

var ref: FIRDatabaseReference?
var storage: FIRStorageReference?
var currentUser: FIRUser?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        ref = FIRDatabase.database().reference()
        
        storage = FIRStorage.storage().reference()
        
        if let window = self.window{
            // Change the backgroundColor to make the presentation of the root view controller look smoother
            window.backgroundColor = .whiteColor()
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    // This worked out because when I set the rootViewController in the animation, the navigation bar slides down from status bar...
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let freshman = defaults.boolForKey("Freshman")
                    if freshman == true{
                        let rootView: FreshmanViewController = FreshmanViewController()
                        currentUser = user
                        UIView.transitionWithView(window, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                            window.rootViewController = rootView
                            }, completion: nil)
                    }else{
                        currentUser = user
                        let tabBarController = TabBarViewController()
                        window.rootViewController = tabBarController
                    }
                } else {
                    let rootView: LoginViewController = LoginViewController()
                    UIView.transitionWithView(window, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                        window.rootViewController = rootView
                        }, completion: nil)
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

