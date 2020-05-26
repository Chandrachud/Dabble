                                                                                                                                                                                                                                                                                            //
//  DBLMyProfileViewController.swift
//  Dabble
//
//  Created by Reddy on 7/20/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit


class DBLMyProfileViewContorller : UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, DBLServicesResponsesDelegate
{
    @IBOutlet var pickerHolder: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var abouttitleLbl: UILabel!
    @IBOutlet var email: UITextField!
    @IBOutlet var addressLine1: UITextField!
    @IBOutlet var addressLine2: UITextField!
    @IBOutlet var State: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var zipcode: UITextField!
    @IBOutlet var mobileNo: UITextField!
    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var profilePicBtn: UIButton!
    @IBOutlet var locationPickBtn: UIButton!
    
    @IBOutlet weak var aboutMeTxVw: UITextView!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var saveBtn: UIButton!
    
    var activeField: UITextField = UITextField()
    var activeTextView: UITextView =  UITextView()
    var text: String = String()
    
    @IBOutlet weak var titleMyProfile: UITextView!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var address: UITextView!
    @IBOutlet var scrollViewItemsHolder: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    var imagePicker :UIImagePickerController!
    var Server = DBLServices()
    
    var statesArray = americanStates
    var pickerSource : NSArray!
    
    var image: UIImage?
    
    @IBOutlet weak var btnSelectState: UIButton!
    @IBAction func showMenu(sender: AnyObject)
    {
        let mainVC = self.mainSlideMenu()
        mainVC.openLeftMenu()
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
    }
    
