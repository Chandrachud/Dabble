//
//  MainViewController.swift
//  Dabble
//
//  Created by Reddy on 7/4/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class MainViewController: AMSlideMenuMainViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //661117170698632 
    override func segueIdentifierForIndexPathInLeftMenu(indexPath: NSIndexPath!) -> String!
    {
        switch (indexPath.row)
        {
        case 0:
            return "LandingPageSegue"
        case 1:
            return "DashboardSegue"
        case 2:
            return "MyProfileSegue"
        case 3:
            return "ChatViewSegue"
            if currentSubscription!.freeTier == YES // TODO
            {
                return "SubscriptionsViewSegue"
            }
            else
            {
                return "MySubscriptionsSegue"
            }
        case 4:
            return "FAQViewSegue"//            return "ChatViewSegue"
            return "ChatViewSegue"
//        case 5:            
//            return "FAQViewSegue"//            return "ChatViewSegue"
        default :
            currentUser.userID = 0
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("TIDLogintype")
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("TIDUsername")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("TIDPassword")
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("FBUserID")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("FBAuthCode")
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kPersistCurrentUserData)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kPersistUserId)

            // Used for auto Login
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kLoginID)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kLoginPassword)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kLoginFacebookId)
            
            NSUserDefaults.standardUserDefaults().synchronize()
            currentUser.profilePic = UIImage(named: "avatar")
            
            print(currentUser.userID)
            
            currentSubscription = nil;
            currentJob = nil;
            DBManager = nil;
            currentUser = nil;            
            
            self.cancelAllRequests()
            
            // Cleaning Chat
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            realm.commitWriteTransaction()
            appDelegate.chatUpdateDelegate = nil
//          
            if (appDelegate.socket != nil && appDelegate.socket.status == SocketIOClientStatus.Connected)
            {
                appDelegate.socket.close()
            }
            return "LandingPageSegue"
        }
    }
    
    func cleanSingletons()
    {
        print(currentSubscription)
        currentSubscription?.destroy()
        print(currentSubscription)
    }
    
    func cancelAllRequests()
    {
        let manager = AFHTTPRequestOperationManager()
        manager.operationQueue.cancelAllOperations()
    }
}
