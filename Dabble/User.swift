//
//  User.swift
//  Dabble
//
//  Created by Reddy on 7/17/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class User: NSObject
{
    var aboutMe: String?
    
    var addressLine1: String!
    var addressLine2: String!
     var city: String!
    var state: String!
    var country: String = "United States"
    var zipcode: Int!
    var age: Int!
    var authCode: Int!
    var dob: Int!
    var emailID: String!
    var firstName: String!
    var midddleName: String!
    var lastName: String!
    var gender: Int! // 0: Male, 1: Female, 2: Other
    var password: String!
    var phone: String? = ""
    var photoURL: String!
    var userID = 0
    var NoOfJobsCreaetd: Int!
    var profilePic: UIImage!
    var NoOfApplied: Int!
    var userTypeCode: Int!
    var timezone: String!

    func saveUserDetail(userInfoDict: NSDictionary)
    {
        let addressDetails: NSDictionary!
        let subscriptionDetails: NSDictionary?
        
        var userDetail: NSDictionary? = userInfoDict["user"] as? NSDictionary
        if userDetail == nil
        {
            userDetail = userInfoDict
        }
        else
        {
//            userDetail = userInfoDict
        }

        print(userInfoDict)
        print(userDetail)
        addressDetails = userDetail?["address"] as? NSDictionary
        subscriptionDetails = userDetail?["subscription"] as? NSDictionary
        
        if subscriptionDetails != nil
        {
            currentSubscription!.saveSubscriptionData(subscriptionDetails!)
        }
        
        aboutMe = userDetail?["aboutMe"] as? String
        addressLine1 = addressDetails["addressLine1"] as? String
        addressLine2 = addressDetails["addressLine2"] as? String
        
        city = addressDetails["city"] as? String
        state = addressDetails["state"] as? String
        country = (addressDetails["country"] as? String)!
        
        zipcode = addressDetails["zip"] as? Int
        firstName = userDetail?["firstName"] as? String
        midddleName = userDetail?["middleName"] as? String
        
        lastName = userDetail?["lastName"] as? String
        age = userDetail?["age"] as? Int
        dob = userDetail?["dob"] as? Int
        
        gender = userDetail?["gender"] as? Int
        emailID = userDetail?["email"] as? String
        
        phone = userDetail?["phone"] as? String
        userID = userDetail?["userId"] as! Int
        photoURL = userDetail?["photoUrl"] as? String
        userTypeCode  = userDetail?["userTypeCode"] as! Int
        self.saveCurrentUserInfo(userDetail!)
        timezone = userDetail?["timezone"] as? String
//        self.updateUserInfo()
    }
    
    func saveCurrentUserInfo(userDetail: NSDictionary)
    {
//        let savingDetails: NSDictionary = ["userObject" : currentUser]
        let userData = NSKeyedArchiver.archivedDataWithRootObject(userDetail)
        NSUserDefaults.standardUserDefaults().setObject(userData, forKey: kPersistCurrentUserData)
        NSUserDefaults.standardUserDefaults().setInteger(userID, forKey: kPersistUserId)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func updateUserInfo()
    {
//        let realm = RLMRealm.defaultRealm()
//        let list = User.allObjects()
//        if list.count != 0
//        {
//            realm.deleteAllObjects()
//        }
//        
//        realm.beginWriteTransaction()
//        realm.addObject(currentUser)
//        realm.commitWriteTransaction()
//        NSUserDefaults.standardUserDefaults().setInteger(userID, forKey: kPersistUserId)        
    }
}

var currentUser: User! = User()

class Dashboard: NSObject
{
    var jobsBidAndCompleted = 0
    var jobsBidAndInProgress = 0
    var jobsBidFor = 0
    var jobsCreated = 0
    var jobsCreatedAndCompleted = 0
    var jobsCreatedInProgress = 0
    var jobsWon = 0
    var userRating: Float = 0.0
    func saveDashboardData(dbDict: NSDictionary)
    {
        jobsBidAndCompleted = dbDict["jobsBidAndCompleted"] as! Int
        jobsBidAndInProgress = dbDict["jobsBidAndInProgress"] as! Int
        jobsBidFor = dbDict["jobsBidFor"] as! Int
        jobsCreated = dbDict["jobsCreated"] as! Int
        jobsCreatedAndCompleted = dbDict["jobsCreatedAndCompleted"] as! Int
        jobsCreatedInProgress = dbDict["jobsCreatedInProgress"] as! Int
        jobsWon = dbDict["jobsWon"] as! Int
        userRating = dbDict["userRating"] as! Float
    }
}

var DBManager: Dashboard! = Dashboard()


//Constants related to Users.

let kUserTypeIndividual = 1
let kUserTypeOrganization = 2

class Subscription: NSObject
{
    var amountForCreateEvent = 0.0
    var amountForCreateJob = 0.0
    var amount = 0.0
    var monthlyTier = 0
    var freeTier: Int!
    var payAsYouGoTier = 0
    var bidderExcempt: Int!
    var subDescription: String!
    var durationInDays: Int!
    var maxBidCount: Int!
    var maxJobCount: Int!
    var name: String!
    var status: Int!
    var subscriptionId: Int!
    var userTypeCode: Int!
    
    func saveSubscriptionData(sDict: NSDictionary)
    {
        amountForCreateEvent = sDict["amountForCreateEvent"] as! Double
        amountForCreateJob = sDict["amountForCreateJob"] as! Double
        amount = sDict["amountForSubscription"] as! Double
        bidderExcempt = sDict["bidderExcempt"] as! Int
        subDescription = sDict["description"] as! String
        durationInDays = sDict["durationInDays"] as! Int
        monthlyTier = sDict["monthlyTier"] as! Int
        payAsYouGoTier = sDict["payAsYouGoTier"] as! Int
        
        freeTier = sDict["freeTier"] as! Int
        if sDict["maxBidCount"] != nil
        {
            maxBidCount = sDict["maxBidCount"] as? Int
        }
        if sDict["maxJobCount"] != nil
        {
            maxJobCount = sDict["maxJobCount"] as? Int
        }
        name = sDict["name"] as! String
        subscriptionId = sDict["subscriptionId"] as! Int
        userTypeCode = sDict["userTypeCode"] as! Int        
    }
    
    func destroy()
    {
        currentSubscription = nil
    }
}

var currentSubscription: Subscription? = Subscription()



