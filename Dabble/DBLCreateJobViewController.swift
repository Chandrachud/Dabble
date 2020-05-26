//
//  DBLCreateJobViewController.swift
//  Dabble
//
//  Created by Reddy on 7/8/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit
import MapKit
import MediaPlayer

class DBLCreateJobViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, CustomDatePickerDelegate, MPMediaPickerControllerDelegate, DBLServicesResponsesDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DatabackDelegateTwo
{
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var lblJobDuration: UILabel!
    @IBOutlet weak var btnAppChat: UIButton!
    @IBOutlet weak var btnEmailNotify: UIButton!
    @IBOutlet weak var btnJobEndDate: UIButton!
    @IBOutlet weak var btnPostActivity: UIButton!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var lblVolunteer: UILabel!
    @IBOutlet weak var eventSegment: UIButton!
    @IBOutlet weak var jobSegment: UIButton!
    @IBOutlet weak var exchangeSegment: UIButton!

    @IBOutlet weak var btnPickLocation: UIButton!
    @IBOutlet weak var mediaHolderView: UIView!
    
    @IBOutlet weak var volunteerHandler: UISwitch!
    @IBOutlet weak var voulnteerHolderView: UIView!
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    
    @IBOutlet weak var voulnteerNumberInput: UITextField!
    var inputAccView:UIView = UIView()
    var activeField: UITextField = UITextField()
    var activeTextView: UITextView =  UITextView()
    var text: String = String()
    
    var mediaRect : CGRect!
    @IBOutlet weak var jobCost: UITextField!
    
    @IBOutlet weak var jobStartDateInput: UIButton!
    
    @IBOutlet weak var jobTimingsHolderView: UIView!
    @IBOutlet weak var jobDescInput: UITextView!
    @IBOutlet weak var jobTitle: UITextField!
    
    @IBOutlet var btnPickImages: UIButton!
    @IBOutlet var btnPickVideos: UIButton!
    
    @IBOutlet weak var checkMarkAppChat: UIButton!
    @IBOutlet weak var checkMarkEmailNotif: UIButton!
    
    @IBOutlet var pickerHolder: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Event Outlets
    
    var imagesArray = NSMutableArray()
    var videosData = NSMutableArray()
    
    var jobCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var imagesDict = NSMutableDictionary()
    var videosDict = NSMutableDictionary()
//    var videoURLs = NSMutableArray()
    
    var Server = DBLServices()
    var searchedTypes: [String] = []
    
    
    var addressLine1: String = String()
    var addressLine2: String = String()
    var sublocality: String = String()
    var city: String = String()
    var state: String = String()
    var country: String = String()
    var zipCode: String = String()
    
    var videoImagesData = NSMutableData()
    var pickerSource = NSArray()
    
    var selectionType:NSInteger = 0
    
    @IBOutlet weak var jobDurationInput: UIButton!
    @IBOutlet var scrollItemsHolderView: UIView!
    @IBOutlet var JobEntryScroller: UIScrollView!
    var currentDateButton: UIButton!
    var customDatePicker: DBLCustomPickerViewController!
    var dpHolderView: UIView!
    
    @IBAction func handleVoulnteerAction(sender: UISwitch)
    {
        if sender.on
        {
            jobCost.text = ""
            jobCost.userInteractionEnabled = false
            lblNumber.hidden = false
            voulnteerNumberInput.text = ""
            voulnteerNumberInput.hidden = false
            voulnteerNumberInput.resignFirstResponder()
            jobCost.resignFirstResponder()
            jobCost.hidden = true
        }
        else
        {
            jobCost.text = ""
            jobCost.userInteractionEnabled = true
            lblNumber.hidden = true
            voulnteerNumberInput.hidden = true
            voulnteerNumberInput.text = ""
            voulnteerNumberInput.resignFirstResponder()
            jobCost.resignFirstResponder()
            jobCost.hidden = false
        }
    }
    
    @IBAction func handleActivity(sender: UIButton)
    {
        if sender.tag == 1
        {
            selectionType = 0
            jobSegment.selected = true
            eventSegment.selected = false
            exchangeSegment.selected = false
            
            jobSegment.setBackgroundImage((UIImage(named: "tab_selected-1")), forState:UIControlState.Normal)
            eventSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)
            exchangeSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)

