//
//  DBLServices.swift
//  Dabble
//
//  Created by Reddy on 7/13/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

// Class for calling all backend services
import UIKit

// Declaring Enums for differentiating each Request/Response goes and comes from the server.

let KStatusSubscriptionExpired = 201

enum eRequestType
{
    case eRequestRegisterUser
    case eRequestFetchAccountData
    case eRequestForgotPassword
};

@objc protocol DBLServicesResponsesDelegate
{

    optional func userCreationSuccess(responseDict: AnyObject!)
    optional func userCreationFailure(error: NSError?)
    
    optional func sendNewPasswordSuccess(responseDict: AnyObject!)
    optional func sendNewPasswordFailed(error: NSError?)
    
    optional func loginSuccess(responseDict: AnyObject!)
    optional func loginFailed(error: NSError?)
    
    optional func loginWithFacebookSuccess(responseDict: AnyObject!)
    optional func loginWithFacebookFailure(error: NSError?)
    
    optional func addEmailSuccess(responseDict: AnyObject!)
    optional func addEmailFailure(error: NSError?)

    optional func removeEmailSuccess(responseDict: AnyObject!)
    optional func removeEmailFailure(error: NSError?)

    optional func updateUserSuccess(responseDict: AnyObject!)
    optional func updateUserFailure(error: NSError?)
    
    optional func verifyUserExistenceSuccess(responseDict: AnyObject!)
    optional func verifyUserExistenceFailure(error: NSError?)
    
    optional func profilePicFetchSuccess(responseDict: AnyObject!)
    optional func profilePicFetchFailure(error: NSError?)
    
    optional func userDetailFetchSuccess(responseDict: AnyObject!)
    optional func userDetailFetchFailure(error: NSError?)
    
    optional func createJobSuccess(responseDict: AnyObject!)
    optional func createJobFailure(error: NSError?)
    optional func createJobUploadMediaFailure(error: NSError?)
    
    optional func fetchAllJobsSuccess(responseDict: AnyObject!)
    optional func fetchAllJobsFailure(error: NSError?)
    
    optional func addFilesToJobSuccess(responseDict: AnyObject!)
    optional func addFilesToJobFailure(error: NSError?)
    
    optional func retractJobSuccess(responseDict: AnyObject!)
    optional func retractJobFailure(error: NSError?)
    
    optional func passwordVerificationSuccess(responseDict: AnyObject)
    optional func passwprdVerificationFailure(error: NSError)
    
    optional func getCategoriesSuccess(responseDict: AnyObject)
    optional func getCategoriesFailure(error: NSError)
    
    optional func imageDownloadSuccess(responseDict: AnyObject)
    optional func imageDownloadFailure(error: NSError)
    
    optional func fetchBidListSuccess(responseDict: AnyObject)
    optional func fetchBidListFailure(error: NSError)
    
    //Callbacks for Create Bid
    optional func bidCreateSuccess(responseDict: AnyObject!)
    optional func bidCreateFailure(error: NSError)
    
    //Callbacks for Accept Bid
    optional func bidAcceptSuccess(responseDict: AnyObject!)
    optional func bidAcceptFailure(error: NSError)
    
    //Callback for Retract Bid
    optional func bidRetractSuccess(responseDict: AnyObject!)
    optional func bidRetractFailure(error: NSError?)
    
    optional func paymentSuccess(responseDict: AnyObject!)
    optional func paymentFailure(error: NSError?)
    
    optional func fetchMyJobsSuccess(responseDict: AnyObject!)
    optional func fetchMyJobsFailure(error: NSError?)
    
    optional func fetchMyBidsSuccess(responseDict: AnyObject!)
    optional func fetchMyBidsFailure(error: NSError?)
    
    optional func fetchJobsAppliedByMeSuccess(responseDict: AnyObject!)
    optional func fetchJobsAppliedByMeFailure(error: NSError?)
    
    optional func writeFeedbackSuccess(responseDict: AnyObject!)
    optional func writeFeedbackFailure(error: NSError?)
    
    optional func registerDeviceForPushSuccess(responseDict: AnyObject!)
    optional func registerDeviceForPushFailure(error: NSError?)
    
    optional func sendTextSuccess(responseDict: AnyObject!)
    optional func sendTextFailure(error: NSError?)
    
    optional func editJobSuccess(responseDict: AnyObject!)
    optional func editJobFailure(error: NSError?)
    
    optional func fetchChatSuccess(responseDict: AnyObject!)
    optional func fetchChatFailure(error: NSError?)
    
    optional func removeResourceSuccess(responseDict: AnyObject!)
    optional func removeResourceFailure(error: NSError)
    
    optional func addResourceSuccess(responseDict: AnyObject!)
    optional func addResourceFailure(error: NSError)
    
