//
//  AppDelegate.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 6/30/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift
import UserNotifications
var username = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.p
        
        Parse.enableLocalDatastore()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "JaLYLJdBNFhpDM4xIDCorQO1Dg2KBDOZLTW5AFbC"
            $0.clientKey = "71A6ZGOc7p8cgPKJLrxHu1FHKXXkL9OAJzwxSHxC"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        saveInstallationObject()
        
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay ]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
        
        
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        // PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.hasPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            /*
             let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
             let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
             var noPushPayload = false;
             if let options = launchOptions {
             noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
             }
             if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
             PFAnalytics.trackAppOpened(launchOptions: launchOptions)
             }
             */
        }
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //enables IQKeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        
        return true
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        createInstallationOnParse(deviceTokenData: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func createInstallationOnParse(deviceTokenData:Data){
        if let installation = PFInstallation.current(){
            installation.setDeviceTokenFrom(deviceTokenData)
            installation.setObject(["News"], forKey: "channels")
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully saved your push installation to Back4App!")
                } else {
                    if let myError = error{
                        print("Error saving parse installation \(myError.localizedDescription)")
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        if PFUser.current()!["isGuiding"] != nil{
            if PFUser.current()!["isGuiding"] as! Bool == true{
                // Print notification payload data
                print("Push notification received.")
                guard
                    let aps = data[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? String
                    else {
                        // handle any error here
                        print("Error")
                        return
                }
                print("Title:\(alert)")
                username = alert
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc : UIViewController
                
                vc = storyboard.instantiateViewController(withIdentifier: "RiderViewController")
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                
            }else{
                // Print notification payload data
                print("Push notification received.")
                guard
                    let aps = data[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? String
                    else {
                        // handle any error here
                        print("Error")
                        return
                }
                print("Title:\(alert)")
                username = alert
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc : UIViewController
                
                vc = storyboard.instantiateViewController(withIdentifier: "GuideViewController")
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }else{
            // Print notification payload data
            print("Push notification received.")
            guard
                let aps = data[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? String
                else {
                    // handle any error here
                    print("Error")
                    return
            }
            print("Title:\(alert)")
            username = alert
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var vc : UIViewController
            
            vc = storyboard.instantiateViewController(withIdentifier: "GuideViewController")
            
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        //PFPush.handle(notification.request.content.userInfo)
        if PFUser.current()!["isGuiding"] != nil{
            if PFUser.current()!["isGuiding"] as! Bool == true{
                // Print notification payload data
                print("Push notification received.")
                guard
                    let aps = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? String
                    else {
                        // handle any error here
                        print("Error")
                        return
                }
                print("Title:\(alert)")
                username = alert
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc : UIViewController
                
                vc = storyboard.instantiateViewController(withIdentifier: "RiderViewController")
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                
            }else{
                // Print notification payload data
                print("Push notification received.")
                guard
                    let aps = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? String
                    else {
                        // handle any error here
                        print("Error")
                        return
                }
                print("Title:\(alert)")
                username = alert
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc : UIViewController
                
                vc = storyboard.instantiateViewController(withIdentifier: "GuideViewController")
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                
            }
        }else{
            // Print notification payload data
            print("Push notification received.")
            guard
                let aps = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? String
                else {
                    // handle any error here
                    print("Error")
                    return
            }
            print("Title:\(alert)")
            username = alert
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var vc : UIViewController
            
            vc = storyboard.instantiateViewController(withIdentifier: "GuideViewController")
            
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
        }
    }
}