            self.refreshView()
           // self.voulnteerHolderView.hidden = false
            if currentUser.userTypeCode == kUserTypeIndividual
            {
               // volunteerHandler.hidden = true
               // lblVolunteer.hidden = true
            }
            else
            {
                //volunteerHandler.hidden = false
                //lblVolunteer.hidden = false
            }
//            self.JobEntryScroller.contentSize = scrollItemsHolderView.frame.size
//            self.JobEntryScroller.contentOffset = CGPointMake(0, 0)
           // voulnteerNumberInput.text = ""
            jobCost.text = ""
//            if volunteerHandler.on
//            {
//                jobCost.userInteractionEnabled = false
//               // voulnteerNumberInput.hidden = false
//               // lblNumber.hidden = false
//                jobCost.hidden = true
//            }
//            else
//            {
//                jobCost.userInteractionEnabled = true
//               // voulnteerNumberInput.hidden = true
//               // lblNumber.hidden = true
//                jobCost.hidden = false
//            }
        }
        else if sender.tag == 2
        {
            selectionType = 1
            jobSegment.selected = false
            exchangeSegment.selected = false
            eventSegment.selected = true
            eventSegment.setBackgroundImage((UIImage(named: "tab_selected-1")), forState:UIControlState.Normal)
            
            jobSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)
            exchangeSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)

//            eventSegment.backgroundColor = appBluecolor
            println("Creating Event")
            self.refreshView()
            //self.voulnteerHolderView.hidden = false
            self.JobEntryScroller.contentSize = scrollItemsHolderView.frame.size
