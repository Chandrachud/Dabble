//
//  DBLBidDetailViewController.swift
//  Dabble
//
//  Created by Reddy on 7/13/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLBidDetailViewController: UIViewController, DBLServicesResponsesDelegate,UIAlertViewDelegate,UIActionSheetDelegate
{

    @IBOutlet weak var bidValueLbl: UILabel!
    @IBOutlet weak var btnSendFeedback: UIButton!
    var bidDetails:NSDictionary = NSDictionary()
    var jobImage:UIImage = UIImage()
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var Server = DBLServices()
    var profilePicHolder = UIImage()
    
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var bottomMediaView: UIView!
    @IBOutlet weak var btnAcceptBid: UIButton!
    
    @IBOutlet var bidderImage: UIImageView!
    @IBOutlet var bidderName: UILabel!
    @IBOutlet var jobsCompleted: UILabel!
    
    @IBOutlet var bidValue: UILabel!
    @IBOutlet var bidComments: UITextView!

    @IBAction func acceptBidAction(sender: UIButton)
    {                
        let postParams: NSDictionary = ["bidId": bidDetails.valueForKey("bidId") as! Int]
        appDelegate.showLoadingView("")
        self.Server.processAcceptBid(postParams)
    }
    
    @IBAction func backToBidList(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if currentJob.isEvent == "1"
        {
            titleLbl.text = "Attendee Details"
        }
        else if currentJob.volunteersEnabled == true
        {
            titleLbl.text = "Volunteer Details"
        }
        else
        {
            titleLbl.text = "Bidder Details"
        }        
        
        println("After Sending Detailll bidDetails : \(bidDetails)")
        Utils.addCornerRadius(btnChat)
        Server.delegate = self
        if currentJob.sourceView == kSourceJobsCreated
        {
            self.btnAcceptBid.hidden = false
            if(bidDetails["status"] as! Int == kJobActive)
            {
                bottomMediaView.hidden = true
                btnAcceptBid.hidden = false
                bidComments.userInteractionEnabled = false
                Server.processGetClientTokenInfo()
            }
            else if(bidDetails["status"] as! Int == kJobAccepted)
            {
                bottomMediaView.hidden = false
                btnAcceptBid.hidden = true
            }
        }
        else
        {
            self.btnAcceptBid.hidden = true
        }
        
        Utils.addCornerRadius(btnAcceptBid)
        Utils.addCornerRadius(bidComments)
        Utils.addCornerRadius(bidderImage)
        
        // Do any additional setup after loading the view.        
        
        if(bidDetails.allKeys.count != 0)
        {
            let bidderID = bidDetails.valueForKey("bidderId") as? Int
            if bidderID == currentUser.userID
            {
                bidderImage.image = currentUser.profilePic
            }
            else
            {
                bidderImage.image = profilePicHolder
            }

            bidderName.text = bidDetails.objectForKey("bidderName") as? String
            bidValue.text = bidDetails.objectForKey("amount") as? String
            var comment = bidDetails.objectForKey("comment") as? String
            comment = comment!.stringByReplacingOccurrencesOfString(kNewLineChar, withString: "\n");
            println(comment)
            
            bidComments.text = comment
            let amount: String = (bidDetails.valueForKey("amount") as! NSNumber).stringValue
            println("Amount String:::::: \(amount)")
            
            var myStringArr = amount.componentsSeparatedByString(".")
            
            if(myStringArr.count >= 2)
            {
                var cents = (myStringArr [1] as NSString).integerValue
                
                let count = ((myStringArr[1] as String).characters).count
                
                if count < 2
                {
                    cents = cents * 10
                }
                
                bidValue.attributedText = Utils.getAttributedLabel((myStringArr [0] as NSString).integerValue, cents: cents , currency: bidDetails.valueForKey("currency") as! String)
            }
            else
            {
                bidValue.attributedText = Utils.getAttributedLabel(Int(amount)! , cents: 00, currency: bidDetails.valueForKey("currency") as! String)
            }
        }
        
        if currentJob.isEvent == "1" || currentJob.volunteersEnabled == true
        {
            bidValueLbl.hidden = true
            bidValue.hidden = true
        }
        
        if currentJob.sourceView == kSourceCreateJob
        {
            Server.processGetClientTokenInfo()
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if identifier == "SegueMessage"
//        {
//            return false
//        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {        
       if segue.identifier == "FeedbackViewSegue"
        {
//            let feedbackViewController =  segue.destinationViewController as! DBLFeedbackViewController
//            var bidderId = bidDetails["bidderId"] as! Int
//            feedbackViewController.bidderId = "\(bidderId)"
        }
       else if segue.identifier == "SegueMessage"
       {
            let messageController = segue.destinationViewController as! MessageController
            let receiver = bidDetails["bidderId"] as! Int
            let identifier = "\(receiver)"
            let chatOp = ChatOperations()
            let chat = chatOp.fetchChatWithIdentifier(identifier, isGroupedChat: false, groupChatId: bidDetails["bidderName"] as! String)
            messageController.chat = chat;
            println(chat)
        }
    }
    
    func bidAcceptSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                var alertMsg = "You have accepted the bid"
                if currentJob.isEvent == "1" || currentJob.volunteersEnabled == true
                {
                    alertMsg = "You have accepted the RSVP"
                }
                appDelegate.showToastMessage(kAppName, message: alertMsg)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else if statusCode == 201
            {
                self.subscriptionIsExpired()
            }
            else
            {
                alertMsg = responseDict["Message"] as! String
                if alertMsg.characters.count != 0
                {
                    UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                    return;
                }
            }
        }
    }
    
    func bidAcceptFailure(error: NSError)
    {
        appDelegate.showToastMessage(kAppName, message: error.description)
    }
    
    func  subscriptionIsExpired()
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchChatController()
    {
        //self.view.backgroundColor = UIColor.redColor()
//
//        
//        chatController.opponentImage = UIImage(named: "User")
//        chatController.title = currentJob.jobTitle
//        //let helloWorld = LGChatMessage(content: "Hello World!", sentBy: .User)
//        //        chatController.messages = [helloWorld]
//        chatController.delegate = self
//        currentJob.acceptedBidderId =  bidDetails.valueForKey("bidderId") as! Int
//        chatController.view.tag = kTagMovedFromDB // kTagMovedFromJD//
//        chatController.view.backgroundColor = UIColor.clearColor()
//        self.navigationController?.navigationBarHidden = false
    }

    @IBAction func showChatView(sender: UIButton)
    {
        println("Show show chat view")
        self.launchChatController()
        //        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
        //            {
        //                self.chatView.frame = CGRectMake(0, 120, self.chatView.frame.size.width, self.view.frame.size.height - 120)
        //            }, completion: { finished in
        //        })
    }

    @IBAction func callViaFaceTime(sender: UIButton)
    {
        //        if(iOS7)
        //        {
        //            self.showFacetimeActionSheet7()
        //        }
        //        if(iOS8)
        //        {
        //            self.showFacetimeActionSheet8()
        //        }
        
        //self.showFacetimeAlert()
        
        //Facetime-Video with MobileNo
        //self.facetimeWithMobileNumber("")//set mobile number
        
        //Facetime-Video with EmailID  roben
        //self.facetimeWithEmailID("rovenjain@gmail.com")//set EmailID
        
        //Facetime-Audio with MobileNo
        //self.facetimeAudioWithMobileNumber("9989897959")//set mobile number
        
        //Facetime-Audiowith EmailID
        //self.facetimeAudioWithEmailID("")//set EmailID
    }
    
    func showFacetimeActionSheet7()
    {
        
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: "Cancel", otherButtonTitles: "Email", "Phone Number")
        actionSheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
            
        case 0:
            println("\n \n  Cancel")
            break;
            
        case 1:
            println("\n \n Email")
            //Facetime-Video with EmailID
            self.facetimeWithEmailID("")//set EmailID
            
            break;
            
        case 2:
            println("\n \n Phone")
            //Facetime-Video with MobileNo
            self.facetimeWithMobileNumber("")//set mobile number
            break;
            
        default:
            break;
            
            
        }
    }
    func showFacetimeActionSheet8()
    {
        
        if #available(iOS 8.0, *) {
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        } else {
            // Fallback on earlier versions
        }
        
        
        if #available(iOS 8.0, *) {
            let emailAction = UIAlertAction(title: "Email", style: .Default, handler:
                {
                    (alert: UIAlertAction) -> Void in
                    println("\n \n to Email")
                    
                    //Facetime-Video with EmailID
                    self.facetimeWithEmailID("")//set EmailID
            })
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            let numberAction = UIAlertAction(title: "Phone Number", style: .Default, handler:
                {
                    (alert: UIAlertAction) -> Void in
                    println("\n \n to Mobile Number")
                    
                    //Facetime-Video with MobileNo
                    self.facetimeWithMobileNumber("")//set mobile number
            })
        } else {
            // Fallback on earlier versions
        }
        
        
        if #available(iOS 8.0, *) {
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
                {
                    (alert: UIAlertAction) -> Void in
                    println("\n \n Cancelled")
            })
        } else {
            // Fallback on earlier versions
        }
        
        
        
