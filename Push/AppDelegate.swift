//
//  AppDelegate.swift
//  Test
//
//  Created by Dan Bellinski on 4/4/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import UIKit
//import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate /*GADRewardBasedVideoAdDelegate*/ {

    var window: UIWindow?
    
    // Video rewards
    var presentingVideo: Bool = false
    var completedVideo: Bool = false
    var dismissingVideo: Bool = false
    var videoIsCached: Bool = false
    
    // Static rewards
    var tryingToShowStaticAds: Bool = false

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Initialize the Chartboost library
        //Chartboost.start(withAppId: "576a8abe04b01657f1e18be5", appSignature: "54c4763f89ea9ff96502d320787de1cb9ceb7c21", delegate: self)
        // Admob
        //GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-4505737160765142~1208265512");
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
    
    // ************************* REWARDED VIDEO CALLBACKS *************
    
    // Called after videos have been successfully prefetched.
    //func didPrefetchVideos() {}
    
    // Called before a rewarded video will be displayed on the screen.
    // func shouldDisplayRewardedVideo(location: String!) -> Bool {}
    
    // Called after a rewarded video has been displayed on the screen.
    func didDisplayRewardedVideo(_ location: String!) {
        // Remove the loading dialog
        self.dismissLoadingDialog()
        
        // Store something to show we presented a video
        self.presentingVideo = true
        self.dismissingVideo = false
        self.completedVideo = false
    }
    
    // Called after a rewarded video has been loaded from the Chartboost API
    // servers and cached locally.
    func didCacheRewardedVideo(_ location: String!) {
        //self.videoIsCached = true
    }
    
    /*
     * didCompleteRewardedVideo
     *
     * This is called when a rewarded video has been viewed
     *
     * Is fired on:
     * - Rewarded video completed view
     *
     */
    func didCompleteRewardedVideo(_ location: String!, withReward reward: Int32) {
        //NSLog("completed rewarded video view at location %@ with reward amount %d", location, reward);
        
        self.endVideoSuccessfully()
    }
    
    // Called after a rewarded video has attempted to load from the Chartboost API
    // servers but failed.
    /*func didFail(toLoadRewardedVideo location: String!, withError error: CBLoadError) {
        // Remove the loading dialog
        self.dismissLoadingDialog()
        
        if self.completedVideo == false && self.presentingVideo == true && !self.dismissingVideo {
            self.endVideoUnsuccessfully()
        }
    }*/
    
    // Called after a rewarded video has been dismissed.
    func didDismissRewardedVideo(_ location: String!) {
        // If video was completed, dont do anything, otherwise send dismiss dialog if not done
        if !self.completedVideo && self.presentingVideo && !self.dismissingVideo {
            self.endVideoUnsuccessfully()
        } else if !self.dismissingVideo && self.completedVideo {
            self.endVideoSuccessfully()
        }
    }
    
    // Called after a rewarded video has been closed.
    func didCloseRewardedVideo(_ location: String!) {
        // If video was completed, dont do anything, otherwise send dismiss dialog if not done
        if !self.completedVideo && self.presentingVideo && !self.dismissingVideo {
            self.endVideoUnsuccessfully()
        } else if !self.dismissingVideo && self.completedVideo {
            self.endVideoSuccessfully()
        }
    }
    
    // Called after a rewarded video has been clicked.
    func didClickRewardedVideo(_ location: String!) {
        // Store that the video was completed.
        if self.presentingVideo && !self.completedVideo {
            self.completedVideo = true
        }
    }
    
    private func dismissLoadingDialog() {
        // Send notification that gamescene will pick up
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissLoadingDialog"), object: nil)
    }
    
    private func endVideoSuccessfully() {
        // Send notification that gamescene will pick up
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RejuvenatePlayer"), object: nil)
        
        // Reset flags
        self.presentingVideo = false
        self.completedVideo = false
        self.dismissingVideo = true
    }
    
    private func endVideoUnsuccessfully() {
        // Send notification that the gamescene will pick up
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DontRejuvenatePlayer"), object: nil)
        
        // Reset flags
        self.presentingVideo = false
        self.completedVideo = false
        self.dismissingVideo = true
    }
    
    // Implement to be notified of when a video will be displayed on the screen for
    // a given CBLocation. You can then do things like mute effects and sounds.
    // func willDisplayVideo(location: String!) {}
    
    /*
    // ******************************** INTERSTITIAL ADS **********************
    // Called before requesting an interstitial via the Chartboost API server.
    //func shouldRequestInterstitial(location: String!) -> Bool {return true}
    
    // Called before an interstitial will be displayed on the screen.
    //func shouldDisplayInterstitial(location: String!) -> Bool {return true}
    
    // Called after an interstitial has been displayed on the screen.
    func didDisplayInterstitial(_ location: String!) {
        AdSupporter.sharedInstance.adReady = false
    }
    
    // Called after an interstitial has been loaded from the Chartboost API
    // servers and cached locally.
    func didCacheInterstitial(_ location: String!) {
        AdSupporter.sharedInstance.adReady = true
    }
    
    // Called after an interstitial has attempted to load from the Chartboost API
    // servers but failed.
    func didFail(toLoadInterstitial location: String!, withError error: CBLoadError) {
        // Move on to tutorials
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "ProgressPastInterstitialAd"), object: nil)
    }
    
    // Called after an interstitial has been dismissed.
    func didDismissInterstitial(_ location: String!) {
        // Move on to tutorials
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ProgressPastInterstitialAd"), object: nil)
    }
    
    // Called after an interstitial has been closed.
    //func didCloseInterstitial(location: String!) {}
    
    // Called after an interstitial has been clicked.
    func didClickInterstitial(_ location: String!) {
        AdSupporter.sharedInstance.showPauseMenu = true
    }
 */
}