//            eventSegment.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            self.JobEntryScroller.contentOffset = CGPointMake(0, 0)
            //volunteerHandler.hidden = true
           // lblVolunteer.hidden = true
            jobCost.userInteractionEnabled = true
            voulnteerNumberInput.text = ""
           // lblNumber.hidden = false
           // voulnteerNumberInput.hidden = false
            jobCost.text = ""
            jobCost.hidden = false
                        voulnteerNumberInput.userInteractionEnabled = true
        }
        
        else if sender.tag == 3
        {
            selectionType = 2
            jobSegment.selected = false
            eventSegment.selected = false
            exchangeSegment.selected = true
            
            exchangeSegment.setBackgroundImage((UIImage(named: "tab_selected-1")), forState:UIControlState.Normal)

            jobSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)
            eventSegment.setBackgroundImage((UIImage(named: "tab_unselected")), forState:UIControlState.Normal)

            self.JobEntryScroller.contentSize = scrollItemsHolderView.frame.size
            self.JobEntryScroller.contentOffset = CGPointMake(0, 0)
            jobCost.userInteractionEnabled = true
            jobCost.text = ""
            jobCost.hidden = false

        }
    }
    
    func refreshView()
    {
        jobCost.text = ""
        let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
        let timeString = dateFormatter.stringFromDate(ObjcUtils.toLocalTime(NSDate()))
        jobTitle.text = ""
        jobDescInput.text = "Enter Description"
        jobStartDateInput.setTitle(timeString, forState: UIControlState.Normal)
//        btnJobEndDate.setTitle(timeString, forState: UIControlState.Normal)
        btnAppChat.selected = false
        btnEmailNotify.selected = true
        imagesArray.removeAllObjects()
        videosData.removeAllObjects()
        self.showUserLocation(appDelegate.currentLocation)
    }
    
    @IBAction func pickPickerValue(sender: UIButton)
    {
        let row =  pickerView.selectedRowInComponent(0)
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: { finished in
        })
        jobDurationInput.setTitle("\(row+1)", forState: UIControlState.Normal)
    }
    
    @IBAction func showDaysPicker(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.pickerHolder.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: { finished in
        })
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "\(row+1)"
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 99
    }
    
    @IBAction func createJobAction(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        //        self.getImagesDataArray()
        
        var alertMsg = ""
        
        if jobTitle.text!.characters.count == 0 || (jobTitle.text == "Title")
        {
            alertMsg = "Please enter the title of the job"
        }
        else if jobDescInput.text!.characters.count == 0 || (jobDescInput.text == "Enter Description")
        {
            alertMsg = "Please enter a short description on your job"
        }
        else if jobCost.text!.characters.count == 0 && !exchangeSegment.selected //&& !volunteerHandler.on //(jobCost.text == "0.00")
        {
            alertMsg = "Please enter the dollar amount you would like to pay"
        }
//        else if (voulnteerNumberInput.text!.characters.count == 0 && volunteerHandler.on && Int(voulnteerNumberInput.text!) == 0) // TODO
//        {
//            alertMsg = "Please enter how many volunteers you need"
//        }
        else if jobDescInput.text == "Enter Description"
        {
            alertMsg = "Please enter a short description on your job"
        }
        
        if (alertMsg.characters.count != 0)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        var jobStartDate: String = self.jobStartDateInput.titleForState(UIControlState.Normal)!
        
        let dateFormatter = Utils.getDateFormatterForFormat("MMM-dd-yyyy")
        let startDate: NSDate = dateFormatter.dateFromString(jobStartDate)!
        let endDate: NSDate = startDate.dateByAddingTimeInterval(60*60*24*7)
        //dateFormatter.dateFromString(jobEndDate)!
        
        var jobEndDate: String = dateFormatter.stringFromDate(endDate)
        //self.jobStartDateInput.titleForState(UIControlState.Normal)!

        if startDate.compare(endDate) == NSComparisonResult.OrderedDescending
        {
            alertMsg = "Activity end date can't be less than start date."
        }
        
        if (alertMsg.characters.count != 0)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        jobStartDate = Utils.getSupportFormattedDate(jobStartDate)
        jobEndDate = Utils.getSupportFormattedDate(jobEndDate)
        
        
        var timeZone:String = NSTimeZone.localTimeZone().abbreviation!
        timeZone = timeZone.substringToIndex(timeZone.startIndex.advancedBy(3))
        
        jobStartDate = String(format: "%@ %@", jobStartDate, Utils.getSupportFormattedTime(("HH:mm:ss")))
        jobEndDate = String(format: "%@ 23:59:59", jobEndDate)
        
//        jobStartDate = String(format: "%@ %@ %@", jobStartDate, Utils.getSupportFormattedTime(("HH:mm:ss")), timeZone)
//        jobEndDate = String(format: "%@ 23:59:59 %@", jobEndDate, timeZone)
        
        var noOfVol = Int()
        if voulnteerNumberInput.text!.characters.count == 0
        {
            noOfVol = 0
        }
        else
        {
            noOfVol = Int(voulnteerNumberInput.text!)!
        }
        
        if jobCoordinate.latitude == 0 && jobCoordinate.longitude == 0
        {
            jobCoordinate.latitude = appDelegate.currentLocation.latitude
            jobCoordinate.longitude = appDelegate.currentLocation.longitude
        }
        
//        let properSystemDate = ObjcUtils.toLocalTime(NSDate())
//        let createdDate = Int64(properSystemDate.timeIntervalSince1970 * 1000)        
        
//        dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
        var timeString = dateFormatter.stringFromDate(ObjcUtils.toLocalTime(NSDate()))
        timeString = Utils.getSupportFormattedDate(timeString)
        
//        let isEvent:Bool = (eventSegment.selected) ? true : false
        let isEvent = String(selectionType) as String

        let amount: Double = NSString(string: jobCost.text!).doubleValue // 3.1
        let postParams = [
            "jobTitle": jobTitle.text!,
            "description": jobDescInput.text!,
            "lat": jobCoordinate.latitude,
            "lng": jobCoordinate.longitude,
            "isEvent" : isEvent,
            "event" : isEvent,
            "amount": amount,
            "currency": "USD",
            "startDate": jobStartDate,
            "endDate": jobEndDate,
          //  "volunteers": volunteerHandler.on,
            "numberOfVolunteers": noOfVol,
            "emailCommunication": true, // Email Notification always true
            "chatCommunication": btnAppChat.selected,
            "createdDate" : timeString,
            "timezone": timeZone,
        ]
        println("Payload is : \(postParams)")
        self.Server.processCreateJob(postParams, imageURLs: self.imagesArray, videoURLs:self.videosData)
    }
    
    func getTrueFalse(selected: Bool) -> String
    {
        if selected
        {
            return "true"
        }
        else
        {
            return "false"
        }
    }
    
    override func  shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if identifier == "LocationViewSegue"
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
        return true;
    }
    
    func getIdForCategory(catName: String) -> Int
    {
        //        var i = 0
        //        var tempCatName = String()
        //        for (i ; i < appDelegate.categories.count ; i++)
        //        {
        //            var tempCat: NSDictionary = appDelegate.categories.objectAtIndex(i) as! NSDictionary
        //            tempCatName = tempCat["categoryName"]! as! String
        //            if (tempCatName == catName)
        //            {
        //                return tempCat["categoryId"] as! Int
        //            }
        //        }
        return 0
    }
    
    func createJobSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("createJobSuccess \(responseDict)")
        if(responseDict.count != 0)
        {
            println("createJobSuccess \(responseDict)")
            
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                appDelegate.showToastMessage(kAppName, message: "Your post has been submitted!")
                self.navigationController?.popViewControllerAnimated(true)
                DBManager.jobsCreated = DBManager.jobsCreated + 1
                NSNotificationCenter.defaultCenter().postNotificationName(kJobCreatedNotification, object: nil)
                return
            }