    optional func fetchAvailableSubscriptionsSuccess(responseDict: AnyObject!)
    optional func fetchAvailableSubscriptionsFailure(error: NSError)
    
    optional func subscribingSuccess(responseDict: AnyObject!)
    optional func subscribingFailure(error: NSError)
    
    optional func attendingEventSuccess(responseDict: AnyObject!)
    optional func attendingEventFailure(error: NSError!)
    
    optional func fetchUserRegisteredCardsSuccess(responseDict: AnyObject)
    optional func fetchUserRegisteredCardsFailure(error: NSError!)
    
    optional func clientTokenGeneratedSuccessfully(responseDict: NSDictionary)
    optional func clientTokenGenerationFailed(error: NSError)
    
    optional func changePaymentCardSuccess(responseDict: NSDictionary)
    optional func changePaymentCardFailure(error: NSError)
    
    optional func registerCardSuccess(responseDict: NSDictionary)
    optional func registerCardFailure(error: NSError)
    
    optional func switchingSubscriptionSuccess(responseDict: NSDictionary)
    optional func switchingSubscriptionFailed(error: NSError)
    
    optional func subscriptionIsExpired()
}

protocol DBLServicesRequestDelegate
{
    func processCreateUser(postParams: NSDictionary!, profileFileURL :NSURL)
 
    func processForgotPassword(postParams: NSDictionary!)
    
    func processLogin(postParams : NSDictionary!)
    
    func processLoginWithFacebook(postParams: NSDictionary!)
    
    func processUpdateUser(postParams: NSDictionary?, imageData: NSData?)
    
    func processAddEmail(postParams : NSDictionary!)
    
    func processRemoveEmail(postParams : NSDictionary!)
    
    func processFetchProfilePic(postParams: NSDictionary!)
    
    func processFetchUserDetails(postParams: NSDictionary!)
    
    func processCreateJob(postParams: NSDictionary!, imageURLs: NSArray!, videoURLs:NSArray!)
    
    func processFetchAllJobs(postParams: NSDictionary!)
    
    func processFetchJobsByRange(postParams: NSDictionary!)
    
    func processFetchJobsByRangeAndCategories(postParams: NSDictionary!)
    
    func processAddFilesToJob(postParams: NSDictionary!)
    
    func processPasswordVerification(postParams: NSDictionary!)
    
    func processGetCategories(postParams: NSDictionary!)
    
    func processImageDownload(imageURL: NSString)
    
    func processCreateBid(postParams: NSDictionary)
    
    func processAttendForAnEvent(postParams: NSDictionary)
    
    func processAcceptBid(postParams: NSDictionary)
    
    func processRetractBid(postParams: NSDictionary)
    
    func processFetchBidList(postParams: NSDictionary)
    
    func processPayment(postParams: NSDictionary)
    
    func processFetchMyJobs()
    
    func processFetchJobsIApplied()
    
    func processWriteFeedback(postParams: NSDictionary)
    
    func processRetractJob(postParams:NSDictionary)
    
    func processRegisterDeviceForPush(postParams: NSDictionary)
    
    func processSendChat(postParams: NSDictionary)
    
    func processFetchChat(postParams:NSDictionary)
    
    func processSendFeedbackToPoster(postParams: NSDictionary)

    func processSendFeedbackToBidder(postParams: NSDictionary)
    
    func processEditJob(postParams: NSDictionary!, imageURLs: NSArray!, videoURLs:NSArray!)
    
    func processRemoveResource(postParams: NSDictionary)
    
    func processAddResource(postParams:NSDictionary, images: NSArray!)
    
    func processFetchAvailableSubscriptions(postParams: NSDictionary!)
    
    func processGetSubscribe(postParams: NSDictionary)
    
    func processFetchUserCards(postParams: NSDictionary)
    
    func processGetClientTokenInfo()
    
    func processRegisterCard(postParams: NSDictionary)

    func processSwitchSubscription(postParams: NSDictionary)
}

class DBLServices: NSObject , DBLServicesRequestDelegate
{
    var bidID: Int!
    var reach = Reach()
//    func successForDataCalled( data:NSData)
//    {
//        var docPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as! String
//        docPath = docPath.stringByAppendingPathComponent(String(format: "%ivideo%i", arguments: [currentUser.userID, 0]))
//        //
//        let fileUrl = NSURL(string: docPath)
//        
//        mediaData = data
//        
//    }
    var delegate:DBLServicesResponsesDelegate?
    
    func processCreateUser(postParams: NSDictionary!, profileFileURL :NSURL)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            postParams ,
            options: NSJSONWritingOptions(rawValue: 0))
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding) as! String
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
        
        requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        
