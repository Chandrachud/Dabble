//
//  Constants.swift
//  Dabble
//
//  Created by Reddy on 7/4/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import Foundation
import UIKit
let  kTagMovedFromJD = 1
let  kTagMovedFromDB = 2
let kTagMovedFromPush = 3

let kLoginID = "LoginEmailForAutoLogin"
let kLoginPassword = "LoginPasswordForAutoLogin"
let kLoginFacebookId = "FBUserIDForLogin"

//let kTempNonce = "fake-valid-nonce"
let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)

let kImagesShowcase = "Show Images Scroller for"

let kSourceJobsCreated = "JobsCreated"

let kSourceSearchJobs = "SearchJobs"

let kSourceCreateJob = "CreateJob"

let kSourceJobsApplied = "JobsApplied"

let kCustomLogin = "CustomLogin"
let kFacebookLogin = "FacebookLogin"

let kPersistCurrentUserData = "LatestUserDataForAutologin"
let kPersistUserId = "RecentUserId"

let YES = 1
let NO = 0

//let kFreeTrailSubscriptionID  = ((currentUser.userTypeCode == 1 ) ? 2:5)
//let kMonthlySubscriptionID =    ((currentUser.userTypeCode == 1 ) ? 3:6)
//let kPayAsYouGoSubscriptionID = ((currentUser.userTypeCode == 1 ) ? 4:7)

let defaultErrorMessage = "We were unable to process your request, if the issue persists please contact support@thedabbleapp.com" 

let kMonthlySubDescription = "Your membership will be renewed monthly and the charge will appear on your default credit/debit card associated with dabble. You can cancel automatic renewal at any time up to 24 hours before the renewal date by clicking the \"Pay as you Go\" button."

var kPayPerGoDescription = "$%.2f will be charged at every time you Post/Bid is accepted and $%.2f will be charged at every time you Post Event."

let kDesSwitchMonthly = "User can switch to \"Monthly Subscription\" at anytime and will be effecitive immideately."

let kDesSwitchPayAsYouGo = "User can switch to \"Pay as you Go Subscription\" at anytime but the new subscription option will only be effecitive post cycle ends."

let kUserID = "currentUserID"

let primaryColorOfApp = UIColor(red: 255.0/255.0, green: 122.0/255.0, blue: 1.0/255.0, alpha: 1.0)

let appBluecolor =  UIColor(red: 52.0/255.0, green: 182.0/255.0, blue: 255.0/255.0, alpha: 1.0)

let appGraycolor =  UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)

let kEventTitleColor = UIColor(red: 80.0/255.0, green: 144.0/255.0, blue: 190.0/255.0, alpha: 1.0)

let kJobTitleColor = UIColor(red: 251.0/255.0, green: 136.0/255.0, blue: 60.0/255.0, alpha: 1.0)

let appClearColor = UIColor.clearColor()

let appPrimaryColor = UIColor(red: 252.0/255.0, green: 161.0/255.0, blue: 104.0/255.0, alpha: 1.0)

let kCategotiesListViewTag = 1000  // Home Filter Categories listview Tag

let kAppFont = UIFont(name: "HelveticaNeue-Light", size: 14.0)

let kAppRegularFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)

let kJobCreatedNotification = "NewJobCreated"
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

//let googleMapsApiKey = "AIzaSyAuxbzLnRgqpjh1Q9a8w4YaoZtNkp5o6uo"  // Old with com.dabble.saxonglobal.com

//let googleMapsApiKey = "AIzaSyDASd39PqGt1xeiljciOSLr5sGh7-hnC24" // From com.djbn.dabble from adn.reddy@saxonglobal.com
//
//let goolgeMapsServerKey = "AIzaSyAlB3DbMZLt4-Np8__-hc-gadTNaBruzSM" // From com.djbn.dabble from adn.reddy@saxonglobal.com

// Google Maps Keys
let googleMapsApiKey = "AIzaSyB6tCs9z6wk2QJIlgZr2y4L__a1wKtCugU" // From com.djbn.dabble from client's google account.
let goolgeMapsServerKey = "AIzaSyBKHzKGF84Tp0qxcY3fp4hyLTNWY5yZqhI" // from clients google account

// Facebook Keys
let kFacebookProdAppID = "643115522497035"  // Generated from Client's facebook account
let kFacebookProdSecretKey = "dbc4f1b46e9c6508a61c39c3fd60a1cf"

let americanStates = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

//***** OLD Key//"AIzaSyAkJti3IIaQv5v-jBriLLNGDG_3vCZjX6w"
//***** NEW Key//"AIzaSyALdC_k1lw2L9YbIpumcKquzrU1Ga9D4jo" ///Rohit
// AIzaSyAuxbzLnRgqpjh1Q9a8w4YaoZtNkp5o6uo


let kAppName = "Dabble"
let kSuccess = "SUCCESS"
let kMessage = "message"
let kPayload = "payload"

let statusMessageFor400 = "Bad Request, please provide proper inputs and try again."
let statusMessageFor404 = "Service not found."
let statusMessageFor500 = "We were unable to process your request, if the issue persists please contact support@thedabbleapp.com"// "Internal Server Error."
let statusMessageFor503 = "We were unable to process your request, if the issue persists please contact support@thedabbleapp.com"

let statusMessageFor0 = "" // Keep this as empty, its for success.
let statusMessageFor2   = "Duplicate Request."   // DUPLICATE REQUEST
let statusMessageFor101 = "Invalid Username or Password." // Incomeplete Data
let statusMessageFor102 = "The email you have provided is already in use, please double check the spelling or add a different email" // UNAUTHERISED ACCESS
let statusMessageFor103 = "Verify your email by clicking the link in the confirmation email prior to logging in" // INACTIVE
let statusMessageFor104 = "User is unavailable." // Unavailable
let statusMessageFor105 = "Authentication Failed. Please check your credentials." // Incorrect PIN
let statusMessageFor106 = "This email id is already exist, please use another email id." // User already exist
let statusMessageFor107 = "This email is not on file. Are you new to Dabble? Create an account to begin" // Authentication Failed
let statusMessageFor108 = statusMessageFor106 // Authentication Failed

let kNewLineChar = "NewLineChar"

// MARK: URLs

//let baseURL = "http://192.168.20.84:8080/dabble/"

// let kFacebookAppID = 661117170698632 // Created from Devendranath890@gmail.com : Facebook2com

// let kFacebookSercreKey = 96b84d07f80b47a4b889f5465faa4f48 // Created from Devendranath890@gmail.com : Facebook2com
/*

GoogleMaps API Key information

API key:            AIzaSyAkJti3IIaQv5v-jBriLLNGDG_3vCZjX6w

iOS applications    com.dabble.saxonglobal

Activation date:    Jul 16, 2015, 10:50:00 AM
Activated by        saxonglobal2000@gmail.com (you)

*/


// Image and Video Pickers

// i) CTAssetsDemo
// ii) ELCImagePickerController








