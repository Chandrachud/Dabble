//
//  JobDetailViewController.swift
//  Dabble
//
//  Created by Reddy on 6/30/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit


let kJobActive = 0
let kJobInactive = 1
let  kJobPending = 2
let kJobRetracted = 3
let kJobAccepted = 4
let kJobCompleted = 5
let kJobRetractVerificationPending = 6
let kJobPendingApproval = 9

class DBLJobDetailViewController: UIViewController,UITextFieldDelegate, DBLServicesResponsesDelegate, UIAlertViewDelegate,UIActionSheetDelegate, DatabackDelegateTwo, UITextViewDelegate
{
    var loaddView: UIView = UIView()
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var btnCompleteJob: UIButton!
    @IBOutlet weak var jobTimingsHolder: UIView!
    @IBOutlet weak var btnAddBid: UIButton!
    var isEditingMode = false
    //var jobDetails:NSDictionary = NSDictionary()
    var distanceinMil:String = String()
    var jobImage:UIImage = UIImage()
    var shouldDownloadImage: Bool!
    var numberofBidsount:NSArray = NSArray()
    var numberOfValidBids:NSMutableArray = NSMutableArray()
    @IBOutlet weak var mapViewHolder: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnJobStartDate: UIButton!
    @IBOutlet weak var btnJobEndDate: UIButton!
    
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var bottomMediaView: UIView!
    
    @IBOutlet var jobDetailScrollView: UIScrollView!
    @IBOutlet var scrollItemHolder: UIView!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var posterName: UILabel!
    @IBOutlet var posterdistance: UIButton!
    @IBOutlet weak var btnBids: UIButton!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet var jobDistanceLbl: UILabel!
    @IBOutlet var jobLocationBtn: UIButton!
    
    @IBOutlet weak var btnPickVideos: UIButton!
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var jobPostDate: UILabel!
    
    @IBOutlet var jobEstimatedCost: UILabel!
    @IBOutlet weak var mediaView: UIView!
    
    @IBOutlet var bidsCount: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet var jobDescription: UITextView!
    
    @IBOutlet var chatScrollerView: UIScrollView!
    @IBOutlet var scrollItemsHolder: UIView!
    
    @IBOutlet weak var noOfPeopleRequiredLbl: UILabel!
    @IBOutlet var chatField: UITextField!
    @IBOutlet var chatSendBtn: UIButton!
    
    var inputAccView:UIView = UIView()
    var activeField: UITextField = UITextField()
    
    var Server = DBLServices()
    
    @IBOutlet weak var btnPickImages: UIButton!
    @IBOutlet weak var btnEmailNotify: UIButton!
    @IBOutlet weak var btnAppChat: UIButton!
    
    @IBAction func addBidAction(sender: UIButton)
    {
        if sender.titleForState(UIControlState.Normal) == "Volunteer"
        {
            self.processAttendEvent(nil)
        }
    }
    
    @IBAction func pickImages(sender: AnyObject)
    {
        
    }
    
    @IBAction func pickVideos(sender: AnyObject)
    {
        
    }
    
    @IBAction func appChatAction(sender: UIButton)
    {
        activeField.resignFirstResponder()
        if sender.selected == true
        {
            sender.selected = false
        }
        else
        {
            sender.selected = true
        }
    }
    
    @IBAction func emailNotifAction(sender: UIButton)
    {
        activeField.resignFirstResponder()
        if sender.selected == true
        {
            sender.selected = false
        }
        else
        {
            sender.selected = true
        }
    }
    