//        var fileURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("JobDoneBy", ofType:"png")!)
        
        manager.POST( urlCreateAccount, parameters:postParams,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                 do {
                try data.appendPartWithFileURL(profileFileURL, name: "photo")
                }
                catch
                {
                    println("Exception to upload photo")
                }
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.userCreationSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.userCreationFailure!(error)
        })
    }
    
    func processUpdateUser(postParams: NSDictionary?, imageData:NSData?)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()        
        if postParams != nil
        {
            let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
                postParams! ,
                options: NSJSONWritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData!,
                encoding: NSASCIIStringEncoding) as! String
            manager.requestSerializer = requestSerializer
            requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
            requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        }
        
        let requestURL = String(format: urlUpdateUser, currentUser.userID)
        manager.POST( requestURL, parameters:postParams,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                if imageData != nil
                {
                    data.appendPartWithFileData(imageData!, name: "photo", fileName:"Photo", mimeType: "image/jpeg")
                }
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.updateUserSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.updateUserFailure!(error)
        })
    }
    
    func processAddAddress(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            postParams ,
            options: NSJSONWritingOptions(rawValue: 0))
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding) as! String
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        
        let requestURL = String(format: urlAddAddress, currentUser.userID)
        manager.POST( requestURL, parameters:postParams,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.updateUserSuccess!(responseObject)
//                appDelegate.showToastMessage("", message: "Address added successfully")
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.updateUserFailure!(error)
//                appDelegate.showToastMessage("", message: "Failed to add Address.")
        })
    }
    
    func processLogin(postParams :NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        manager.requestSerializer = requestSerializer
        
        var requestURL = ""
//        var FBAuthCode = postParams["FBAuthCode"] as! String
//
//        if (postParams.valueForKey(("FBAuthCode")) == nil)
//        {
            let email: String = postParams.valueForKey("login") as! String
            let password: String = postParams.valueForKey("password") as! String

            requestURL = String(format: urlLogin, arguments: [email,password])
//        requestURL = requestURL.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        }
//        else
//        {
//            requestURL = String(format: urlFBLogin , arguments: [FBAuthCode, currentUser.userID])
//        }        
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in

                appDelegate.hideLoadingView()
            self.delegate?.loginSuccess!(responseObject)
                
                println("Login Success: \(responseObject)")
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.loginFailed!(error)
                appDelegate.hideLoadingView()
        })
    }
    
    func processForgotPassword(postParams: NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        let email = postParams["email"] as! String
        let url = String(format:urlForgotPassword,email)
        println(url)
        manager.POST(url, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("Yes thies was a success \n  response is :\(responseObject)")
            appDelegate.hideLoadingView()
            self.delegate?.sendNewPasswordSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
            self.delegate?.sendNewPasswordFailed!(error)
        })
    }
    
    func processAddEmail(postParams : NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        let url = String(format:urlAddEmail, arguments:["1","dnreddy890@gmail.com"])
        
        manager.POST(url, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("Yes thies was a success \n  response is :\(responseObject)")
            appDelegate.hideLoadingView()
            self.delegate?.addEmailSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.addEmailFailure!(error)
        })
    }
    
    func processRemoveEmail(postParams : NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        let url = String(format:urlRemoveEmail, arguments:["1","dnreddy890@gmail.com"])
        
        manager.POST(url, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("Yes thies was a success \n  response is :\(responseObject)")
            appDelegate.hideLoadingView()
            self.delegate?.removeEmailSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.removeEmailFailure!(error)
        })
    }

    func processFetchProfilePic(postParams: NSDictionary!)
    {
//        if Utils.isNetworkReachable() != true
//        {
//            self.showNetworkError()
//            return
//        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFImageResponseSerializer()
        manager.responseSerializer = requestSerializer
        let userID: Int = postParams["userID"] as! Int
        
        let url = String(format:urlUserProfile , arguments:[userID])
        println(url)
        
        manager.GET(url, parameters:nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("Yes this was a success \n  response is :\(responseObject)")
               appDelegate.hideLoadingView()
            self.delegate?.profilePicFetchSuccess!(responseObject)
            },            
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.profilePicFetchFailure!(error)
        })
    }
    
    func processFetchUserDetails(postParams: NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        let userID: Int = postParams["userID"] as! Int
        
        let url = String(format:urlUserDetails , arguments:[userID])
        println("Requested URL: \(url)")
        manager.POST(url, parameters:nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
            self.delegate?.userDetailFetchSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.userDetailFetchFailure!(error)
        })
    }
    
    func processCreateJob(postParams: NSDictionary!, imageURLs: NSArray!, videoURLs:NSArray!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
       
        appDelegate.showLoadingView(nil)
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            postParams ,
            options: NSJSONWritingOptions(rawValue: 0))
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding) as! String
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
        requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        requestSerializer.setValue("", forHTTPHeaderField:"nonce") // TODO: Using fake-valid-nonce here.