    @IBAction func pickState(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        pickerSource = statesArray
        pickerView.reloadAllComponents()
        self.pickerHolder.hidden = false
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                let scrollPoint:CGPoint = CGPointMake(0.0, self.btnSelectState.frame.origin.y - self.pickerHolder.frame.size.height + self.btnSelectState.frame.size.height )
                println("scrollPoint \(scrollPoint) ")
                self.scrollView.setContentOffset(scrollPoint, animated: true)
                
                self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height - self.pickerHolder.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
                
                
                // self.pickerHolder.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: { finished in
        })
    }
    
    @IBAction func pickPickerValue(sender: UIButton)
    {
        self.pickerHolder.hidden = true
        activeField.resignFirstResponder()
        let row =  pickerView.selectedRowInComponent(0)
        
        println("Picked state : \(pickerSource[row])");
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                
                let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
                
                self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
                
                
                //self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: { finished in
        })
        btnSelectState.setTitle(pickerSource[row] as? String, forState: UIControlState.Normal)
        //        pickerHolder.removeFromSuperview()
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
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
    
    func enableAllFields()
    {
        email.userInteractionEnabled = false
        addressLine1.userInteractionEnabled = true
        addressLine2.userInteractionEnabled = true
        cityInput.userInteractionEnabled = true
        btnSelectState.userInteractionEnabled = true
        country.userInteractionEnabled = true
        zipcode.userInteractionEnabled = true
        mobileNo.userInteractionEnabled = true
        profilePicBtn.userInteractionEnabled = true
        aboutMeTxVw.userInteractionEnabled = true
    }
    
    func disableAllFields()
    {
        email.userInteractionEnabled = false
        addressLine1.userInteractionEnabled = false
        addressLine2.userInteractionEnabled = false
        cityInput.userInteractionEnabled = false
        btnSelectState.userInteractionEnabled = false
        country.userInteractionEnabled = false
        zipcode.userInteractionEnabled = false
        mobileNo.userInteractionEnabled = false
        aboutMeTxVw.userInteractionEnabled = false
        profilePicBtn.userInteractionEnabled = false
    }
    
    @IBAction func saveAction(sender: UIButton)
    {
        self.updateUserDataToServer()
    }
    
    @IBAction func editAction(sender: UIButton)
    {
        activeField.resignFirstResponder()
        saveBtn.hidden = false
        editBtn.hidden = true
        self.enableAllFields()
        
        
        
        //        var btnTitle:String = sender.currentTitle!
        //
        //        //email.becomeFirstResponder()
        //        if(btnTitle == "Edit")
        //        {
        //            self.enableAllFields()
        //            sender.setTitle("Update Profile", forState: UIControlState.Normal)
        //        }
        //        else //if(btnTitle == "SAVE")
        //        {
        //            //self.disableAllFields()
        //            //sender.setTitle("EDIT", forState: UIControlState.Normal)
        //
        //            // Send Data to Server
        //            self.updateUserDataToServer()
        //        }
    }
    
    func DismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //----------
    private var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    func previousAction(sender : UITextField) {
        print("PreviousAction")
    }
    
    func nextAction(sender : UITextField) {
        print("nextAction")
    }
    
    func doneAction(sender : UITextField) {
        print("doneAction")
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
        self.registerForKeyboardHandler()
        Server.delegate = self
        Utils.addCornerRadius(profilePicBtn)
        Utils.addCornerRadius(editBtn)
        Utils.addCornerRadius(saveBtn)
        Utils.addCornerRadius(aboutMeTxVw)
        Utils.addCornerRadius(btnSelectState)
        
        editBtn.hidden = false
        saveBtn.hidden = true
        
        imagePicker = UIImagePickerController()
        scrollView.contentSize = self.scrollViewItemsHolder.frame.size
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
//        let typeOfAccount = (currentUser.userTypeCode == 1) ? "Individual" : "Organisation";
        
        (currentUser.userTypeCode == 2) ? (lastName.placeholder = "Website (Optional)") :  (lastName.placeholder = "Last Name")
        
        titleMyProfile.text = "My Profile: " + ((currentUser.userTypeCode == 1) ? "Individual" : "Organisation")
        titleMyProfile.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        titleMyProfile.textColor = UIColor.whiteColor()
        abouttitleLbl.text = (currentUser.userTypeCode == 1) ? "  About me (Optional)" : "  About us (Optional)"
        
        //        self.pickerHolder.frame = CGRectMake(self.pickerHolder.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        //        var tapGesture = UITapGestureRecognizer(target: self, action: Selector(tappedOutside( UITapGestureRecognizer())))
        //        self.scrollViewItemsHolder.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
        
        self.populateMyProfile()
        self.disableAllFields()
    }
    
    func resignActiveTextField()
    {
        email.resignFirstResponder()
        addressLine1.resignFirstResponder()
        addressLine2.resignFirstResponder()
        cityInput.resignFirstResponder()
        
        country.resignFirstResponder()
        zipcode.resignFirstResponder()
        mobileNo.resignFirstResponder()
    }
    
    func populateMyProfile()
    {
        self.firstName.text=currentUser.firstName
        self.lastName.text=currentUser.lastName
        self.email.text=currentUser.emailID
        self.addressLine1.text = currentUser.addressLine1
        self.addressLine2.text = currentUser.addressLine2
        self.cityInput.text = currentUser.city
        self.aboutMeTxVw.text = currentUser.aboutMe
        let state = (currentUser.state == "Select State" || currentUser.state.characters.count == 0) ? "State" : currentUser.state;
        self.btnSelectState.setTitle(state, forState: UIControlState.Normal)
        self.country.text = currentUser.country
        let zipCode = (currentUser.zipcode == 0) ? "" : NSString(format: "%0.5d",currentUser.zipcode) as String;
        self.zipcode.text = zipCode;
        self.mobileNo.text = ObjcUtils.formatPhoneNumber(currentUser.phone, deleteLastChar: false)
        
        if (currentUser.profilePic != nil)
        {
            self.profilePicBtn.setImage(currentUser.profilePic, forState: UIControlState.Normal)
        }
        else
        {
            self.profilePicBtn.setImage(UIImage(named: "avatar.png"), forState: UIControlState.Normal)
        }
    }
    
    func updateUserDataToServer()
    {
        if self.isAddressChanged() || self.isProfilePicChanged() || self.isMobileNumbeChanged() || self.isAboutMeChanged()
        {
            println("Profile is changed")
        }
        else
        {
            println("Profile is not changed")
            //editBtn.setTitle("Edit", forState: UIControlState.Normal)
            editBtn.hidden = false
            saveBtn.hidden = true
            self.disableAllFields()
            return
        }
        
        var alertMsg :String!
            
            //        else if count(passwordInput.text) == 0
            //        {
            //            alertMsg = "Password field must not be empty"
            //        }
            //
            //        else if count(confirmPasswordInput.text) == 0
            //        {
            //            alertMsg = "Confirm Password field must not be empty"
            //        }
        
//        if addressLine1.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your address to update your account"
//        }
        
            //        else if count(addressLine2.text) == 0
            //        {
            //            alertMsg = "AddressLine2 field must not be empty"
            //        }
            
//        else if cityInput.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your city to update your account"
//        }
        
//        else if btnSelectState.titleForState(UIControlState.Normal) == "Select State"
//        {
//            alertMsg = "Please select a state to update your account"
//        }
        
//        else if country.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your country to update your account"
//        }
        
//        else if zipcode.text!.characters.count == 0
//        {
//            alertMsg = "Please enter your zipcode to create your account"
//        }
        
//        if mobileNo.text!.characters.count == 0 && mobileNo.text?.characters.count != 0
//        {
//            alertMsg = "Please add your mobile phone number to create your account"
//        }
//        else 
        
        var validFormatPhno = ""
        if zipcode.text!.characters.count != 5 && zipcode.text!.characters.count != 0
        {
            alertMsg = "Please enter a valid zipcode"
        }
        else if (mobileNo.text!.characters.count != 14 && mobileNo.text!.characters.count != 0)
        {
            alertMsg = "Please enter a valid 10 digit mobile number"
        }
        else if Utils.isValidEmail(email.text!)
        {
            alertMsg = "Please enter a valid email id"
        }
        var aboutMe = "";
        if ( aboutMeTxVw.text.characters.count == 0 || aboutMeTxVw.text == "About me" || aboutMeTxVw.text == "About us" )
        {
           aboutMe = "";
        }
        
        // Converting US formatted phone to plain number
        //------
        if (mobileNo.text!.characters.count == 14)
        {
            validFormatPhno = mobileNo.text!.stringByReplacingOccurrencesOfString(
            "\\D", withString: "", options: .RegularExpressionSearch,
            range: mobileNo.text!.startIndex..<mobileNo.text!.endIndex)
        }
        //------
        
        let imageData = UIImagePNGRepresentation(self.profilePicBtn.imageForState(UIControlState.Normal)!)
        
        if (alertMsg != nil)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        let zc = (zipcode.text?.characters.count != 5) ? "00000" : zipcode.text;
        
        if self.isAddressChanged()
        {
            let addressDict = ["addressLine1": addressLine1.text!,"addressLine2": addressLine2.text!,"city": cityInput.text!, "country": country.text!,"state": btnSelectState.titleForState(UIControlState.Normal)!,"zip": zc, "timezone" : currentUser.timezone]
            print(addressDict);
            
            Server.processAddAddress(addressDict)
        }
        
        let postParams = [ "gender" : 1 , "dob" : "22-Oct-1983", "firstName":firstName.text! , "lastName":lastName.text! , "email" : email.text! , "phone" : validFormatPhno , "aboutMe": aboutMe, "userTypeCode": currentSubscription!.userTypeCode as Int, "timezone" : currentUser.timezone]
        
        if self.isProfilePicChanged() || isMobileNumbeChanged() || isAboutMeChanged()
        {            
            Server.processUpdateUser(postParams, imageData: imageData)
            return
        }
        //
        //        if self.isProfilePicChanged()
        //        {
        //            Server.processUpdateUser(postParams, imageData: imageData)
        //        }
        //
        //        if self.isMobileNumbeChanged()
        //        {
        //            var postParams = ["phone" : validFormatPhno ]
        //            Server.processUpdateUser(postParams, imageData: nil)
        //        }
    }
    
    //    var selCatIds = self.prepareSelectedCatList()
    
    func updateUserSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        print("userCreationSuccess success with: \(responseDict)")
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            
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
        
        //editBtn.setTitle("Edit", forState: UIControlState.Normal)
        editBtn.hidden = false
        saveBtn.hidden = true
        self.disableAllFields()
        println("Success")
        UIAlertView(title: kAppName, message:"Your profile has been successfully updated", delegate: nil, cancelButtonTitle: "OK").show()
        
        currentUser.addressLine1 = addressLine1.text
        currentUser.addressLine2 = addressLine2.text
        currentUser.city = cityInput.text
        currentUser.profilePic = profilePicBtn.imageForState(UIControlState.Normal)
        let zc = (zipcode.text?.characters.count != 5) ? "00000" : zipcode.text;
        currentUser.zipcode = Int(zc!)
        currentUser.country = country.text!
        currentUser.state = btnSelectState.titleForState(UIControlState.Normal)
        currentUser.aboutMe = aboutMeTxVw.text
        let validFormatPhno = mobileNo.text!.stringByReplacingOccurrencesOfString(
            "\\D", withString: "", options: .RegularExpressionSearch,
            range: mobileNo.text!.startIndex..<mobileNo.text!.endIndex)
        
        currentUser.phone = validFormatPhno
        
        self.navigationController?.popViewControllerAnimated(true)
        return
    }
    
    func updateUserFailure(error: NSError?)
    {
        //editBtn.setTitle("EDIT", forState: UIControlState.Normal)
        appDelegate.showToastMessage("Failed", message: "Your profile was not successfully updated")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
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
        
        
        
        
        if(text == "textField" && activeField == zipcode)
        {
            
            aboutMeTxVw.becomeFirstResponder()
            
        }
        else if(text == "textView" && activeTextView == aboutMeTxVw)
        {
            
            mobileNo.becomeFirstResponder()
            
        }
        else
        {
            activeField.resignFirstResponder()
            activeTextView.resignFirstResponder()
        }
        
        
        
        //        if(text == "textField")
        //        {
        //            if(activeField != zipcode)
        //            {
        //                var nextTag:Int = activeField.tag+1
        //                let nextResponder = activeField.superview?.viewWithTag(nextTag) as UIResponder!
        //
        //                if (nextTag == mobileNo.tag+1)
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
        //
        //        }
        //        else if(text == "textView")
        //        {
        //            if(activeTextView == aboutMeTxVw )
        //            {
        //                mobileNo.becomeFirstResponder()
        //            }
        //        }
        
        
        
    }
    
    @IBAction func moveBack(sender: UIButton)
    {
        activeField.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //    func tappedOutside(gesture: UITapGestureRecognizer)
    //    {
    //        println("Tapgesture recognized")
    //        email.resignFirstResponder()
    //        mobileNo.resignFirstResponder()
    //        email.userInteractionEnabled = false
    //        mobileNo.userInteractionEnabled = false
    //    }
    
    
    @IBAction func enableEditing(sender: UIButton)
    {
        //        var tag = sender.tag
        //        switch (tag)
        //        {
        //        case 1: // Edit email
        //            email.userInteractionEnabled = true
        //            email.becomeFirstResponder()
        //            break
        //        case 2: // Edit Address
        //            address.userInteractionEnabled = true
        //            address.becomeFirstResponder()
        //            break
        //        case 3: // Edit Mobile number
        //            mobileNo.userInteractionEnabled = true
        //            mobileNo.becomeFirstResponder()
        //            break
        //        case 4: // Edit Categories
        //            print("Edit categories case 4")
        //            break
        //        default:
        //            print("Edit Default case")
        //
        //        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    //    {
    //        email.resignFirstResponder()
    //        mobileNo.resignFirstResponder()
    //        email.userInteractionEnabled = false
    //        address.userInteractionEnabled = false
    //        mobileNo.userInteractionEnabled = false
    //    }
    
    
    //Resizing Image
    //    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage
    //    {
    //        let hasAlpha = true
    //        let scale: CGFloat = 0.0 // Use scale factor of main screen
    //
    //        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    //        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
    //
    //        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    //        return scaledImage
    //
    //        //        UIGraphicsBeginImageContext(sizeChange)
    //        //        image.drawInRect(CGRectMake(0, 0, sizeChange.width, sizeChange.height))
    //        //        var newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        //        UIGraphicsEndImageContext()
    //        //        return newImage
    //    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        print("Picked image at url \(info)")
        
        let imageSelected = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        var imageMemorySize = UIImageJPEGRepresentation(imageSelected, 1.0)!.length
        println(imageMemorySize/1024)
        let size = self.profilePicBtn.frame.size
        
        let imageResized:UIImage = Utils.imageResize(imageSelected,sizeChange: size)
        imageMemorySize = UIImageJPEGRepresentation(imageResized, 1.0)!.length
        println(imageMemorySize/1024)
        
        self.profilePicBtn.setImage(imageResized, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewController(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        profilePicBtn.setImage(croppedImage, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewControllerDidCancel(controller: UIViewController!)
    {
        print("imageCropViewControllerDidCancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func showImageSourcesAction(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        let sourcesView: UIActionSheet = UIActionSheet(title: "Choose Image Source", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:"Photo Library", otherButtonTitles: "Camera")
        sourcesView.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch (buttonIndex)
        {
        case 0:
            print("0: Photo Library")
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        case 1:
            print("1: Cancel Action Sheet")
            
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
            print("Default")
        }
    }
    
    func addEmailSuccess(responseDict: AnyObject!)
    {
        print("addEmailSuccess : \(responseDict)")
    }
    
    func addEmailFailure(error: NSError?)
    {
        print("addEmailFailure : \(error)")
        UIAlertView(title: kAppName, message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func removeEmailSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        print("removeEmailSuccess : \(responseDict)")
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        switch (statusCode)
        {
        case 0:
            println("Success")
        case 100:
            alertMsg = "The provided email Id already exists in the system and cannot be added again."
            break
            
        case 101:
            alertMsg = "Invalid username or password."
            break
            
        case 102:
            alertMsg = "Profile Image is (either black and white or greyscale) and doesn't match our criteria for profile photo, the user needs to be taken to the profile completion page and asked to supply another image."
            break
            
        case 103:
            alertMsg = "When an update request is sent against a user who is inactive."
            break
            
        case 104:
            alertMsg = "When an update request is sent against a user who is unavailable."
            break
            
        case 105:
            alertMsg = "When the gender has been updated as part of the registration (via facebook) and the user has set the gender via the update request."
            break
            
        case 106:
            alertMsg = "When the user data contains invalid information, (eg., numbers in name)."
            break
            
        case 107:
            alertMsg = "Please enter valid username and password."
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
    
    func removeEmailFailure(error: NSError?)
    {
        print("removeEmailFailure : \(error)")
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "LocationViewSegue"
        {
            let controller =  segue.destinationViewController as! DBLLocationHandlerViewController
            controller.myProfileViewContorller = self
            controller.selectionFrom = "MyProfileView"
        }
        else if segue.identifier == "CropViewSegue"
        {
//            let navController: UINavigationController = segue.destinationViewController as! UINavigationController
//            let controller = navController.viewControllers[0] as! ImageCropperViewController
//            controller.delegate = self;
//            controller.image = self.image;
//            print(controller.imageView?.image)
        }
    }
    
    func showSelectedLocation(locationDetails: GMSAddress)
    {
        print("PICKKKSelectedLocation \(locationDetails)")
        
        let coordinate:CLLocationCoordinate2D = locationDetails.coordinate as CLLocationCoordinate2D
        self.showUserLocation(coordinate)
        
//        var addressList:NSArray = locationDetails.lines as NSArray
        
        addressLine1.text = locationDetails.thoroughfare
        
        addressLine2.text = locationDetails.subLocality
        
        cityInput.text = locationDetails.locality
        
        //btnSelectState.setTitle(locationDetails.administrativeArea , forState: UIControlState.Normal)
        
        
        if(locationDetails.administrativeArea != nil)
        {
            btnSelectState.setTitle(locationDetails.administrativeArea, forState: UIControlState.Normal)
        }
        else
        {
            btnSelectState.setTitle("Select State", forState: UIControlState.Normal)
        }
        
        country.text = locationDetails.country
        
        zipcode.text = locationDetails.postalCode
    }
    
    func showUserLocation(userLocationCor: CLLocationCoordinate2D)
    {
        
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D)
    {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        self.pickerHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.pickerHolder.frame.size.height)
        
        
        text = "textField"
        activeField = textField
//        createInputAccessoryView()
//        textField.inputAccessoryView = inputAccView
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        if (string.characters.count == 0)
        {
            return true
        }
        if (textField == mobileNo)
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
        if (textField == zipcode && textField.text!.characters.count > 4)
        {
            return false
        }
        return true
        
    }
    
    //    func textFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    //    {
    //
    //    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return false;
    }
    
    
    func isProfilePicChanged() -> Bool
    {
        if (currentUser.profilePic == profilePicBtn.imageForState(UIControlState.Normal))
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func isAddressChanged()-> Bool
    {
        print(currentUser.zipcode);
        print(zipcode);
        if (currentUser.addressLine1 == addressLine1.text && currentUser.addressLine2 == addressLine2.text && currentUser.city == cityInput.text && currentUser.country == country.text && (currentUser.state == btnSelectState.titleForState(UIControlState.Normal) || currentUser.state == "State") && (currentUser.zipcode == Int(zipcode.text!) || currentUser.zipcode == 0))
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func isMobileNumbeChanged()-> Bool
    {
        let validFormatPhno = mobileNo.text!.stringByReplacingOccurrencesOfString(
            "\\D", withString: "", options: .RegularExpressionSearch,
            range: mobileNo.text!.startIndex..<mobileNo.text!.endIndex)

        print(validFormatPhno);
        print(currentUser.phone);
        
        if currentUser.phone == validFormatPhno
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func isAboutMeChanged() -> Bool
    {
        if currentUser.aboutMe == aboutMeTxVw.text
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //MARK- UITextView Callback methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        text = "textView"
        activeTextView = textView
//        createInputAccessoryView()
//        textView.inputAccessoryView = inputAccView
        textView.returnKeyType = UIReturnKeyType.Default
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
        //        if(text == "\n")
        //        {
        //            if(activeTextView == aboutMeTxVw)
        //            {
        //                mobileNo.becomeFirstResponder()
        //                
        //            }
        //            return false
        //        }
        return true
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