//            else
//            {
//                alertMsg = Utils.statusMessageFor(statusCode)
//                if alertMsg.characters.count != 0
//                {
//                    UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
//                    return;
//                }
//            }
            
            switch (statusCode)
            {            
            case 201:
                self.subscriptionIsExpired()
                return
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
    
    func createJobFailure(error: NSError?)
    {
        appDelegate.showToastMessage("Error", message: "Your post failed, if the problem persists please contact support@thedabbleapp.com")
    }
    
    func createJobUploadMediaFailure(error: NSError?)
    {
        appDelegate.showToastMessage("Failure", message: "Media upload failed! Please go to edit job & try again.")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func  subscriptionIsExpired()
    {
        appDelegate.showToastMessage("Expired", message: "Uh-oh! Users can view posts without a subscription but cannot post, choose a subscription model to post")
        self.performSegueWithIdentifier("SubscriptionsViewSegue", sender: self)
    }
    
    @IBAction func pickDay(sender: UIButton)
    {
        
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        if sender.selected == true
        {
            sender.selected = false
            sender.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            sender.selected = true
            sender.backgroundColor = primaryColorOfApp
        }
        
        //Updating the Label with working days count
        // Days buttons are assigned with 11 to 17 tags.
        var counter = 0
        for var i = 11; i<=17; i++
        {
            
            let dayButton: UIButton = (jobTimingsHolderView.viewWithTag(i) as? UIButton)!
            if dayButton.selected
            {
                ++counter
            }
        }
    }
    
    @IBAction func appChatAction(sender: UIButton)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
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
        activeTextView.resignFirstResponder()
        if sender.selected == true
        {
            sender.selected = false
        }
        else
        {
            sender.selected = true
        }
    }
    
    @IBAction func pickeImages(sender: UIButton)
    {
        
    }
    
    @IBAction func pickVideos(sender: AnyObject)
    {
        appDelegate.showToastMessage("", message:"Videos need to be mp4 or mpeg4 format and last no longer than 30 seconds")
    }
    
    @IBAction func moveBackToDashboard(sender: UIButton) {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func removeImage(gesture: UILongPressGestureRecognizer)
    {
        var imageView = gesture.view as! UIImageView
        println("Delete image ?")
    }
    
    func successForDataCalled( data:NSData)
    {
        videoImagesData.appendData(data)
    }
    
    func updateImagesOnScroller()
    {
        //        self.cleanImageScroller()
        //        var xCoord = btnPickImages.frame.origin.x
        //        var yCoord = btnPickImages.frame.origin.y
        //        var width =  btnPickImages.frame.size.width
        //        var height = btnPickImages.frame.size.height
        //        var vSpace: CGFloat = 8.0
        //
        //        var tempImage: UIImageView!
        //        var longPressGesture : UILongPressGestureRecognizer!
        //
        //        var images = imagesDict.allValues
        //        var imageKeys = imagesDict.allKeys
        //        for var i = 0; i < images.count ; i++
        //        {
        //            longPressGesture = UILongPressGestureRecognizer(target: self, action:"removeImage:")
        //            longPressGesture.minimumPressDuration = 1.0
        //            var image: UIImage = images[i] as! UIImage
        //            tempImage = UIImageView(frame: CGRectMake(xCoord, yCoord, width, height))
        //            tempImage.image = image
        //            tempImage.tag = btnPickImages.tag
        //            tempImage.addGestureRecognizer(longPressGesture)
        //            tempImage.userInteractionEnabled = true
        //            btnPickImages.tag = btnPickImages.tag + 1
        //            xCoord = xCoord + width + vSpace
        //            isContentView.addSubview(tempImage)
        //            println("\(xCoord), \(yCoord) , \(height) , \(width)")
        //            self.getDataForImageAssetURL(imageKeys[i] as! NSURL)
        //        }
        //        var contentWidth = xCoord + width + vSpace
        //        if (contentWidth > isContentView.frame.size.width)
        //        {
        //            isContentView.frame.size = CGSizeMake(contentWidth, isContentView.frame.size.height)
        //            imageScroller.contentSize = isContentView.frame.size
        //        }
        //        btnPickImages.frame = CGRectMake(xCoord, yCoord, width, height)
        //        println(btnPickImages)
    }
    
    func getDataForImageAssetURL(assetURL: NSURL)
    {
        let refURL = assetURL
        if let actualMediaURL = refURL as NSURL! {
            var fileName = "temp.jpg"
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.assetForURL(actualMediaURL , resultBlock: { (asset: ALAsset!) -> Void in
                if let actualAsset = asset as ALAsset? {
                    let assetRep: ALAssetRepresentation = actualAsset.defaultRepresentation()
                    fileName = assetRep.filename()
                    let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                    let image = UIImage(CGImage: iref)
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
                    let documentsDir = paths.firstObject as! NSString?
                    if let documentsDirectory = documentsDir {
                        let localFilePath = documentsDirectory.stringByAppendingPathComponent(fileName)
                        let data = UIImageJPEGRepresentation(image, 1.0)
                        self.imagesArray.addObject(data!)
                        let image = UIImage(data: data!)
                        println(image)
                        //                                let couldCopy = data.writeToFile(localFilePath, atomically: true)
                        //                                let localFileURL = NSURL(fileURLWithPath: localFilePath)
                    }
                }
                }, failureBlock: { (error) -> Void in
                    
            })
        }
    }
    
    func getDataForVideoAssetURL(assetURL: NSURL)
    {
        let refURL = assetURL
        if let actualMediaURL = refURL as NSURL! {
            let fileName = "temp.mp4"
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.assetForURL(actualMediaURL , resultBlock: { (asset: ALAsset!) -> Void in
                if let actualAsset = asset as ALAsset?
                {
                    var data = ObjcUtils.getDataForAsset(actualAsset)

                    let localVideoPath = (self.documentsDirectory() as NSString).stringByAppendingPathComponent("first.mp4")
                    let success = data?.writeToFile(localVideoPath, atomically: false)
                    
                    println(localVideoPath)
                    if (success != nil)
                    {
                        data = NSData.dataWithContentsOfMappedFile(localVideoPath) as! NSData
                    }                    
                    self.videosData.addObject(data)
//                    self.videosData.addObject(localVideoPath)
                }
                }, failureBlock: { (error) -> Void in
            })
        }
    }
    
    func documentsDirectory() -> String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentsPath as String
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBOutlet weak var mapHolderView: UIView!
    
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
        btnEmailNotify.selected = true
        self.registerForKeyboardHandler()
        if currentUser.userTypeCode == kUserTypeIndividual
        {
           // volunteerHandler.hidden = true
           // lblVolunteer.hidden = true
        }
        
        //        if jobDescInput.text == ""
        //        {
        jobDescInput.text = "Enter Description"
        jobDescInput.textColor = UIColor.lightGrayColor()
        // }
        
        let spacing: CGFloat = 10.0; // the amount of spacing to appear between image and title
        
        jobStartDateInput.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0)
//        btnJobEndDate.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0);
        
        Utils.addCornerRadius(jobDescInput)
        Utils.addCornerRadius(jobTimingsHolderView)
        Utils.addCornerRadius(btnPostActivity)
//        Utils.addCornerRadius(btnJobEndDate)
        Utils.addCornerRadius(jobStartDateInput)
        jobSegment.selected = true
        
//        ObjcUtils.setMaskTo(jobSegment, byRoundingCorners:  [.TopLeft, .BottomLeft])
//        ObjcUtils.setMaskTo(eventSegment, byRoundingCorners:  [.TopRight, .BottomRight])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
        let timeString = dateFormatter.stringFromDate(ObjcUtils.toLocalTime(NSDate()))
        println(timeString)
        
        jobStartDateInput.setTitle(timeString, forState: UIControlState.Normal)
//        btnJobEndDate.setTitle(timeString, forState: UIControlState.Normal)
        mediaRect = btnPickImages.frame
        Server.delegate = self
        //        Server.processGetCategories(nil)
        self.JobEntryScroller.contentSize = CGSizeMake(scrollItemsHolderView.frame.size.width, scrollItemsHolderView.frame.size.height)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        customDatePicker = storyboard.instantiateViewControllerWithIdentifier("CustomDatePicker") as! DBLCustomPickerViewController
        customDatePicker.delegate = self
        if (appDelegate.currentLocation != nil)
        {
            self.showUserLocation(appDelegate.currentLocation)
        }
        self.pickerHolder.frame = CGRectMake(self.pickerHolder.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        Server.processGetClientTokenInfo()
    }
    
//    override func viewWillAppear(animated: Bool)
//    {
//        self.abc()
//    }
//    
//    func abc()
//    {
//        let responseDict = ["code": 201, "Message": "Expired"];
//        self.createJobSuccess(responseDict)
//    }
    
    override func viewWillDisappear(animated: Bool)
    {
        sharedManager.stopUpdatingHeading()
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let info: NSDictionary  = notification.userInfo!
        let KeyBoardSize = info.valueForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= KeyBoardSize!.height
        let inputViewHeight = inputAccView.frame.size.height as CGFloat
        if(text == "textField")
        {
            let activeTextOrigin : CGPoint = self.activeField.frame.origin
            let activeTextHeight : CGFloat = self.activeField.frame.size.height
            if (!CGRectContainsPoint(visibleRect, activeTextOrigin) )//|| activeField == jobCost
            {
                let scrollPoint:CGPoint = CGPointMake(0.0,  KeyBoardSize!.height  - inputViewHeight)
                println("scrollPoint \(scrollPoint) ")
                JobEntryScroller.setContentOffset(scrollPoint, animated: true)
            }
        }else if(text == "textView")
        {
            let activeTextOrigin : CGPoint = self.activeTextView.frame.origin
            var activeTextHeight : CGFloat = self.activeTextView.frame.size.height
            
            if (!CGRectContainsPoint(visibleRect, activeTextOrigin) || activeTextView == jobDescInput)
            {
                let scrollPoint:CGPoint = CGPointMake(0.0,  inputViewHeight )
                
                //let scrollPoint:CGPoint = CGPointMake(0.0, activeTextOrigin.y - visibleRect.height + activeTextHeight + inputViewHeight+40)
                println("scrollPoint \(scrollPoint) ")
                JobEntryScroller.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        if(text == "textField")
        {
            if(activeField == jobCost )
            {
                JobEntryScroller.setContentOffset(CGPointMake(0, self.scrollItemsHolderView.frame.size.height - self.JobEntryScroller.frame.size.height), animated: true)
            }
        }else if(text == "textView")
        {
            if(activeTextView == jobDescInput )
            {
                JobEntryScroller.setContentOffset(CGPointMake(0, self.scrollItemsHolderView.frame.size.height - self.JobEntryScroller.frame.size.height), animated: true)
            }
            
        }
        
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        JobEntryScroller.contentInset = contentInsets
        JobEntryScroller.scrollIndicatorInsets = contentInsets
    }
    
    func createInputAccessoryView()
    {
        return
        inputAccView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0))
        inputAccView.backgroundColor = UIColor .orangeColor()
        inputAccView.alpha = 0.9
        
        let fn = ".HelveticaNeueInterface-Bold"
        let doneButton = UIButton(frame:CGRectMake(inputAccView.frame.size.width-80,0,70,40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.titleLabel!.font = UIFont(name: fn, size: 15)
        doneButton.addTarget(self, action: "buttonAccessoryDoneAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let cancelButton = UIButton(frame:CGRectMake(10,0,70,40))
        cancelButton.setTitle("Done", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleLabel!.font = UIFont(name: fn, size: 15)
        cancelButton.addTarget(self, action: "buttonAccessoryCancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        if(activeField == jobCost || activeField == voulnteerNumberInput )
        {
            doneButton.setTitle("Done", forState: UIControlState.Normal)
            
        }
        inputAccView.addSubview(doneButton);
        
    }
    
    func buttonAccessoryCancelAction(sender:UIButton!)
    {
        println("Cancel Clicked")
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
    }
    
    func buttonAccessoryDoneAction(sender:UIButton!)
    {
        println("Done Clicked")
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
    }
    
    
    // Methods for Date and Time Picking
    @IBAction func showTimePicker(sender: UIButton)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        if (appDelegate.window != nil)
        {
            appDelegate.window?.addSubview(customDatePicker.view)
        }
        currentDateButton = sender
        customDatePicker.dateTimePicker.datePickerMode = UIDatePickerMode.Time // 4- use time only
        customDatePicker.dateTimePicker.minuteInterval = 15
    }
    
    @IBAction func showDatePicker(sender: UIButton)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        currentDateButton = sender
        if (appDelegate.window != nil)
        {
            appDelegate.window?.addSubview(customDatePicker.view)
        }
        customDatePicker.dateTimePicker.datePickerMode = UIDatePickerMode.Date // 4- use time only
        let currentDate = ObjcUtils.toGlobalTime(NSDate())  //5 -  get the current date
        customDatePicker.dateTimePicker.minimumDate = currentDate  //6- set the current date/time as a minimum
//        customDatePicker.dateTimePicker.date =
        //        customDatePicker.dateTimePicker.date = currentDate //7 - defaults to current time but shows how to use it.
    }
    
    // MARK: - CustomPickerViewDelegate methods
    
    func hidePickerView(sender: UIBarButtonItem)->Void
    {
        println("hidePickerView")
        self.customDatePicker.view.removeFromSuperview()
    }
    
    func pickedDate(var pickedDate: NSDate)->Void
    {
        pickedDate = ObjcUtils.toLocalTime(pickedDate)
        println("pickedDate: \(ObjcUtils.toLocalTime(pickedDate))")
        self.customDatePicker.view.removeFromSuperview()
        var timeString: String!
        if (currentDateButton.tag == 1)
        {
            // Format Date
            let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
            timeString = dateFormatter.stringFromDate(pickedDate)
//            self.btnJobEndDate.setTitle(timeString, forState: UIControlState.Normal)
        }
        else if (currentDateButton.tag == 2)
        {
            // Format Time
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour, .Minute], fromDate: pickedDate)
            let hour = components.hour
            var minutes = components.minute
            
            minutes =  ((minutes / 15 ) * 15)
            timeString =  String(format:"%i:%02i",hour,minutes)
        }
        self.currentDateButton.setTitle(timeString, forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "LocationViewSegue"
        {
            let controller =  segue.destinationViewController as! DBLLocationHandlerViewController
            controller.createJobViewController = self
            controller.selectionFrom = "CreateJobView"
            controller.isEvent = eventSegment.selected ? true : false
        }
        else  if segue.identifier == "CustomMediaPickerView"
        {
            let button = sender as! UIButton
            let destinationViewController = segue.destinationViewController as! DBLMediaPickerController
            
            if button.tag == 10
            {
                destinationViewController.shouldPickImages = true
                if imagesArray.count != 0
                {
                    destinationViewController.pickedImages.addObjectsFromArray(imagesArray as [AnyObject])
                }
            }
            else
            {                
                destinationViewController.shouldPickVideos = true
                if videosDict.count != 0
                {
                    destinationViewController.pickedVideos.addEntriesFromDictionary(videosDict as [NSObject : AnyObject])
                }
            }
            destinationViewController.sourceView = kSourceCreateJob
            destinationViewController.showPickingOption = true
            destinationViewController.delegate = self
        }
    }
    
    func pickedVideos(videos: NSMutableDictionary)
    {
        if self.videosDict.count != 0
        {
            self.videosDict.removeAllObjects()
        }
        println("Picked Videos are : \(videos)")
        self.videosDict.addEntriesFromDictionary(videos as [NSObject : AnyObject])
        self.btnPickVideos.badgeValue = String(format: "%i",videosDict.count)
        
        self.videosData.removeAllObjects()
        
        for url in videosDict.allKeys
        {
            println(url)
            self.getDataForVideoAssetURL(NSURL(string:url as! String)!)
        }
    }
    
    func getLocalVideoPath(videoPath: String)
    {
        let uploadURL = NSURL.fileURLWithPath((NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("first.mp4"))
        
        let url = NSURL(string: videoPath)
        let asset = AVURLAsset(URL:url!, options:nil)
        
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        session!.outputURL = uploadURL
        session!.outputFileType = AVFileTypeMPEG4
        
        session!.exportAsynchronouslyWithCompletionHandler({
            switch session!.status{
            case  AVAssetExportSessionStatus.Failed:
                println("failed \(session!.error)")
            case AVAssetExportSessionStatus.Cancelled:
                println("cancelled \(session!.error)")
            default:
                println("complete: \(uploadURL)")
                let videoData = NSFileManager.defaultManager().contentsAtPath(uploadURL.absoluteString)
                println("Video data at url: \(uploadURL)  \n \n \n \n \(videoData)")
                //                self.videoURLs.addObject(uploadURL!)
            }
        })
    }
    
    func pickedImages(imagesDict: NSMutableArray)
    {
        if self.imagesArray.count != 0
        {
            self.imagesArray.removeAllObjects()
        }
        println("Picked Images are : \(imagesDict)")
        self.imagesArray.addObjectsFromArray(imagesDict as [AnyObject])
        self.btnPickImages.badgeValue = String(format: "%i", self.imagesArray.count)
    }
    
    func showSelectedLocation(locationDetails: GMSAddress)
    {
        println("PICKKKSelectedLocation \(locationDetails)")
        jobCoordinate = locationDetails.coordinate as CLLocationCoordinate2D
        self.showUserLocation(jobCoordinate)
        //            addressLine1 = locationDetails.thoroughfare
        //
        //           addressLine2 = locationDetails.subLocality
        //
        //            city = locationDetails.locality
        //            state = locationDetails.administrativeArea
        //            country = locationDetails.country
        //           zipCode = locationDetails.postalCode
    }
    
    func showUserLocation(userLocationCor: CLLocationCoordinate2D)
    {
        mapView.camera = GMSCameraPosition.cameraWithTarget(userLocationCor, zoom: 10.0)
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        // marker.map = mapView
        self.setupLocationMarker(userLocationCor)
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D)
    {
        if locationMarker != nil
        {
            locationMarker.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
//        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 1.0
        if eventSegment.selected == true
        {
            locationMarker.icon = UIImage(named: "Pin-event.png")
        }
        else
        {
            locationMarker.icon = UIImage(named: "Pin-job.png")
        }

        //locationMarker.flat = true
//        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.snippet = "JobLocation."
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == jobCost
        {
            let countdots = textField.text!.componentsSeparatedByString(".").count - 1
            if countdots > 0 && string == "."
            {
                return false
            }
        }
        return true
    }    
    
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        text = "textField"
        activeField = textField
        createInputAccessoryView()
//        textField.inputAccessoryView = inputAccView
    }
    func textFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    {
        
        return true;
        
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
//    {
//        
//        //textField.resignFirstResponder()
//        
//        if(text == "textField")
//        {
//            if(activeField == jobTitle )
//            {
//                //jobDescInput.text = ""
//                jobDescInput.becomeFirstResponder()
//            }
//            else
//            {
//                textField.resignFirstResponder()
//            }
//            
//            return true;
//        }
//        
//        return true;
//    }    
    
    //MARK: UITextViewDelegate methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        text = "textView"
        activeTextView = textView
//        textView.inputAccessoryView = inputAccView
        textView.returnKeyType = UIReturnKeyType.Default        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == "Enter Description"
        {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text == ""
        {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        println("\(text.characters.count)")
        
        if textView.text.characters.count >= 500 && text.characters.count != 0
        {
            return false
        }
        return true
    }

    func pickedData(dict: NSMutableDictionary)
    {
        imagesDict = dict
        btnPickImages.badgeValue = String(format: "%i", imagesDict.count)
    }
    
    func getDataForURL(videoURLString: String) -> NSData
    {
        var uploadURL: NSURL = ObjcUtils.getFileUrlForURL(videoURLString)
        
        println("Local file path: \(uploadURL) \n \n \(uploadURL.absoluteString)")
        println("\(NSData.dataWithContentsOfMappedFile(uploadURL.absoluteString))")
        var videoData = NSData()
        
        if (NSFileManager.defaultManager().fileExistsAtPath(uploadURL.absoluteString) == true)
        {
            videoData = NSFileManager.defaultManager().contentsAtPath(uploadURL.absoluteString)!
        }
        println("Video data is : \n]n : \(videoData)")
        return videoData
    }
    
}
