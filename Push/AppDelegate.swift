//
//  AppDelegate.swift
//  Test
//
//  Created by Dan Bellinski on 4/4/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import UIKit
import Appodeal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate /*GADRewardBasedVideoAdDelegate*/ {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        //GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-4505737160765142~1208265512");
        let adTypes: AppodealAdType = [AppodealAdType.interstitial, /*.skippableVideo,*/ AppodealAdType.rewardedVideo];
        Appodeal.initialize(withApiKey:"e5ac706b45d36d6a998c42fb1aec1e0d4b469e9986cedc58", types: adTypes);
        Appodeal.setAutocache(false, types: [AppodealAdType.interstitial, AppodealAdType.rewardedVideo])
        
        Appodeal.setTestingEnabled(true)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // Send out a notification that we need to pause the game
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PauseGameScene"), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // We need to keep the game paused when we resume
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StayPausedNotification"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        GameData.sharedGameData.save()
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return false
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape;
    }
}

