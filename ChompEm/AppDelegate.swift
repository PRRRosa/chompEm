//
//  AppDelegate.swift
//  amoebaProject
//
//  Created by Paulo Ricardo Ramos da Rosa on 6/17/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        var notification = UILocalNotification()
        notification.alertBody = "I'm hungry!"
        notification.alertAction = "open"
        notification.fireDate = NSDate().dateByAddingTimeInterval(2*7*24*3600)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["title": "Reminder"]
        notification.category = "TODO_CATEGORY"
        
        
        if let UIApplication.sharedApplication().scheduledLocalNotifications.first{
            UIApplication.sharedApplication().scheduledLocalNotifications.first?.scheduleLocalNotification(notification)
        }
        else{
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        println(notification.userInfo!["title"] as! String)
        
        switch (identifier!) {
        case "REMIND":
            println("REMIND LATER")
        default: // switch statements must be exhaustive - this condition should never be met
            println("Error: unexpected notification action identifier!")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        if let userInfo = userInfo, request = userInfo["request"] as? String {
            if request == "getCounter" {
                
                if let score = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? NSInteger {
                    
                    reply(["score": score])
                    return
                }
                else{
                    reply(["score": NSKeyedArchiver.archivedDataWithRootObject("0")])
                    return
                }
            }
        }
        reply([:])
    }
    
}

