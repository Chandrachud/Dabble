//
//  DBLCreateAccountViewController.swift
//  Dabble
//
//  Created by Reddy on 7/3/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit
import MapKit

class DBLCreateAccountViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, DBLLocationHandlerDelegate, DBLServicesResponsesDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UIWebViewDelegate
{
    @IBOutlet var firstNameInput: UITextField!
    @IBOutlet weak var ATMultiple: UIButton!
    @IBOutlet weak var ATSingle: UIButton!
    @IBOutlet weak var btnSelectState: UIButton!
    @IBOutlet var pickerHolder: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    var userLocation: CLLocation = CLLocation()
    
    @IBOutlet weak var aboutMeTitleLbl: UILabel!
    @IBOutlet weak var confirmEmailInput: UITextField!
    @IBOutlet weak var btnCreateAcc: UIButton!
    //var locationManager: CLLocationManager!
    var imagePicker:UIImagePickerController!
    var firstName: String = String()
    
    var lastName: String = String()
    var emailID: String = String()
    var gender: String = String()
    
    @IBOutlet weak var agreeToggle: UIButton!
    var activeField: UITextField = UITextField()
    var activeTextView: UITextView =  UITextView()
    var text: String = String()
    
    @IBOutlet weak var cityInput: UITextField!
    var imageURL: String = String()
    var fbID: String = String()
    var Server: DBLServices = DBLServices()
    var searchedTypes: [String] = []
    let manager = AFHTTPRequestOperationManager()
    var profilePicURL: NSURL!
    
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var agreementContentView: UIWebView!
    @IBOutlet weak var hideAgreement: UIButton!
   
    @IBOutlet weak var agreementHyperlinkBtn: UIButton!
    
    
    func underlineButton(button : UIButton, text: String) {
        
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        button.setAttributedTitle(titleString, forState: .Normal)
    }
    
    @IBAction func agreeAction(sender: AnyObject)
    {
        agreeToggle.selected = true;
        btnCreateAcc.enabled = true;
        hideAgreement.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    @IBAction func showAgreement(sender: AnyObject?)
    {
        DismissKeyboard()
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.agreementView.frame = CGRectMake(0, 0, self.agreementView.frame.size.width, self.agreementView.frame.size.height)
            }, completion: { finished in
                self.agreementContentView.delegate = self;
                self.agreementContentView.loadRequest(NSURLRequest(URL: NSURL(string:urlAgreement)!))
        })
    }

func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
{
    appDelegate.showLoadingView(nil)
    return true
}

func webViewDidFinishLoad(webView: UIWebView)
{
    appDelegate.hideLoadingView()
    
    let res: NSString = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")!
    let h: CGFloat = CGFloat(res.integerValue)
    agreementContentView.scrollView.contentSize = CGSizeMake(webView.frame.size.width, h + 50);
}