//        optionMenu.addAction(emailAction)
//        optionMenu.addAction(numberAction)
//        optionMenu.addAction(cancelAction)
//        
//        
//        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func phoneNumberValidation(value: String) -> Bool
    {
        let charcter  = NSCharacterSet(charactersInString: "0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  value == filtered
    }
    func showFacetimeAlert()
    {
        let passwordAlert : UIAlertView = UIAlertView(title: kAppName, message: "Please enter your facetime Email or Number", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        passwordAlert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.EmailAddress
        passwordAlert.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            println("\n\n Okay button pressed")
            var inputText:String = alertView.textFieldAtIndex(0)!.text!
            println("\n\n Okay button pressed::::\(inputText)")
            if !inputText.isEmpty
            {
                if !Utils.isValidEmail(inputText)
                {
                    
                    println("\n\n valid email")
                    //Facetime-Video with EmailID
                    self.facetimeWithEmailID(inputText)//set EmailID
                    
                }
                else if(phoneNumberValidation(inputText))
                {
                    if(inputText.characters.count == 10)
                    {
                        //Facetime-Video with MobileNo
                        self.facetimeWithMobileNumber(inputText)//set mobile number
                    }
                    else
                    {
                        showFacetimeAlert()
                        appDelegate.showToastMessage(kAppName, message: "Please enter valid Number")
                    }
                    
                }
                else
                {
                    showFacetimeAlert()
                    appDelegate.showToastMessage(kAppName, message: "Please enter valid EmailID or Number")
                }
                
            }
            else
            {
                showFacetimeAlert()
                appDelegate.showToastMessage(kAppName, message: "Please enter your facetime EmailID or Number")
            }
        }
    }
    func facetimeWithMobileNumber(phoneNumber:String)
    {
        
        if(phoneNumber != "")
        {
            println("\n\n facetimeWithMobileNumber::::phoneNumber::::\(phoneNumber)")
            
            if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)")
            {
                println("\n\n facetimeWithMobileNumber::::: facetimeURL::::\(facetimeURL)")
                let application:UIApplication = UIApplication.sharedApplication()
                
                if (application.canOpenURL(facetimeURL))
                {
                    
                    
                    
                    println("\n\n facetimeWithMobileNumber:::: Application can call facetime::::\(facetimeURL)")
                    application.openURL(facetimeURL);
                }
                else
                {
                    //Device doesnt have Facetime App
                    // appDelegate.showToastMessage(kAppName, message: "Sorry,device not having Facetime Application")
                    println("\n\n facetimeWithMobileNumber::: device not having facetime application")
                }
                
            }
            
            
        }
        else
        {
            
            // appDelegate.showToastMessage(kAppName, message: "Doesn't have facetime number")
            println("\n\n facetimeWithMobileNumber::: Doesn't have facetime number")
        }
        
    }
    
    func facetimeWithEmailID(emailID:String)
    {
        
        if(emailID != "")
        {
            println("\n\n facetimeWithEmailID::::emailID::::\(emailID)")
            
            if let facetimeURL:NSURL = NSURL(string: "facetime://\(emailID)")
            {
                println("\n\n facetimeWithEmailID::::: facetimeURL::::\(facetimeURL)")
                let application:UIApplication = UIApplication.sharedApplication()
                
                if (application.canOpenURL(facetimeURL))
                {
                    
                    
                    
                    println("\n\n facetimeWithEmailID:::: Application can call facetime::::\(facetimeURL)")
                    application.openURL(facetimeURL);
                }
                else
                {
                    //Device doesnt have Facetime App
                    // appDelegate.showToastMessage(kAppName, message: "Sorry,device not having Facetime Application")
                    println("\n\n facetimeWithEmailID::: device not having facetime application")
                }
                
            }
            
            
        }
        else
        {
            
            // appDelegate.showToastMessage(kAppName, message: "Doesn't have facetime Email")
            println("\n\n facetimeWithEmailID::: Doesn't have facetime Email")
        }
        
    }
    
    //    func facetimeAudioWithMobileNumber(phoneNumber:String)
    //    {
    //        println("\n\n facetimeAudioWithMobileNumber")
    //        if let facetimeURL:NSURL = NSURL(string: "facetime-audio://\(phoneNumber)")
    //        {
    //            println("\n\n facetimeAudioWithMobileNumber facetimeURL::::\(facetimeURL)")
    //            let application:UIApplication = UIApplication.sharedApplication()
    //
    //            if (application.canOpenURL(facetimeURL))
    //            {
    //                println("\n\n facetimeAudioWithMobileNumber ApplicationCanCall::::\(facetimeURL)")
    //                application.openURL(facetimeURL);
    //            }
    //        }
    //    }
    //
    //    func facetimeAudioWithEmailID(emailID:String)
    //    {
    //        println("\n\n facetimeAudioWithEmailID")
    //        if let facetimeURL:NSURL = NSURL(string: "facetime-audio://\(emailID)")
    //        {
    //            println("\n\n facetimeAudioWithEmailID facetimeURL::::\(facetimeURL)")
    //            let application:UIApplication = UIApplication.sharedApplication()
    //
    //            if (application.canOpenURL(facetimeURL))
    //            {
    //                println("\n\n facetimeAudioWithEmailID ApplicationCanCall::::\(facetimeURL)")
    //                application.openURL(facetimeURL);
    //            }
    //        }
    //    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
