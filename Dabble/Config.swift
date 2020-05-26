//
//  Config.swift
//  Dabble
//
//  Created by Reddy on 01/08/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import Foundation

// Local Sesrver
//let baseURL = "http://192.168.20.180:8080/dabble/rest/v0/service"

// Cloud Server// Dabble
//let baseURL = "http://104.197.91.16/dabble/rest/v0/service"
//let urlFaqRequest = "http://104.197.91.16/dabble/faq.jsp/"

//var baseURL: String!

//intigration 
//var baseURL = "http://104.197.91.16/int/rest/v0/service"
var baseURL = "http://52.36.94.208/dabble/rest/v0/service"

let urlFaqRequest = "http://104.197.91.16/int/faq.jsp"
let chatURL = "http://104.197.91.16:3000"

// Dev
//var baseURL = "http://104.197.91.16/dev/rest/v0/service"
//let urlFaqRequest = "http://104.197.91.16/dev/faq.jsp"


//Temp
//var baseURL = "http://192.168.1.4:8080/dabble/rest/v0/service"


let urlCreateAccount = "\(baseURL)/user/create/"

let urlForgotPassword = "\(baseURL)/user/forgot-password/email/%@/" // Inputs: email

let urlLogin = "\(baseURL)/user/authenticate/login/%@/password/%@/" // Inputs: email and Password

///id/usersfacebookid/fbuserID/authcode/authcodeNumber

let urlFBLogin = "\(baseURL)/user/facebook-authenticate/id/%@/" // Pass String and Int

let urlAddEmail = "\(baseURL)userId/%i/email/%@/add" // input user id and email

let urlRemoveEmail = "\(baseURL)/user/email/userId/%i/email/%@/remove" //inputs : userID and email

let urlUpdateUser = "\(baseURL)/user/update/%i/" // inputs : userID

let urlAddAddress = "\(baseURL)/user/add-address/user/%i/" // inputs : userID

let urlUserProfile = "\(baseURL)/user/profile-image/%i/"   // User id as input

let urlUserDetails = "\(baseURL)/user/details/%i/" // Pas User ID

let urlCreateJob = "\(baseURL)/job/user/%i/create/" // UserID

let urlFetchAllJobs = "\(baseURL)/job/all/user/%i/" // UserID, header(lat and long)

let urlAddFilesToJob = "\(baseURL)/job/%i/add-files/user/%i/" // Job Id , UserID, Header(images, videos, audios)

let urlVerifyPassword = "\(baseURL)/user/forgot-password/verify/email/%@/pin/%@/"

let urlFetchCategories = "\(baseURL)/job/categories/"

let urlFetchJobsByRangeAndCategories = "\(baseURL)/job/list/user/%i/range/%i/q/%@/timezone/%@/"

let urlRetractJob = "\(baseURL)/job/%i/user/%i/retract/" // jobId, userId , header(reasonCode , comment)

let urlFetchBidList = "\(baseURL)/bid/user/%i/job/%i/create/"  // Inputs: UserID and Job ID

let urlCreateBid = "\(baseURL)/bid/user/%i/job/%i/create/"  // Inputs: UserID and Job ID

let urlAcceptBid = "\(baseURL)/bid/%i/user/%i/accept/"    // Inputs: Bid Id and User ID

let urlRetractBid = "\(baseURL)/bid/%i/user/%i/retract/"  // Inputs: Bid Id and User ID

let urlPayment = "\(baseURL)/payment/user/%i/job/%i/amount/%f/currency/%@/sale/" // userID, JobID, Amount, Currency

let urlFetchMyJobs = "\(baseURL)/job/my-jobs/user/%i/"  // UserID

let urlFetchJobsIApplied = "\(baseURL)/bid/my-bids/user/%i/"        // UserID

let urlPostFeedback = "\(baseURL)/job/%i/userId/%i/feedback/"  // JobID, UserID

let urlRegisterDeviceToken = "\(baseURL)/user/%i/add-ios-device/device/%@/device/%i/"  // JobID, UserID

let urlSendChat = "\(baseURL)/chat/send/user/%i/" // UserID

let urlGetChat = "\(baseURL)/chat/get/user/%i/token/%@/" // UserID, token string

let urlPreAuthorizeUrl = "\(baseURL)/bid/%i/user/%i/pre-authorize/" // UserID, token string

let urlFetchBidsForJob = "\(baseURL)/bid/forJob/%i/" //JobId

let urlGetResource = "\(baseURL)/job/%i/resource/%@/"

let urlSendFeedbackToPoster = "\(baseURL)/job/%i/userId/%i/feedback-bidder/"  //  jobId, UserID

let urlSendFeedbackToBidder = "\(baseURL)/job/%i/userId/%i/feedback-seller/"  //  jobId, UserID

let urlEditJob = "\(baseURL)/job/%i/user/%i/edit/"

let urlFetchChat = "\(baseURL)/chat/get/user/%i/token/0/sender/%i/" // UserID , Sender ID

let urlRemoveResource = "\(baseURL)/job/%i/resource/%@/remove/"

let urlGetAvailableSubscriptions = "\(baseURL)/user/subscriptions/by-type/%i/" // 1 or 2

let urlGetSubscribe = "\(baseURL)/user/%i/subscription/%i/subscribe/using/pi/%@/" // userID and Subscription ID, paymentInstrumentId

let urlFetchUserCardsList = "\(baseURL)/payment/user/%i/cards/" // UserID

let urlGenerateClientToken = "\(baseURL)/payment/user/%i/generate-token/"

let urlRegisterCard = "\(baseURL)/payment/user/%i/change-payment-instrument/" // UserID

let urlSwitchSubscription = "\(baseURL)/payment/user/%i/change-payment-instrument/" // UserID //TODO; Change url

let urlAgreement = "\(baseURL)/user/agreement"