func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
{
    appDelegate.showToastMessage("Error", message: "We are not able to process the request. Please try again later.")
}

    @IBAction func hideAgreement(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.agreementView.frame = CGRectMake(0, self.agreementView.frame.size.height, self.agreementView.frame.size.width, self.agreementView.frame.size.height)
            }, completion: { finished in
        })
    }
    
    @IBAction func agreeToggleAction(sender: AnyObject)
    {
        let button: UIButton! = sender as! UIButton
        
        if button.selected
        {
            button.selected = false;
            self.btnCreateAcc.enabled = false;
        }
        else
        {
            button.selected = true;
            self.btnCreateAcc.enabled = true;
        }
    }
    @IBOutlet weak var aboutMeTxVw: UITextView!
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var accountScrollerView: UIScrollView!
    @IBOutlet var scrollItemsHolder: UIView!
    
    @IBOutlet var lastNameInput: UITextField!
    @IBOutlet var emailInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var confirmPasswordInput: UITextField!
    @IBOutlet var zipcodeInput: UITextField!
    
    @IBOutlet var countryInput: UITextField!
    @IBOutlet var addressLine2: UITextField!
    
    @IBOutlet var addressLine1: UITextField!
    @IBOutlet var mobileNumberInput: UITextField!
    
    @IBOutlet var profilePicBtn: UIButton!
    var statesArray = americanStates
    var pickerSource : NSArray!
        
    var image: UIImage?
    
    @IBAction func pickState(sender: AnyObject)
    {
        activeTextView.resignFirstResponder()
        activeField.resignFirstResponder()
        pickerSource = statesArray
        pickerView.reloadAllComponents()
        self.pickerHolder.hidden = false
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                let scrollPoint:CGPoint = CGPointMake(0.0, self.btnSelectState.frame.origin.y - self.pickerHolder.frame.size.height + self.btnSelectState.frame.size.height )
                println("scrollPoint \(scrollPoint) ")
                self.accountScrollerView.setContentOffset(scrollPoint, animated: true)
                
                self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height - self.pickerHolder.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
            }, completion: { finished in
        })
    }
    
    @IBAction func handleAccountType(sender: UIButton)
    {
        if ATSingle.selected == false && sender == ATSingle
        {
            ATSingle.selected = true
            ATMultiple.selected = false
            firstNameInput.text = ""
            lastNameInput.text = ""
        }
        else  if ATMultiple.selected == false && sender == ATMultiple
        {
            ATSingle.selected = false
            ATMultiple.selected = true
            firstNameInput.text = ""
            lastNameInput.text = ""
        }
        if ATSingle.selected == true
        {
            firstNameInput.placeholder = "First Name"
            lastNameInput.placeholder = "Last Name"
            aboutMeTitleLbl.text = "  About me (Optional)"
            aboutMeTxVw.text = "About me"
        }
        else
        {
            firstNameInput.placeholder = "Organization Name"
            lastNameInput.placeholder = "Website (Optional)"
            aboutMeTitleLbl.text = "  About us (Optional)"
            aboutMeTxVw.text = "About us"
        }
    }
    
    @IBAction func pickPickerValue(sender: UIButton)
    {
        activeField.resignFirstResponder()
        self.pickerHolder.hidden = true
        let row =  pickerView.selectedRowInComponent(0)
        
        println("Picked state : \(pickerSource[row])");
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
                
            }, completion: { finished in
        })
        //        stateInput.text = pickerSource[row] as! String
        btnSelectState.setTitle("\(pickerSource[row])", forState: UIControlState.Normal)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return pickerSource[row] as! String
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerSource == nil
        {
            return 0
        }
        return pickerSource.count
    }
    
    @IBAction func createAccountClicked(sender: UIButton)
    {
        activeField.resignFirstResponder()
        //        Services.
        var alertMsg :String!
        
        //Temparory
//        self.performSegueWithIdentifier("ShowSubscriptionView", sender: self)
//        return;
        
        let accountType = ATSingle.selected ? "1" : "2"
        if firstNameInput.text!.characters.count == 0
        {
            alertMsg = ATSingle.selected ? "Please enter your first name  to finish creating your account" : "Please enter the name of your organization to finish creating your account"            
        }
        else if lastNameInput.text!.characters.count == 0 && ATSingle?.selected == true
        {
            alertMsg = "Please enter your last name to finish creating your account"
        }
        else if emailInput.text!.characters.count == 0
        {
            alertMsg = "Please enter your email address to create your account"
        }
        else if confirmEmailInput.text!.characters.count == 0
        {
            alertMsg = "Please enter your confirm email address to create your account"
        }
        else if emailInput.text?.caseInsensitiveCompare(confirmEmailInput.text!) != NSComparisonResult.OrderedSame
        {
            alertMsg = "Email and confirm email did not match."
        }
        else if passwordInput.text!.characters.count == 0
        {
            alertMsg = "Please create a password for your account"
        }
        else if confirmPasswordInput.text!.characters.count == 0
        {
            alertMsg = "Please confirm your password"
        }
//        else if addressLine1.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your address to create your account"
//        }
//        else if cityInput.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your city to create your account"
//        }
//        else if btnSelectState.titleForState(UIControlState.Normal) == "Select State"
//        {
//            alertMsg = "Please select a state to create your account"
//        }
//        else if countryInput.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your country to create your account"
//        }
//        else if zipcodeInput.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your zipcode to create your account"
//        }
//        else if mobileNumberInput.text!.characters.count == 0
//        {
//            alertMsg = "Please add your mobile phone number to create your account"
//        }
        else if passwordInput.text!.characters.count < 6 || confirmPasswordInput.text!.characters.count < 6
        {
            alertMsg = "Password length must be greater than or equal to 6 characters"
        }
        else if firstNameInput.text == lastNameInput.text
        {
            alertMsg = "First and last names should not match"
        }
        else if passwordInput.text != confirmPasswordInput.text
        {
            alertMsg = "Your password confirmation did not match"
        }
        else if zipcodeInput.text?.characters.count != 0 && zipcodeInput.text!.characters.count != 5
        {
            alertMsg = "Please enter a valid zipcode"
        }
        else if (mobileNumberInput.text?.characters.count != 0 && mobileNumberInput.text!.characters.count != 14)
        {
            alertMsg = "Please enter a valid 10 digit mobile number"
        }
        else if Utils.isValidEmail(emailInput.text!)
        {
            alertMsg = "Please enter a valid email id"
        }
        
        var imageData = NSData();
        if profilePicBtn.imageForState(UIControlState.Normal)  == nil || (self.profilePicBtn.imageForState(UIControlState.Normal) == UIImage(named:"Camera.png"))
        {
            imageData = UIImagePNGRepresentation(UIImage(named: "avatar.png")!)!
        }
        else
        {
            imageData = UIImagePNGRepresentation(self.profilePicBtn.imageForState(UIControlState.Normal)!)!
        }
        if (agreeToggle.selected == false)
        {
            appDelegate.showToastMessage("Agreement", message: "Please read and accept agreement");
        }
        if (alertMsg != nil)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        var aboutMe = "";
        if ( aboutMeTxVw.text.characters.count == 0 || aboutMeTxVw.text == "About me" || aboutMeTxVw.text == "About us" )
        {
            aboutMe = "";
        }
        else
        {
            aboutMe = aboutMeTxVw.text;
        }
        let zipCode = (zipcodeInput.text?.characters.count == 0) ? "00000" : zipcodeInput.text!;
        
        var state = btnSelectState.titleForState(UIControlState.Normal)!
        
        if (state == "Select State")
        {
            state = "State"
        }
        
        let addressDict = ["addressLine1": addressLine1.text!,"addressLine2": addressLine2.text!,"city": cityInput.text!,"country": countryInput.text!,"state": state,"zip": zipCode];
        
        print("%@",addressDict);
        let selCatIds = self.prepareSelectedCatList()
        
        // Converting US formatted phone to plain number
        //------
        let validFormatPhno = mobileNumberInput.text!.stringByReplacingOccurrencesOfString(
            "\\D", withString: "", options: .RegularExpressionSearch,
            range: mobileNumberInput.text!.startIndex..<mobileNumberInput.text!.endIndex)
        //-----
        
        var timeZone:String = NSTimeZone.localTimeZone().abbreviation!
        timeZone = timeZone.substringToIndex(timeZone.startIndex.advancedBy(3))
        
        var postParams : NSDictionary!
        if (appDelegate.FBUserID.characters.count != 0)
        {
            postParams = ["gender": 1,"dob": "22-Oct-1983","password":passwordInput.text!,"firstName":firstNameInput.text!,"lastName":lastNameInput.text!,"aboutMe" : aboutMe,"email":emailInput.text!.lowercaseString,"phone":validFormatPhno, "address":addressDict, "facebookId":appDelegate.FBUserID , "favouriteCategories" : selCatIds, "userTypeCode" : accountType, "timezone" : timeZone];
        }
        else
        {
            postParams = ["gender": 1,"dob": "22-Oct-1983","password":passwordInput.text!,"firstName":firstNameInput.text!,"lastName":lastNameInput.text!,"aboutMe" : aboutMe,"email":emailInput.text!.lowercaseString, "phone":validFormatPhno, "address":addressDict, "favouriteCategories" : selCatIds, "userTypeCode" : accountType, "timezone" : timeZone];
        }
        print("post params are : %@", postParams);
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
        
        println("Create Account URL : \(urlCreateAccount)")
        println("JSONText: \(theJSONText)")
        appDelegate.showLoadingView(nil)
        
        manager.POST( urlCreateAccount, parameters:postParams,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                data.appendPartWithFileData(imageData, name:"photo", fileName:"Photo", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes this was a success \n  response is :\(responseObject)")
                self.userCreationSuccess(responseObject)
                appDelegate.hideLoadingView()
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                self.userCreationFailure(error)
                println("We got an error here.. \(error.localizedDescription)")
                appDelegate.hideLoadingView()
        })
        //        Server.processCreateUser(postParams, profileFileURL: profilePicURL!)
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = kAppFont
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = fetchLabelForRowNumber(row)
        
        return pickerLabel!;
    }
    
    func fetchLabelForRowNumber(row: Int) -> String
    {
        return pickerSource[row] as! String
    }
    
    func getSelectedCatIDs() -> NSArray
    {
        let array = NSMutableArray()
        
        for (var i = 0 ; i < searchedTypes.count ; i++ )
        {
            array.addObject(self.getIdForCategory(searchedTypes[i]))
        }
        return array
    }
    
    //    var selCatIds = self.prepareSelectedCatList()
    func prepareSelectedCatList()-> NSArray
    {
        let array = NSMutableArray()
        //        var catDict = NSMutableDictionary()
        var catValue :String!
        for (var i = 0 ; i < searchedTypes.count ; i++ )
        {
            let catDict = NSMutableDictionary()
            catValue = searchedTypes[i]
            catDict["value"] = catValue
            catValue = searchedTypes[i]
            catDict["key"] = self.getIdForCategory(searchedTypes[i])
            array.addObject(catDict)
        }
        return array
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
    
    func DismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //----------
    private var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    func previousAction(sender : UITextField) {
        println("PreviousAction")
    }
    
    func nextAction(sender : UITextField) {
        println("nextAction")
    }
    
    func doneAction(sender : UITextField)
    {
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
//        agreeToggle.layer.borderColor = UIColor.blackColor().CGColor;
//        agreeToggle.layer.cornerRadius = agreeToggle.frame.size.width / 2;
//        agreeToggle.layer.borderWidth = 0.5;
//        agreeToggle.layer.masksToBounds = true;
        self.underlineButton(agreementHyperlinkBtn, text: agreementHyperlinkBtn.titleForState(.Normal)!)
        self.registerForKeyboardHandler()
        aboutMeTxVw.text = "About me"
        aboutMeTxVw.textColor = UIColor.lightGrayColor()
        btnCreateAcc.enabled = false;
        
        ATSingle.selected = true
        
        Server.delegate = self
        Utils.addCornerRadius(profilePicBtn)
        Utils.addCornerRadius(btnCreateAcc)
        Utils.addCornerRadius(btnSelectState)
        Utils.addCornerRadius(aboutMeTxVw)
        //        // MARK: LocationHandler Methods
        //
        //        sharedManager.delegate = self
        //        sharedManager.startUpdating()
        
        //=============
        
        agreementContentView.backgroundColor = UIColor.whiteColor()
        imagePicker = UIImagePickerController()
        
        self.firstNameInput.text = firstName
        self.lastNameInput.text = lastName
        self.emailInput.text = emailID
        self.confirmEmailInput.text = emailID
        self.accountScrollerView.contentSize = CGSizeMake(scrollItemsHolder.frame.size.width, scrollItemsHolder.frame.size.height)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // self.pickerHolder.frame = CGRectMake(self.pickerHolder.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        //countryInput.userInteractionEnabled = false
        
    }
    
    override func viewDidAppear(animated: Bool)
    {

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        sharedManager.stopUpdatingHeading()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
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
        
       
        
        if(text == "textField" && activeField == zipcodeInput)
        {
        
                aboutMeTxVw.becomeFirstResponder()
        
        }
        else if(text == "textView" && activeTextView == aboutMeTxVw)
        {
            
                mobileNumberInput.becomeFirstResponder()
            
        }
        else
        {
            activeField.resignFirstResponder()
            activeTextView.resignFirstResponder()
        }

        
//            if(activeField != zipcodeInput)
//            {
//                var nextTag:Int = activeField.tag+1
//                let nextResponder = activeField.superview?.viewWithTag(nextTag) as UIResponder!
//                
//                if (nextTag == mobileNumberInput.tag+1)
//                {
//                    
//                    activeField.resignFirstResponder()
//                }
//                else
//                {
//                    nextResponder.becomeFirstResponder()
//                }
//            }
//            else
//            {
//                aboutMeTxVw.becomeFirstResponder()
//            }
//        }
//        else if(text == "textView")
//        {
//            if(activeTextView == aboutMeTxVw )
//            {
//                mobileNumberInput.becomeFirstResponder()
//            }
//        }
        
    }
    
    //    func initilize()
    //    {
    //        locationManager = CLLocationManager()
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.delegate = self
    //    }
    
    @IBAction func showCategoriesList(sender: AnyObject)
    {
        activeField.resignFirstResponder()
    }
    override func viewWillAppear(animated: Bool)
    {
        
        
        
        // MARK: LocationHandler Methods
        //        sharedManager.delegate = self
        //        sharedManager.startUpdating()
        
        if (firstName.characters.count != 0)
        {
            self.firstNameInput.text = firstName
            self.lastNameInput.text = lastName
            self.emailInput.text = emailID
        }
        
        profilePicBtn.selected = false
        // Get user profile pic
        //        let url = NSURL(string: "https://graph.facebook.com/\(fbID)/picture?type=normal")
        if (imageURL.characters.count != 0)
        {
            Server.processImageDownload(self.imageURL)
        }
    }
    
    func imageDownloadSuccess(responseDict: AnyObject)
    {
        println("Image downloading successed : \(responseDict)")
        self.profilePicBtn.setImage(responseDict as? UIImage , forState: UIControlState.Normal)
    }
    
    func imageDownloadFailure(error: NSError)
    {
        println("Failed to download profile pic image from facebook.")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        println("Picked image at url \(info)")
        let imageselected = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        var imageMemorySize = UIImageJPEGRepresentation(imageselected, 1.0)!.length
//        let sizeOfImage = imageselected.size
        let size = self.profilePicBtn.frame.size
        let imageResized:UIImage = Utils.imageResize(imageselected,sizeChange: size)
        imageMemorySize = UIImageJPEGRepresentation(imageResized, 1.0)!.length
        println(imageResized.size)
        self.profilePicBtn.setImage(imageResized, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func imageCropViewController(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!)
    {
        var imageMemorySize = UIImageJPEGRepresentation(croppedImage, 1.0)!.length
        println(imageMemorySize/1024)
        let sizeOfImage = croppedImage.size
        let size = sizeOfImage
        let imageResized:UIImage = Utils.imageResize(croppedImage,sizeChange: size)
        imageMemorySize = UIImageJPEGRepresentation(imageResized, 1.0)!.length
        println(imageMemorySize/1024)
        
        println(imageResized.size)
        profilePicBtn.setImage(croppedImage, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewControllerDidCancel(controller: UIViewController!)
    {
        println("imageCropViewControllerDidCancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadAssetForJob(mediaData: NSData)
    {
        let manager = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = requestSerializer
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
        
        let requestURL = "http://104.197.91.16/dabble/rest/v0/service/job/30/add-files/user/25/"
        manager.POST( requestURL, parameters:nil,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                let mediaData = NSData()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                
                println(documentsPath)
                //            var imagePath = documentsPath.stringByAppendingPathComponent("avatar.png")
                //            data.appendPartWithFileURL(NSURL(fileURLWithPath: imagePath), name: "images", error: nil)
                
                data.appendPartWithFileData(mediaData, name: "images", fileName: "images", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes thies was a success \n  response is :\(responseObject)")
                // Upload media files here.
                println("Successfully uploaded video / image to server")
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                println("We got an error to upload asset for job\(error.localizedDescription)")
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moveBackToLoginAction(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("FBUserID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("FBAuthCode")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //        Services.registerUser(nil)
        //        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showImageSourcesAction(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        profilePicBtn.selected = true
        let sourcesView: UIActionSheet = UIActionSheet(title: "Choose Image Source", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:"Photo Library", otherButtonTitles: "Camera")
        sourcesView.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        
        switch (buttonIndex)
        {
            
        case 0:
            println("0: Photo Library")
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        case 1:
            println("1: Cancel Action Sheet")
            
        case 2:
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            else
            {
                UIAlertView(title: "", message: "Camera doesn't exist, please choose other source.", delegate: nil, cancelButtonTitle: "OK").show()
            }
        default:
            println("Default")
        }
    }
    
    //MARK: Service Calls
    
    func userCreationSuccess(responseObj: AnyObject!)
    {
        println("userCreationSuccess success with: \(responseObj)")
        
        let responseDict = responseObj as! NSDictionary
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            
//            "Your account has been created! Check your provided email for confirmation. Enjoy your free trial!"
            
            appDelegate.showToastMessage(kAppName, message: "Your account has been created! Check your provided email for confirmation.")
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        else
        {
            alertMsg = Utils.statusMessageFor(statusCode)
            if alertMsg.characters.count != 0
            {
                UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                return;
            }
        }
    }

    // Newly created user must have free trial, so once the user creation successful, calling service for free trial.
    func subscribeFreeTrail()
    {
        let postParams = ["userId": currentUser.userID, "subscriptionType": 2 , "cardNumber": "4111111111111111" , "expiryDate":"12/2017", "amount": 0, "currency" : "USD", "cvv": "002"]
        Server.processGetSubscribe(postParams)
    }
    
    func subscribingSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if responseDict["code"] as! Int == 0
        {
            appDelegate.showToastMessage(kAppName, message: "Your Free trial account is created. Please login to enjoy services.")
        }
        else
        {
            let alert = UIAlertView(title: kAppName, message: "Failed to subscrbe for Free Trial.", delegate: self, cancelButtonTitle: "Cancel")
            alert.addButtonWithTitle("Retry")
            alert.show()            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribingFailure(error: NSError)
    {
        println(error.localizedDescription)
        let alert = UIAlertView(title: kAppName, message: "Failed to subscrbe for Free Trial.", delegate: self, cancelButtonTitle: "Cancel")
        alert.addButtonWithTitle("Retry")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            self.subscribeFreeTrail()
        }
    }
    
    func userCreationFailure(error: NSError?)
    {
        println("userCreationFailure success with: \(error)")
        UIAlertView(title: "Failed", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        
        //        UIAlertView(title: "Congratulations", message:"New account created, please login to post/accept jobs", delegate: nil, cancelButtonTitle: "OK").show()
        
        //        switch (statusCode)
        //        {
        //        case 0:
        //            println("Success")
        //            UIAlertView(title: "Congratulations", message:"New account created, please login to post/accept jobs", delegate: nil, cancelButtonTitle: "OK").show()
        //            return
        //        case 100:
        //            alertMsg = "The provided email Id already exists in the system and cannot be added again."
        //            break
        //
        //        case 101:
        //            alertMsg = "Invalid username or password."
        //            break
        //
        //        case 102:
        //            alertMsg = "Profile Image is (either black and white or greyscale) and doesn't match our criteria for profile photo, the user needs to be taken to the profile completion page and asked to supply another image."
        //            break
        //
        //        case 103:
        //            alertMsg = "When an update request is sent against a user who is inactive."
        //            break
        //
        //        case 104:
        //            alertMsg = "When an update request is sent against a user who is unavailable."
        //            break
        //
        //        case 105:
        //            alertMsg = "When the gender has been updated as part of the registration (via facebook) and the user has set the gender via the update request."
        //            break
        //
        //        case 106:
        //            alertMsg = "When the user data contains invalid information, (eg., numbers in name)."
        //            break
        //
        //        case 107:
        //            alertMsg = "Please enter valid username and password."
        //            break
        //
        //        default:
        //            alertMsg = "The provided email Id already exists in the system and cannot be added again."
        //            println("Default Case ")
        //        }
        
        //        if count(alertMsg) != 0
        //        {
        //            UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
        //            return;
        //        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LocationViewSegue"
        {
            let controller =  segue.destinationViewController as! DBLLocationHandlerViewController
            controller.createAccountViewController = self
            controller.selectionFrom = "CreateAccountView"
        }
        else if segue.identifier == "CropViewSegue"
        {
            let navController: UINavigationController = segue.destinationViewController as! UINavigationController
//            let controller = navController.viewControllers[0] as! ImageCropperViewController
//            controller.delegate = self;
//            controller.image = self.image
//            controller.imageView?.image = self.image
//            print(controller.image)
//            print(controller.imageView?.image)
        }
    }
    
    func showSelectedLocation(locationDetails: GMSAddress)
    {
        println("PICKKKSelectedLocation \(locationDetails)")
        
        let coordinate:CLLocationCoordinate2D = locationDetails.coordinate as CLLocationCoordinate2D
        self.showUserLocation(coordinate)
        
        var addressList:NSArray = locationDetails.lines as NSArray
        
        addressLine1.text = locationDetails.thoroughfare
        
        addressLine2.text = locationDetails.subLocality
        
        cityInput.text = locationDetails.locality
        
        if(locationDetails.administrativeArea != nil)
        {
            btnSelectState.setTitle(locationDetails.administrativeArea, forState: UIControlState.Normal)
        }
        else
        {
            btnSelectState.setTitle("Select State", forState: UIControlState.Normal)
        }
        
        
        countryInput.text = locationDetails.country
        
        zipcodeInput.text = locationDetails.postalCode
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
//        locationMarker.appearAnimation = kGMSAP
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 1.0
        //locationMarker.flat = true
        locationMarker.snippet = "User Selected Location."
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        firstNameInput.resignFirstResponder()
        lastNameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        confirmPasswordInput.resignFirstResponder()
        addressLine1.resignFirstResponder()
        addressLine2.resignFirstResponder()
        countryInput.resignFirstResponder()
        zipcodeInput.resignFirstResponder()
        mobileNumberInput.resignFirstResponder()
    }
    
    //    //MARK: DBLLocationHandlerDelegate methods
    //    func locationManager(manager: CLLocationManager!, didUpdateLocation location:CLLocation!)
    //    {
    //        appDelegate.currentLocation = location.coordinate
    //        var currentLocationCoord = location.coordinate
    //        sharedManager.stopUpdating()
    //    }
    //    func locationManager(manager: CLLocationManager!, didUpdateNewHeading heading: CLHeading!)
    //    {
    //        //println("Current heading data is : \(heading)")
    //    }
    //
    //    func locationManager(manager: CLLocationManager!, failedWithError error: NSError!)
    //    {
    //        print("Failed to pick the current location")
    //    }
    
    
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        activeField = textField
        
//        textField.autocorrectionType = UITextAutocorrectionType.No
//        self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
//        
//        
//        text = "textField"

//        createInputAccessoryView()
//        textField.inputAccessoryView = inputAccView
        if textField == zipcodeInput || textField == mobileNumberInput
        {
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        if (string.characters.count == 0)
        {
            return true
        }
        
        if (textField == mobileNumberInput)
        {
            let totalString = String(format: "%@%@", textField.text!, string)
            if (range.length == 1)
            {
                textField.text = ObjcUtils.formatPhoneNumber(totalString, deleteLastChar: true)
            }else
            {
                textField.text = ObjcUtils.formatPhoneNumber(totalString, deleteLastChar: false)
            }
            return false;
        }
        else
            if (textField == zipcodeInput && textField.text!.characters.count > 4)
            {
                return false
        }
        return true
    }
    
    //MARK- UITextView Callback methods
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        text = "textView"
        activeTextView = textView
        textView.returnKeyType =  UIReturnKeyType.Default
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == "About me"
        {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text == ""
        {
            textView.text = "About me"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        return true
    }
}