    @IBAction func editJobAction(sender: UIButton)
    {
        if (sender.titleForState(UIControlState.Normal) == "SAVE")
        {
            jobDescription.resignFirstResponder()
            var jobStartDate: String = self.btnJobStartDate.titleForState(UIControlState.Normal)!
            var jobEndDate: String = self.btnJobEndDate.titleForState(UIControlState.Normal)!
            
            jobStartDate = Utils.getSupportFormattedDate(jobStartDate)
            jobEndDate = Utils.getSupportFormattedDate(jobEndDate)

            let isEvent:Bool = ((currentJob.isEvent) != nil) ? true : false
            let postParams = [
                "jobTitle": currentJob.jobTitle,
                "description": jobDescription.text,
                "lat": currentJob.lat,
                "lng": currentJob.lng,
                "isEvent" : isEvent,
                "event" : isEvent,
                "amount": currentJob.amount,
                "currency": "USD",
//                "startDate": currentJob.startDate, // TODO:
//                "endDate": jobEndDate,
                "volunteers": currentJob.volunteersEnabled,
                "noOfVolunteers": currentJob.noOfVolunteers,
                "emailCommunication": btnEmailNotify.selected,
                "chatCommunication": btnAppChat.selected
            ]
            println(postParams)
            Server.processEditJob(postParams, imageURLs: nil, videoURLs: nil)
            return
        }
        if sender.titleForState(UIControlState.Normal) != "EDIT"
        {
            sender.setTitle("EDIT", forState: UIControlState.Normal)
            self.setInteraction(false)
        }
        else
        {
            sender.setTitle("SAVE", forState: UIControlState.Normal)
            self.setInteraction(true)
            isEditingMode = true
        }
    }
    
    func editJobSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        
        println(responseDict)
        appDelegate.showToastMessage(kAppName, message: "Your job was successfully updated!")
        
        if(responseDict.count != 0)
        {
            println("createJobSuccess \(responseDict)")
            
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                currentJob.isEdited = YES
                appDelegate.showToastMessage(kAppName, message: "Job updated successfully.")
                isEditingMode = false
                editButton.setTitle("EDIT", forState: UIControlState.Normal)
                self.setInteraction(false)
                currentJob.saveJob(responseDict["payload"] as! NSDictionary)
                self.populateJobDetails()
                return
            }
            else
            {
                alertMsg = responseDict["message"] as! String
                if alertMsg.characters.count != 0
                {
                    UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                    return;
                }
            }
            
            switch (statusCode)
            {
            case 0:
                println("Success")
                appDelegate.showToastMessage(kAppName, message: "Activity posted successfully.")
                self.navigationController?.popViewControllerAnimated(true)
                //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                //            let paymentView = storyBoard.instantiateViewControllerWithIdentifier("PaymentView") as! DBLPaymentViewController
                //            self.navigationController?.pushViewController(paymentView, animated: true)
                
                NSNotificationCenter.defaultCenter().postNotificationName(kJobCreatedNotification, object: nil)
            case 500:
                alertMsg = responseDict["message"] as! String
                break
            case 100:
                alertMsg = responseDict["message"] as! String
                break
            case 101:
                alertMsg = responseDict["message"] as! String
                break
                
            case 102:
                alertMsg = responseDict["message"] as! String
                break
            case 103:
                alertMsg = responseDict["message"] as! String
                break
            case 104:
                alertMsg = responseDict["message"] as! String
                break
                
            case 105:
                alertMsg = responseDict["message"] as! String
                break
                
            case 106:
                alertMsg = responseDict["message"] as! String
                break
                
            case 107:
                alertMsg = responseDict["message"] as! String
                break
                
            default:
                alertMsg = defaultErrorMessage
                println("Default Case ")
            }
            