//        requestSerializer.setValue("fake-valid-nonce" , forHTTPHeaderField:"nonce") // TODO: Using fake-valid-nonce here.
        let requestURL = String(format:urlCreateJob,currentUser.userID)
        manager.POST( requestURL, parameters:postParams,
            constructingBodyWithBlock:
            {
                (data: AFMultipartFormData!) in
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                println("processCreateJob success \n  response is :\(responseObj)")
                
                let responseObject = responseObj as! NSDictionary
                if responseObject["code"] as! Int == KStatusSubscriptionExpired
                {
                    appDelegate.hideLoadingView()
                    self.delegate?.subscriptionIsExpired!()
                    return
                }
                if responseObject["code"] as! Int == 0
                {
                    if(imageURLs.count != 0 || videoURLs.count != 0)
                    {
                        self.uploadFilesForJobID(responseObject["payload"] as! Int, imageURLs: imageURLs, videoURLs: videoURLs)
//                        appDelegate.showToastMessage(kAppName, message: "Failed to subscribe, please try again later.")
                    }
                    else
                    {
                        appDelegate.hideLoadingView()
                        self.delegate?.createJobSuccess!(responseObject)
                    }
                }
                else
                {
                    appDelegate.showToastMessage("Failure", message: responseObject["message"] as! String)
                    appDelegate.hideLoadingView()
                    return
                }
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("processCreateJob error here.. \(error.localizedDescription)")
                
                appDelegate.hideLoadingView()
                
                //self.delegate?.createJobSuccess!(error)
                self.delegate?.createJobFailure!(error)
        })
    }
    
    func uploadFilesForJobID(jobId: Int , imageURLs: NSArray, videoURLs: NSArray)
    {
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        
        let requestURL = String(format:urlAddFilesToJob, jobId, currentUser.userID)
        manager.POST( requestURL, parameters:nil,
            constructingBodyWithBlock:
            {
                (data: AFMultipartFormData!) in
                
                var resizedImage = UIImage()
                var mediaData = NSData()
                for (var i = 0 ; i < imageURLs.count ; i++)
                {
                    resizedImage = Utils.imageResize(imageURLs[i] as! UIImage, sizeChange: CGSizeMake(100, 100))
                    mediaData = UIImagePNGRepresentation(resizedImage)!
                    data.appendPartWithFileData(mediaData, name: "images", fileName: "images", mimeType: "image/jpeg")
                }
                for (var i = 0 ; i < videoURLs.count ; i++)
                {
                    // Logic if we send Video Data.
                    //------------
//                    data.appendPartWithFileData(videoURLs[i] as! NSData, name: "videos", fileName: "video", mimeType: "video/mp4")
                    //------------
                    
                    // Logic if we send paths.
                    //------------
                    let localVideoPath = (self.documentsDirectory() as NSString).stringByAppendingPathComponent("first.mp4")
                    
                    println(localVideoPath)
                    
//                    data.appendPartWithFileURL(NSURL(fileURLWithPath: localVideoPath), name: "videos", fileName: "video.mp4", mimeType: "video/mp4")
                    do
                    {
                        try data.appendPartWithFileURL(NSURL(fileURLWithPath: localVideoPath), name: "videos", fileName: "video.mp4", mimeType: "video/mp4")
                    
//                    data.appendPartWithFileURL(NSURL(fileURLWithPath:localVideoPath), name: "videos", fileName: "videos", mimeType: "video/mp4", error: &error)
                    }
                catch
                {
                    print("Exception occured")
                }
                    
//                    if error != nil
//                    {
//                        print(error)
//                    }
                    //------------
                }
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("uploadFilesForJobID success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                
               self.delegate?.createJobSuccess!(responseObject)
            },
            failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("uploadFilesForJobID error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                
                //self.delegate?.createJobSuccess!(error)
                self.delegate?.createJobUploadMediaFailure!(error)
        })
    }
    
    
    func getDataForURL(videoURLString: String) -> NSData
    {
        let uploadURL: NSURL = ObjcUtils.getFileUrlForURL(videoURLString)
        
        print("Local file path: \(uploadURL) \n \n \(uploadURL.absoluteString)")
        print("\(NSData.dataWithContentsOfMappedFile(uploadURL.absoluteString))")
        var videoData = NSData()
        
        if (NSFileManager.defaultManager().fileExistsAtPath(uploadURL.absoluteString) == true)
        {
            videoData = NSFileManager.defaultManager().contentsAtPath(uploadURL.absoluteString)!
        }
        print("Video data is : \n]n : \(videoData)")
        return videoData
    }
    
    func processFetchAllJobs(postParams: NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        print(postParams)
        appDelegate.showLoadingView(nil)
        
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        
        let userID = currentUser.userID
        let range = postParams["range"] as! Int
        var searchText = (postParams["searchText"] as? String)!

        if searchText.characters.count == 0
        {
            searchText = "null"
        }
        var timeZone:String = NSTimeZone.localTimeZone().abbreviation!
        timeZone = timeZone.substringToIndex(timeZone.startIndex.advancedBy(3))
        
        searchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let url = String(format:urlFetchJobsByRangeAndCategories, userID, range, searchText, timeZone)
        print(url)
        let lat = postParams["lat"] as! String
        let lng = postParams["lng"] as! String
        requestSerializer.setValue(lat , forHTTPHeaderField: "lat")
        requestSerializer.setValue(lng , forHTTPHeaderField: "lng")
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        println("Requested URL: \(url)")
        manager.POST(url, parameters:postParams,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            appDelegate.hideLoadingView()
            self.delegate?.fetchAllJobsSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchAllJobsFailure!(error)
        })
    }
    
    func processFetchJobsByRangeAndCategories(postParams: NSDictionary!)
    {
        
        self.processFetchAllJobs(postParams)
        
        return;
        
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        
        let userID = currentUser.userID
        let range = postParams["range"] as! Int
        let url = String(format:urlFetchJobsByRangeAndCategories, userID, range, (postParams["searchText"] as? String)!)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let lat = postParams["lat"] as! String
        let lng = postParams["lng"] as! String
        request.setValue(lat , forHTTPHeaderField: "lat")
        request.setValue(lng , forHTTPHeaderField: "lng")
        
        request.HTTPMethod = "POST"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:
            {
                (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                do
                {
            let jsonResult: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            if (jsonResult != nil)
            {
                appDelegate.hideLoadingView()
                 println(jsonResult)
                self.delegate?.fetchAllJobsSuccess!(jsonResult)
                }
                if(error != nil)
                {
                    appDelegate.hideLoadingView()
                    println("Failed::::\(error)")
                    self.delegate?.fetchAllJobsFailure!(error)
                }
                }
                catch
                {
                    print("Exception occured")
                }
        })
    }
    
    func processAddFilesToJob(postParams: NSDictionary!)
    {
        
//        let urlAddFilesToJob = "\(baseURL)/job/%i/add-files/user/%i/" // Job Id , UserID, Header(images, videos, audios)
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            postParams ,
            options: NSJSONWritingOptions(rawValue: 0))
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding) as! String
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
        
        requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        
        let fileURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("JobDoneBy", ofType:"png")!)
        
        let requestURL = "\(urlCreateJob)\(currentUser.userID)"
        manager.POST( requestURL, parameters:postParams,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                do {
                    try data.appendPartWithFileURL(fileURL, name: "photo")
                }
                catch
                {
                    print("Failed to upload photo")
                }
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.createJobSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.createJobSuccess!(error)
        })
    }
    
    func processPasswordVerification(postParams: NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        let newPassword = postParams["newPassword"] as! String
        
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        requestSerializer.setValue(newPassword, forHTTPHeaderField: "newPassword")
        
        let url = String(format:urlVerifyPassword , arguments:[postParams["email"] as! String,postParams["pin"] as! String])
        println("Requested URL: \(url)")
        manager.POST(url, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in

            print("Success: \(responseObject)")
            appDelegate.hideLoadingView()
            self.delegate?.passwordVerificationSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                self.delegate?.passwprdVerificationFailure!(error)
                appDelegate.hideLoadingView()
        })
    }
    
    func processGetCategories(postParams: NSDictionary!)
    {
//        if Utils.isNetworkReachable() != true
//        {
//            self.showNetworkError()
//            return
//        }
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        appDelegate.showLoadingView(nil)
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.GET(urlFetchCategories, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Success: \(responseObject)")
            appDelegate.hideLoadingView()
            self.delegate?.getCategoriesSuccess!(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.getCategoriesFailure!(error)
        })
    }
    
    // MARK - Errors
    //        if Utils.isNetworkReachable() != true
    //        {
    //            self.showNetworkError()
    //            return
    //        }
    
    func showNetworkError()
    {
        appDelegate.showToastMessage("Network Error", message: "Please check your internet connection and try again.")
//        UIAlertView(title: "Network Error", message: "Please check your internet connection and try again.", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func processLoginWithFacebook(postParams: NSDictionary!)
    {
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        appDelegate.showLoadingView(nil)
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
//        String(format: urlFBLogin, arguments:[postParams["authCode"] ,  postParams["userID"]] )
//        var requestURL = String
        
        let requestURL = String(format: urlFBLogin, arguments:[postParams["userID"] as! String])
        
        manager.POST(requestURL, parameters:postParams, success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in

            appDelegate.hideLoadingView()
                
            self.delegate?.loginWithFacebookSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                
                self.delegate?.loginWithFacebookFailure!(error)
        })
    }
    
    func processFetchJobsByRange(postParams: NSDictionary!)
    {
        
    }
    
    func processImageDownload(imageURL: NSString)
    {

        let manager = AFHTTPRequestOperationManager()
        let imageSerializer = AFImageResponseSerializer()
        manager.responseSerializer = imageSerializer
        
        manager.GET(imageURL as String, parameters:nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                self.delegate?.imageDownloadSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                self.delegate?.imageDownloadFailure!(error)
        })
    }
    
    func processAttendForAnEvent(postParams: NSDictionary)
    {
        println("processAttendForAnEvent\(postParams)")
        
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        requestSerializer.setValue(postParams["comment"] as! String, forHTTPHeaderField: "comment")
        requestSerializer.setValue(postParams["currency"] as! String, forHTTPHeaderField: "currency")
        requestSerializer.setValue(postParams["amount"] as! String, forHTTPHeaderField: "amount")
        
        let requestURL = String(format: urlCreateBid, arguments: [currentUser.userID, postParams["jobId"] as! Int ])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                appDelegate.hideLoadingView()
                let responseObject = responseObj as! NSDictionary
                if responseObject["code"] as! Int == KStatusSubscriptionExpired
                {
                    self.delegate?.subscriptionIsExpired!()
                    return
                }
                self.delegate?.attendingEventSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.attendingEventFailure!(error)
        })
    }

    
    func processCreateBid(postParams: NSDictionary)
    {
        println("processCreateBid\(postParams)")
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        requestSerializer.setValue(postParams["comment"] as! String, forHTTPHeaderField: "comment")
        requestSerializer.setValue(postParams["currency"] as! String, forHTTPHeaderField: "currency")
        requestSerializer.setValue(postParams["amount"] as! String, forHTTPHeaderField: "amount")
        
        let requestURL = String(format: urlCreateBid, arguments: [currentUser.userID, postParams["jobId"] as! Int ])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
   
                let responseObject = responseObj as! NSDictionary
                appDelegate.hideLoadingView()
                if responseObject["code"] as! Int == KStatusSubscriptionExpired
                {
                    self.delegate?.subscriptionIsExpired!()
                    return
                }
                self.delegate?.bidCreateSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.bidCreateFailure!(error)
        })
    }
    
    func processAcceptBid(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)        
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        requestSerializer.setValue("", forHTTPHeaderField: "nonce")
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlAcceptBid, arguments: [postParams["bidId"] as! Int , currentUser.userID ])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                let responseObject = responseObj as! NSDictionary
                appDelegate.hideLoadingView()
                if responseObject["code"] as! Int == KStatusSubscriptionExpired
                {
                    self.delegate?.subscriptionIsExpired!()
                    return
                }
                self.delegate?.bidAcceptSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.bidAcceptFailure!(error)
        })
    }
    
    func processRetractBid(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlRetractBid, arguments: [ postParams["bidId"] as! Int , currentUser.userID ])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.bidRetractSuccess!(responseObject)
                
                let allBids = currentJob.validBids as NSArray!
                let i = allBids.count
                var j = 0
                for j=0;j<i;j++
                {
                    let bidDict: NSDictionary = allBids.objectAtIndex(j) as! NSDictionary
                    if (bidDict["bidId"] as! Int == self.bidID)
                    {
                        currentJob.validBids.removeObjectAtIndex(j)
                        return

                    }
                }
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.bidRetractFailure!(error)
        })
    }
    
    func processPayment(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager(
        )
        
        let amount = String(format: "%f", arguments: [postParams["amount"] as! Float])
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        requestSerializer.setValue("4111111111111111", forHTTPHeaderField: "CardNumber")
        requestSerializer.setValue("12/2017", forHTTPHeaderField: "ExpiryDate")
        requestSerializer.setValue("0.0", forHTTPHeaderField: "amount")
        
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlAcceptBid, arguments: [postParams["bidId"] as! Int , currentUser.userID ])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
    
                appDelegate.hideLoadingView()
                self.delegate?.paymentSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.paymentFailure!(error)
        })
    }
    
    func processFetchBidList(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
//        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        manager.requestSerializer = requestSerializer
        

        let requestURL = String(format: urlFetchBidsForJob, arguments:[currentJob.jobId])
        println("Fetch Bids Request: \(requestURL)")
        manager.GET(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                self.delegate?.fetchBidListSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchBidListFailure!(error)
        })
    }
    
    func processFetchMyJobs()
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let requestURL = String(format: urlFetchMyJobs, arguments: [currentUser.userID])
        println("Login Request: \(requestURL)")
        manager.GET(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchMyJobsSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchMyJobsFailure!(error)
        })
    }

    func processFetchJobsIApplied()
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        
        let requestURL = String(format: urlFetchJobsIApplied, arguments: [currentUser.userID])
        println("Login Request: \(requestURL)")
        manager.GET(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchJobsAppliedByMeSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchJobsAppliedByMeFailure!(error)
        })
    }
    
    func processWriteFeedback(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        
        requestSerializer.setValue(postParams["comment"] as! String, forHTTPHeaderField: "comment")
        requestSerializer.setValue(postParams["commentee"] as! String, forHTTPHeaderField: "commentee")
        requestSerializer.setValue(postParams["rating"] as! String, forHTTPHeaderField: "rating")
        
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlPostFeedback, arguments: [postParams["jobId"] as! Int,currentUser.userID])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackFailure!(error)
        })
    }
    
    func processSendFeedbackToPoster(postParams: NSDictionary)
    {
        
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        let commentee = String(format: "%i", postParams["commentee"] as! Int)
        let comment = (postParams["comment"] as! String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        requestSerializer.setValue(comment, forHTTPHeaderField: "comment")
        requestSerializer.setValue(commentee, forHTTPHeaderField: "commentee")
        requestSerializer.setValue(postParams["rating"] as! String, forHTTPHeaderField: "rating")
        
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlSendFeedbackToPoster, arguments: [postParams["jobId"] as! Int,currentUser.userID])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("processSendFeedbackToPoster :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("processSendFeedbackToPoster failure \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackFailure!(error)
        })
    }

    func processSendFeedbackToBidder(postParams: NSDictionary)
    {
        
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        let commentee = String(format:"%i", postParams["commentee"] as! Int)
        let comment = (postParams["comment"] as! String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        requestSerializer.setValue(comment, forHTTPHeaderField: "comment")
        requestSerializer.setValue(commentee, forHTTPHeaderField: "commentee")
        requestSerializer.setValue(postParams["rating"] as! String, forHTTPHeaderField: "rating")
        
        manager.requestSerializer = requestSerializer
        
        let requestURL = String(format: urlSendFeedbackToBidder, arguments: [postParams["jobId"] as! Int,currentUser.userID])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.writeFeedbackFailure!(error)
        })
    }
    
    func processRetractJob(postParams:NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlRetractJob, arguments: [postParams["jobId"] as! Int,currentUser.userID])
        
        let params = ["reasonCode":1,"comment":"I am retracting."]
        
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: params,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.retractJobSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.retractJobFailure!(error)
        })
    }

    func processRegisterDeviceForPush(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        
        let requestURL = String(format: urlRegisterDeviceToken, arguments:[ currentUser.userID, postParams["deviceToken"] as! String , 1]) // 1 is iOS. 2 is Android
        println("Requested URL: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("RetractBid success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.registerDeviceForPushSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("RetractBid error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.registerDeviceForPushFailure!(error)
        })
    }

    func processSendChat(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        print(postParams)
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        requestSerializer.setValue(postParams["recipient"] as! String , forHTTPHeaderField:"recipient")
        requestSerializer.setValue(postParams["recipient"] as! String, forHTTPHeaderField:"message")
        
        let requestURL = String(format: urlSendChat, arguments:[ currentUser.userID])
        println("Requested URL: \(requestURL)")
        print("\n \n Chat Send params:::::::\(postParams)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("processSendChat success:\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.sendTextSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("processSendChat failure \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.sendTextFailure!(error)
        })
    }
    
    func processFetchChat(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlFetchChat, arguments:[ currentUser.userID, postParams["sender"] as! Int])
        
        println("Requested URL: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("processGetChat :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchChatSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("processGetChat fail \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchChatFailure!(error)
        })
    }
    
    //Method to Edit Job
    func processEditJob(postParams: NSDictionary!, imageURLs: NSArray!, videoURLs:NSArray!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            postParams ,
            options: NSJSONWritingOptions(rawValue: 0))
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding) as! String
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
        requestSerializer.setValue(theJSONText , forHTTPHeaderField:"payload")
        
        print(theJSONText)
        let requestURL = String(format:urlEditJob, currentJob.jobId, currentUser.userID)
        manager.POST( requestURL, parameters:postParams,
            constructingBodyWithBlock:
            {
                (data: AFMultipartFormData!) in
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("processCreateJob success \n  response is :\(responseObject)")
//                if(imageURLs.count != 0 || videoURLs.count != 0)
//                {
//                    self.uploadFilesForJobID(responseObject["payload"] as! Int, imageURLs: imageURLs, videoURLs: videoURLs)
//                    appDelegate.showToastMessage(kAppName, message: "Activity creaetd successfully, wait until images/videos uploaded.")
//                }
//                else
//                {
                    appDelegate.hideLoadingView()
                    self.delegate?.editJobSuccess!(responseObject)
//                }
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("processCreateJob error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()                
                self.delegate?.editJobFailure!(error)
        })
    }
    
    func processRemoveResource(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        manager.requestSerializer = requestSerializer
        
        var requestURL = ""
        let jobId: Int = postParams.valueForKey("jobId") as! Int
        let resourceId: String = postParams.valueForKey("resourceId") as! String
        
        requestURL = String(format: urlRemoveResource, arguments:[jobId, resourceId])
        println("Login Request: \(requestURL)")
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                appDelegate.hideLoadingView()
                self.delegate?.removeResourceSuccess!(responseObject)
                println("Login Success: \(responseObject)")
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.removeResourceFailure!(error)
                appDelegate.hideLoadingView()
        })
    }
    
    func processAddResource(postParams:NSDictionary, images: NSArray!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        
        let requestURL = String(format:urlAddFilesToJob, postParams["jobId"] as! Int, currentUser.userID)
        manager.POST( requestURL, parameters:nil,
            constructingBodyWithBlock:
            {
                (data: AFMultipartFormData!) in
                
                var resizedImage = UIImage()
                var mediaData = NSData()
                for (var i = 0 ; i < images.count ; i++)
                {
                    resizedImage = Utils.imageResize(images[i] as! UIImage, sizeChange: CGSizeMake(100, 100))
                    mediaData = UIImagePNGRepresentation(resizedImage)!
                    data.appendPartWithFileData(mediaData, name: "images", fileName: "images", mimeType: "image/jpeg")
                }
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("uploadFilesForJobID success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.addResourceSuccess!(responseObject)
            },
            failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("uploadFilesForJobID error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.addResourceFailure!(error)
        })
    }
        
    func processAddVideos(postParams:NSDictionary, videos: NSArray!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        
        let requestURL = String(format:urlAddFilesToJob, postParams["jobId"] as! Int, currentUser.userID)
        manager.POST( requestURL, parameters:nil,
            constructingBodyWithBlock:
            {
                (data: AFMultipartFormData!) in                            
                for (var i = 0 ; i < videos.count ; i++)
                {
                    data.appendPartWithFileData(videos[i] as! NSData, name: "videos", fileName: "video", mimeType: "video/mp4")
                }
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("uploadFilesForJobID success \n  response is :\(responseObject)")
                appDelegate.hideLoadingView()
                self.delegate?.addResourceSuccess!(responseObject)
            },
            failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("uploadFilesForJobID error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.addResourceFailure!(error)
        })
    }
    
    func processFetchAvailableSubscriptions(postParams: NSDictionary!)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlGetAvailableSubscriptions, currentUser.userTypeCode) // TODO: currentSubscription.userTypeCode.
        let requestSerializer = AFHTTPRequestSerializer()
        //        requestSerializer.setValue("application/json", forHTTPHeaderField:"contentType")
        manager.requestSerializer = requestSerializer
        
        manager.GET(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                print("processFetchAvailableSubscriptions: %@",responseObject)
                self.delegate?.fetchAvailableSubscriptionsSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchAvailableSubscriptionsFailure!(error)
        })
    }
    
    func processGetSubscribe(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)        
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlGetSubscribe, currentUser.userID,  postParams["subscriptionType"] as! Int, postParams["pid"] as! String)
        print(requestURL)
        let requestSerializer = AFHTTPRequestSerializer()
        
        manager.requestSerializer = requestSerializer
        manager.POST(requestURL, parameters: postParams,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                print(responseObject)
                self.delegate?.subscribingSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.subscribingFailure!(error)
        })
    }
    
    func processFetchUserCards(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlFetchUserCardsList, currentUser.userID)
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        manager.GET(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                self.delegate?.fetchUserRegisteredCardsSuccess!(responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.fetchUserRegisteredCardsFailure!(error)
        })
    }
    
    func processGetClientTokenInfo()
    {
        return;
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlGenerateClientToken, currentUser.userID)
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        manager.POST(requestURL, parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                appDelegate.hideLoadingView()
                let responseObject = responseObj as! NSDictionary
                if responseObject["code"] as! Int == 0
                {
                    
                }
//                self.delegate?.clientTokenGeneratedSuccessfully!(responseObject as! NSDictionary)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
//                self.delegate?.clientTokenGenerationFailed!(error)
        })
    }
    
    func processRegisterCard(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlRegisterCard, currentUser.userID)
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        manager.POST(requestURL, parameters: postParams,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                self.delegate?.registerCardSuccess!(responseObject as! NSDictionary)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.registerCardFailure!(error)
        })
    }
    
    func processSwitchSubscription(postParams: NSDictionary)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }
        appDelegate.showLoadingView(nil)
        let manager = AFHTTPRequestOperationManager()
        let requestURL = String(format: urlSwitchSubscription, currentUser.userID)
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        manager.POST(requestURL, parameters: postParams,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                appDelegate.hideLoadingView()
                self.delegate?.switchingSubscriptionSuccess!(responseObject as! NSDictionary)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
                self.delegate?.switchingSubscriptionFailed!(error)
        })
    }
    
    func documentsDirectory() -> String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentsPath as String
    }
}