            if alertMsg.characters.count != 0
            {
                UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                return;
            }
        }
    }
    
    func editJobFailure(error: NSError?)
    {
        println(error?.localizedDescription)
        appDelegate.showToastMessage(kAppName, message: "Failed to updated job.")
    }
    
    func populateJobDetails()
    {
        posterName.text = currentJob.posterName
        jobEstimatedCost.text = "Estimated cost: \(currentJob.amount)  \(currentJob.currency)"
        jobDistanceLbl.text = "\( currentJob.jobDistance)"// Distance: 
        jobTitle.text=currentJob.jobTitle
        jobDescription.text=currentJob.jobDescription
        
        if currentJob.sourceView == kSourceJobsCreated
        {
            posterdistance.hidden = true
        }
        else
        {
            println("Show address of the poster.")
            posterdistance.hidden = true
        }
        
        if ((currentJob.createdDate) != nil)
        {
            let ti = NSDate(timeIntervalSince1970: (currentJob.createdDate)/1000)
            let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
            let dateString = dateFormatter.stringFromDate((ObjcUtils.toGlobalTime(ti)))
            jobPostDate.text = "Created on:" + dateString //  String(format: "Created on:%@", dateString)
        }
        
        if(shouldDownloadImage != nil && shouldDownloadImage == true || currentJob.sourceView == kSourceJobsApplied)
        {
            self.fetchJobImage()
        }
        else
        {
            if currentJob.sourceView == kSourceJobsCreated
            {
                posterImage.image = currentUser.profilePic
            }
            else
            {
                posterImage.image = currentJob.posterImage
            }
        }
        
        //Extracting jobs bids count and displaying the count on label outlet
        
        if numberOfValidBids.count != 0
        {
            numberOfValidBids.removeAllObjects()
        }
        
        let bids :NSArray = currentJob.valueForKey("bids") as! NSArray
        numberofBidsount = NSMutableArray(array: bids)
        let i = numberofBidsount.count
        var j = 0
        for j = 0; j < i ; j++
        {
            let bidsDict: NSDictionary = bids.objectAtIndex(j) as! NSDictionary
            if (bidsDict["status"] as! Int == 0 || bidsDict["status"] as! Int == 4)//|| bidsDict["status"] as! Int == 4
            {
                numberOfValidBids.addObject(bidsDict)
            }
        }
        
        if (currentJob.isEvent == "1" || currentJob.volunteersEnabled == true) && currentJob.jobStatus == kJobAccepted
        {
            self.btnAddBid.hidden = true
        }
        
        if currentJob.volunteersEnabled == true
        {
            self.btnAddBid.setTitle("Volunteer", forState: .Normal)
            bidsCount.text = String(format: "Volunteers(%i)", numberOfValidBids.count)
        }
        else if currentJob.isEvent == "1"
        {
            self.btnAddBid.setTitle("Attend", forState: UIControlState.Normal)
            bidsCount.text = String(format: "Attendees(%i)", numberOfValidBids.count)
        }
        else
        {
            self.btnAddBid.setTitle("Add Bid", forState: .Normal)
            bidsCount.text = String(format: "Bids(%i)", numberOfValidBids.count)
        }

        currentJob.validBids = numberOfValidBids
        btnPickImages.badgeValue = String(format:"%i", currentJob.images.count)
        btnPickVideos.badgeValue = String(format:"%i", currentJob.videos.count)
        
        var ti = NSDate(timeIntervalSince1970: (currentJob.startDate as NSTimeInterval)/1000)
        var dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
        var dateString = dateFormatter.stringFromDate(ObjcUtils.toGlobalTime(ti))
        btnJobStartDate.setTitle(String(format: "%@", dateString) , forState:UIControlState.Normal)
        
        ti = NSDate(timeIntervalSince1970: (currentJob.endDate as NSTimeInterval)/1000)
        dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")        
        dateString = dateFormatter.stringFromDate(ObjcUtils.toGlobalTime(ti))
        btnJobEndDate.setTitle(String(format: "%@", dateString) , forState: UIControlState.Normal)
        
        btnAppChat.selected = currentJob.chatCommunication
        btnEmailNotify.selected = currentJob.emailCommunication
        
        if currentJob.jobStatus == kJobAccepted  && currentJob.sourceView == kSourceJobsApplied && currentJob.isEvent == "0"
        {
            btnAddBid.hidden = true
            editButton.hidden = true
//            btnCompleteJob.hidden = false
        }
        else
        {
//            btnCompleteJob.hidden = true
        }
        
        if currentJob.jobStatus as Int != kJobActive && currentJob.isEvent == "0"
        {
            btnAddBid.hidden = true
        }
        
        if currentJob.jobStatus == kJobAccepted
        {
            self.editButton.hidden = true
            self.btnAddBid.hidden = true
        }
        
        var bid: NSDictionary
        for j = 0 ; j < bids.count ; j++
        {
            bid = bids[j] as! NSDictionary
            let bidderId = bid["bidderId"] as! Int
            if bidderId == currentUser.userID && (currentJob.isEvent == "1" || currentJob.volunteersEnabled == true ) && ( bid["status"] as! Int == kJobActive ||  bid["status"] as! Int == kJobAccepted)
            {
                btnEvent.hidden = true
                self.btnAddBid.hidden = true
            }
        }
        
        let startDate = NSDate(timeIntervalSince1970: (currentJob.startDate as NSTimeInterval)/1000)
        
        let systemDate = ObjcUtils.toLocalTime(NSDate())
        // Logic to stop
        if startDate.compare(systemDate) == NSComparisonResult.OrderedAscending
        {
            for j = 0 ; j < bids.count ; j++
            {
                bid = bids[j] as! NSDictionary
                let bidderId = bid["bidderId"] as! Int
                if bidderId == currentUser.userID && (currentJob.isEvent != "1" && currentJob.volunteersEnabled != true ) && bid["status"] as! Int == kJobAccepted && currentJob.jobStatus != kJobPendingApproval
                {
                    btnCompleteJob.hidden = false
                    break
                }
                else
                {
                    btnCompleteJob.hidden = true
                }
            }
        }
        
        if currentJob.isEvent == "1"
        {
            if currentJob.noOfVolunteers == 0
            {
                noOfPeopleRequiredLbl.text = "People Required: NA"
            }
            else
            {
                noOfPeopleRequiredLbl.text = String(format:"People Required: %i", currentJob.noOfVolunteers)
            }
        }
        else
        {
            if currentJob.volunteersEnabled == true
            {
                noOfPeopleRequiredLbl.text = String(format:"Volunteers Required: %i", currentJob.noOfVolunteers)
            }
            else
            {
                noOfPeopleRequiredLbl.text = "People Required: 1"
            }
        }
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
    @IBAction func moveTohome(sender: AnyObject)
    {
        if currentJob.sourceView == kSourceSearchJobs
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("showHome", sender: sender)
        }
    }

    
    @IBAction func showChatView(sender: UIButton)
    {
        println("Show show chat view")
    }
    
    @IBAction func sendChatMessage(sender: UIButton)
    {
        activeField.resignFirstResponder()
        var postParams = ["recipient" : String(format: "%i", currentJob.posterId) , "message": chatField.text!]
        Server.processSendChat(postParams)
    }
    
    func sendTextSuccess(responseDict: AnyObject!)
    {
        println("Chat sent successfully")
    }
    
    func sendTextFailure(error: NSError?)
    {
        println("Chat Failed successfully")
    }
    
    @IBAction func closeChatView(sender: AnyObject)
    {
        activeField.resignFirstResponder()
    }
    
    @IBAction func moveBackToListAction(sender: AnyObject)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func getJobAddress()
    {
        let latitude :CLLocationDegrees = currentJob.lat
        let longitude :CLLocationDegrees = currentJob.lng
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            println(location)
            
            if error != nil
            {
                println("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
//                let pm = placemarks[0] as! CLPlacemark
//                let add = pm.addressDictionary["FormattedAddressLines"] as! NSArray
//                 println("\n \n Add::::\(add)")

                //println("Address::::: \n location:::\(pm.location) \n description:::\(pm.description) \n addressDictionary:::\(pm.addressDictionary) \n name::: \(pm.name)\n thoroughfare::: \(pm.thoroughfare) \n subThoroughfare:::\(pm.subThoroughfare)\n locality:::\(pm.locality) \n subLoc ality:::\(pm.subLocality)  \n administrativeArea:::\(pm.administrativeArea) \n subAdministrativeArea:::\(pm.subAdministrativeArea) \n country:::\(pm.country)  \n ocean:::\(pm.ocean) \n postalCode:::\(pm.postalCode)   ")
            }
            else
            {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    //----------
    private var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    func previousAction(sender : UITextField) {
        println("PreviousAction")
    }
    
    func nextAction(sender : UITextField) {
        println("nextAction")
    }
    
    func doneAction(sender : UITextField) {
        println("doneAction")
    }
    
    func registerForKeyboardHandler()
    {
        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        returnKeyHandler.delegate = self        
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.Done
        returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.ByPosition
    }
    
    // Declare below method in ViewDidLoad
    //  call self.registerForKeyboardHandler()
    //----------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentJob.isEdited = NO
        self.registerForKeyboardHandler()
        
        jobDescription.delegate = self        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tappedBackground:")
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        let spacing: CGFloat = 10
        btnJobStartDate.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0)
        btnJobEndDate.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0);
        
        Server.delegate = self
        self.jobDetailScrollView.contentSize = scrollItemHolder.frame.size
        
//        posterImage.layer.cornerRadius = posterImage.frame.size.height/2.0
//        posterImage.layer.borderColor = UIColor.grayColor().CGColor
//        posterImage.layer.masksToBounds = true
//        posterImage.layer.borderWidth = 1.0
         //Utils.addCornerRadius(posterImage)
        
//        Utils.addCornerRadius(mapViewHolder)
//        Utils.addCornerRadius(mapView)
//        Utils.addCornerRadius(jobDescription)
//        Utils.addCornerRadius(btnJobStartDate)
//        
//        Utils.addCornerRadius(jobTimingsHolder)
//        Utils.addCornerRadius(btnJobEndDate)
//        Utils.addCornerRadius(btnChat)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        // Not reloading view once user is in editing mode.
        if isEditingMode == true
        {
            return
        }
        
        btnPickImages.selected = false
        let lat = currentJob.lat
        let lng = currentJob.lng
        self.showUserLocation(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        
        if currentJob.sourceView == kSourceSearchJobs
        {
            self.btnChat.hidden = true
        }

        if currentJob.sourceView == kSourceJobsCreated
        {
            self.setInteraction(false)
            self.btnAddBid.hidden = true
            self.editButton.hidden = false
            self.btnEvent.hidden = true
            self.btnChat.hidden = true
        }
        else if currentJob.sourceView == kSourceSearchJobs
        {
            self.setInteraction(false)
            if currentJob.isEvent == "1"
            {
                self.btnEvent.hidden = false
                self.btnAddBid.hidden = true
            }
            else
            {
                self.btnEvent.hidden = true
                self.btnAddBid.hidden = false
            }
            self.editButton.hidden = true
            self.btnChat.userInteractionEnabled = true
        }
        self.populateJobDetails()        
    }
    
    func setInteraction(flag: Bool)
    {
        self.jobDescription.editable = flag
        self.jobDescription.userInteractionEnabled = flag
        self.jobDescription.scrollEnabled = true;
        self.jobTitle.userInteractionEnabled = flag
        self.mapView.userInteractionEnabled = flag
        self.btnJobEndDate.userInteractionEnabled = flag
        self.btnJobStartDate.userInteractionEnabled = flag
        self.btnAppChat.userInteractionEnabled = flag
        self.btnEmailNotify.userInteractionEnabled = flag
        self.btnChat.userInteractionEnabled = flag
    }
    
    func showUserLocation(userLocationCor: CLLocationCoordinate2D)
    {
        mapView.camera = GMSCameraPosition.cameraWithTarget(userLocationCor, zoom: 10.0)
        //        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        self.setupLocationMarker(userLocationCor)
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D)
    {
        let locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        
        //        locationMarker.title = mapTasks.fetchedFormattedAddress
//        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 1.0
        if currentJob.isEvent == "0"
        {
            locationMarker.icon = UIImage(named: "Pin-job.png")
        }
        else
        {
            locationMarker.icon = UIImage(named: "Pin-event.png")
        }
        //locationMarker.flat = true
//        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.snippet = "JobLocation."
    }
    
    override func viewWillDisappear(animated: Bool)
    {
       
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let info: NSDictionary  = notification.userInfo!
        let KeyBoardSize = info.valueForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
        
        let activeTextOrigin : CGPoint = self.activeField.frame.origin
        let activeTextHeight : CGFloat = self.activeField.frame.size.height
        
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= KeyBoardSize!.height
        
        let inputViewHeight = inputAccView.frame.size.height as CGFloat
        
        if (!CGRectContainsPoint(visibleRect, activeTextOrigin) || activeField == chatField)
        {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeTextOrigin.y + visibleRect.height )
            println("scrollPoint \(scrollPoint) ")
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
    
    }
    
    func createInputAccessoryView()
    {
        inputAccView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0))
        inputAccView.backgroundColor = UIColor .orangeColor()
        inputAccView.alpha = 0.9
        
        let fn = ".HelveticaNeueInterface-Bold"
        let doneButton = UIButton(frame:CGRectMake(inputAccView.frame.size.width-80,0,70,40))
        doneButton.setTitle("Send", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.titleLabel!.font = UIFont(name: fn, size: 15)
        doneButton.addTarget(self, action: "buttonAccessoryDoneAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        inputAccView.addSubview(doneButton);
        
        let cancelButton = UIButton(frame:CGRectMake(10,0,70,40))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleLabel!.font = UIFont(name: fn, size: 15)
        cancelButton.addTarget(self, action: "buttonAccessoryCancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        inputAccView.addSubview(cancelButton);
    }
    
    func buttonAccessoryCancelAction(sender:UIButton!)
    {
        println("Cancel Clicked")
        activeField.resignFirstResponder()
    }
    
    
    func buttonAccessoryDoneAction(sender:UIButton!)
    {
        println("Done Clicked")
        activeField.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if(identifier == "bidViewSegue" && numberOfValidBids.count == 0 )
        {
            return false
        }
        else if(identifier == "showHome" && currentJob.sourceView == kSourceSearchJobs )
        {
            return false
        }
        else if (identifier == "addBidSegue" && sender?.titleForState(UIControlState.Normal) == "Volunteer")
        {
            return false
        }
        else if identifier == "mapDirection"
        {
            if Utils.isLocationServicesEnabled() == false
            {
                if #available(iOS 8.0, *) {
                    let alertController = UIAlertController(title:kAppName , message: "We can't see you! Please turn on location services in settings", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                        println(action)
                    }
                    alertController.addAction(cancelAction)
                    
                    let destroyAction = UIAlertAction(title: "Settings", style: .Destructive) { (action) in
                        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
                        println("Location services settings")
                    }
                    alertController.addAction(destroyAction)
                    
                    self.presentViewController(alertController, animated: true)
                        {
                            
                    }
                }
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "addBidSegue" && sender?.titleForState(UIControlState.Normal) == "Volunteer")
        {
            
        }
        else if (segue.identifier == "bidViewSegue")
        {
            
        }
        else if (segue.identifier == "mapDirection")
        {
            
        }
        if segue.identifier == "FeedbackViewSegue"
        {
            let feedbackViewController =  segue.destinationViewController as! DBLFeedbackViewController
            feedbackViewController.sourceView = currentJob.sourceView
            return
        }
        
        if segue.identifier == "SegueMessage"
        {
            let messageController = segue.destinationViewController as! MessageController
            let identifier = "\(currentJob.posterId)"
            let chatOp = ChatOperations()
            let chat = chatOp.fetchChatWithIdentifier(identifier, isGroupedChat: false, groupChatId: currentJob.posterName)
            messageController.chat = chat;
            println(chat)
        }
        
        if segue.identifier == "CustomMediaPickerView"
        {
            let button = sender as! UIButton
            let destinationViewController: DBLMediaPickerController = segue.destinationViewController as! DBLMediaPickerController
            
            if button.tag == 10
            {
                destinationViewController.shouldPickImages = true
                destinationViewController.pickedImages.addObjectsFromArray(currentJob.images as [AnyObject])
//                destinationViewController.collectionImages.addObjectsFromArray(currentJob.images as [AnyObject])
            }
            else
            {
                destinationViewController.shouldPickVideos = true
                for item in currentJob.videos
                {
                    destinationViewController.pickedVideos.setValue(item, forKey: item as! String)
                }
            }
            destinationViewController.sourceView = currentJob.sourceView
            destinationViewController.showPickingOption = (isEditingMode) ? true : false
            destinationViewController.delegate = self
        }
    }
    
    func updateJobPic()
    {
        loaddView = UIView(frame: posterImage.bounds)
        loaddView.backgroundColor = UIColor.clearColor()
        loaddView.alpha = 1.0
        
        indicator.hidden = false
        indicator.color = UIColor.blackColor()
        indicator.startAnimating()
        
        let center = loaddView.center
        indicator.center = center
        loaddView.addSubview(indicator)
        //loaddView.backgroundColor = UIColor(patternImage: UIImage(named: "avatar.png")!)
        posterImage.addSubview(loaddView)
    }
    
    func fetchJobImage()
    {
        self.updateJobPic()
        let url = String(format: urlUserProfile, currentJob.posterId as Int)
        println(url)
        let url_request = NSURLRequest(URL: NSURL(string: url)!)
        
        let placeholder = UIImage(named: "avatar.png")
        var imageView = UIImageView()
        posterImage.setImageWithURLRequest(url_request, placeholderImage: placeholder,
            success:
            {
                (request:NSURLRequest!,response:NSHTTPURLResponse?, image:UIImage!) -> Void in
                
                println("Success fetchJobImage ")
                self.indicator.stopAnimating()
                self.loaddView.hidden = true
                
                currentJob.posterImage =  image!
                self.posterImage.image = image!
            },
            failure:
            {
                (request:NSURLRequest!,response:NSHTTPURLResponse?, error:NSError!) -> Void in
                println("Failure fetchJobImage ")
                self.indicator.stopAnimating()
                self.loaddView.hidden = true
        })
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {        
        activeField = textField
        createInputAccessoryView()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func processAttendEvent(sender: AnyObject?)
    {
        let postParams = ["amount":"0.0" ,"currency": "USD" ,"comment": "","jobId": currentJob.jobId]
        Server.processAttendForAnEvent(postParams)
    }
    
    func attendingEventSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if responseDict.count != 0
        {
            if responseDict["code"] as! Int == 0
            {
                currentJob.isEdited = YES // To refresh in Home page
                appDelegate.showToastMessage("Success", message: "Wow, you're popular! You successfully registered for the event.")
                btnEvent.hidden = true
                btnAddBid.hidden = true
                DBManager.jobsBidFor = DBManager.jobsBidFor + 1
                let bids: NSArray = responseDict["payload"] as! NSArray
                println("Bids are : \(bids)")
                currentJob.bids = bids
                println("Bids are : \(currentJob.bids)")
                self.populateJobDetails()
            }
            if responseDict["code"] as! Int == 201
            {
                
            }
        }
    }
    
    func attendingEventFailure(error: NSError!)
    {
        appDelegate.showToastMessage("Failed", message: "Unable to process request at this time, Please try again.")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        jobDescription.resignFirstResponder()
    }
    
    func tappedBackground(tapGesture: UITapGestureRecognizer)
    {
        jobDescription.resignFirstResponder()
    }
    
    func pickedImages(imagesDict: NSMutableArray)
    {
        if isEditingMode
        {
            currentJob.images = imagesDict
            println("Picked Images are : \(imagesDict)")
            self.btnPickImages.badgeValue = String(format: "%i", currentJob.images.count)
            
//            self.imagesArray.addObjectsFromArray(imagesDict as [AnyObject])
//            self.btnPickImages.badgeValue = String(format: "%i", self.imagesArray.count)

        }
    }
    
    func pickedVideos(videos: NSMutableDictionary)
    {
        self.btnPickVideos.badgeValue = String(format: "%i",videos.count)
    }
}

