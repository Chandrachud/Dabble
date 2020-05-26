//
//  ViewController.swift
//  Dabble
//
//  Created by Reddy on 6/30/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//


import UIKit
import AssetsLibrary
import LocalAuthentication
enum MethodToMoveBack: Int
{
    case Pop // Came as Pushing
    case Dismiss // Came as Presenting
    case None // Came from Menu
}

class DBLLoginViewController: UIViewController , FBSDKLoginButtonDelegate, UITextFieldDelegate, DBLServicesResponsesDelegate, UIAlertViewDelegate, UITextViewDelegate
{
    @IBOutlet weak var lblIpAddress: UITextField!
    var loginType: String = String()
    var TIDUsername: String = String()
    var TIDPassword: String = String()
    
    var TIDFBUserID: String = String()
    var TIDFBAuthCode: String = String()
    var FBUserID: String = String()
    
    var FBAuthCode: String = String()
    var activeField: UITextField = UITextField()
    
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var userNameInput: UITextField!
    @IBOutlet var createAccBtnHolderView: UIView!
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    let fbLoginManager = FBSDKLoginManager()
    var Server = DBLServices()
    
    var activityIndicator :UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool)
    {
  
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
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
    
    @IBAction func loginWithFacebook(sender: AnyObject)
    {
        if Utils.isNetworkReachable() != true
        {
            self.showNetworkError()
            return
        }

        self.userNameInput.text = ""
        self.passwordInput.text = ""
        
        let fbUID : AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("FBUserID")
        let authCode: AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("FBAuthCode")
        
        if(fbUID != nil && authCode != nil)
        {
            FBUserID = NSUserDefaults.standardUserDefaults().valueForKey("FBUserID") as! String
            FBAuthCode = NSUserDefaults.standardUserDefaults().valueForKey("FBAuthCode") as! String
            println("FBUserID:::::  \(FBUserID) \n FBAuthCode:::::  \(FBAuthCode)")
            let postParams = ["authCode": FBAuthCode , "userID": FBUserID]
            self.Server.processLoginWithFacebook(postParams)                        
        }
        else
        {
            self.fbLoginManager.logOut();
            
            fbLoginManager.logInWithReadPermissions(self.facebookReadPermissions, fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil
                {
                    //According to Facebook:
                    //Errors will rarely occur in the typical login flow because the login dialog
                    //presented by Facebook via single sign on will guide the users to resolve any errors.
                    
                    // Process error
                    
                    print("Facebook 1 , Error: %@", error);
                    FBSDKLoginManager().logOut()
                    self.fbLoginManager.logOut();
                    //                failureBlock(error)
                }
                else if result.isCancelled
                {
                    // Handle cancellations
                    println("Facebook 2")
                    FBSDKLoginManager().logOut()
                    // failureBlock(nil)
                }
                else
                {
                    var allPermsGranted = true
                    println("Facebook 3")
                    let grantedPermissions = result.grantedPermissions
                    for permission in self.facebookReadPermissions
                    {
                        if !grantedPermissions.contains(permission)
                        {
                            allPermsGranted = false
                            println("Facebook 4")
                            break
                        }
                    }
                    if allPermsGranted
                    {
                        println("Facebook 5")
                        appDelegate.FBUserID = result.token.userID
                        let fbToken = result.token.tokenString
                        let fbUserID = result.token.userID
                        println("FBToken::::::: \(fbToken) \n FBUserID:::::: \(fbUserID) ")
                        NSUserDefaults.standardUserDefaults().setValue(fbUserID, forKey: "FBUserID")
                        NSUserDefaults.standardUserDefaults().setValue(fbToken , forKey: "FBAuthCode")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        let postParams = ["authCode": fbToken , "userID": fbUserID]
                        self.Server.processLoginWithFacebook(postParams)
                    }
                    else
                    {
                        println("Facebook 6")
                    }
                }
            })
            
//            fbLoginManager.logInWithReadPermissions(self.facebookReadPermissions, handler:
//                {
//                    (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
//                    if error != nil
//                    {
//                        //According to Facebook:
//                        //Errors will rarely occur in the typical login flow because the login dialog
//                        //presented by Facebook via single sign on will guide the users to resolve any errors.
//                        
//                        // Process error
//                        
//                        println("Facebook 1")
//                        FBSDKLoginManager().logOut()
//                        //                failureBlock(error)
//                    }
//                    else if result.isCancelled
//                    {
//                        // Handle cancellations
//                        println("Facebook 2")
//                        FBSDKLoginManager().logOut()
//                        // failureBlock(nil)
//                    }
//                    else
//                    {
//                        var allPermsGranted = true
//                        println("Facebook 3")
//                        let grantedPermissions = result.grantedPermissions
//                        for permission in self.facebookReadPermissions
//                        {
//                            if !grantedPermissions.contains(permission)
//                            {
//                                allPermsGranted = false
//                                println("Facebook 4")
//                                break
//                            }
//                        }
//                        if allPermsGranted
//                        {
//                            println("Facebook 5")
//                             appDelegate.FBUserID = result.token.userID
//                            let fbToken = result.token.tokenString
//                            let fbUserID = result.token.userID
//                            println("FBToken::::::: \(fbToken) \n FBUserID:::::: \(fbUserID) ")
//                            NSUserDefaults.standardUserDefaults().setValue(fbUserID, forKey: "FBUserID")
//                            NSUserDefaults.standardUserDefaults().setValue(fbToken , forKey: "FBAuthCode")
//                            NSUserDefaults.standardUserDefaults().synchronize()
//                            let postParams = ["authCode": fbToken , "userID": fbUserID]
//                            self.Server.processLoginWithFacebook(postParams)                                                        
//                        }
//                        else
//                        {
//                            println("Facebook 6")
//                        }
//                    }
//            })
        }
    }
    
    func loginWithFacebookSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        appDelegate.hideLoadingView()
        println("loginWithFacebookSuccess::::: \(responseDict)")
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            if statusCode == 107
            {
                self.returnUserData()
                return;
            }
            else if statusCode == 201
            {
                if currentUser == nil
                {
                    currentSubscription = Subscription()
                    currentUser = User()
                    DBManager = Dashboard()
                    currentJob = Job()
                }
                
                let payload = responseDict["payload"] as! NSDictionary
                currentUser.saveUserDetail(payload)
                alertMsg = "Your subscription has been expired, please subscribe to enjoy features."
                let alertView = UIAlertView(title: kAppName, message: alertMsg, delegate: self, cancelButtonTitle: "Cancel")
                alertView.addButtonWithTitle("Subscribe Now")
                alertView.show()
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
            
            println("Login success with response: \(responseDict)")
            
            if(responseDict["payload"] != nil && responseDict["payload"]!.isKindOfClass(NSDictionary))
            {                
                if currentUser == nil
                {
                    currentSubscription = Subscription()
                    currentUser = User()
                    DBManager = Dashboard()
                    currentJob = Job()
                }
                
                
                let loginId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginID) as? String
                let loginFbId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginFacebookId) as? String
                
                if loginId?.caseInsensitiveCompare(userNameInput.text!) == NSComparisonResult.OrderedSame
                {
                    
                }
                else if appDelegate.FBUserID == loginFbId
                {
                    
                }
                else
                {
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    realm.deleteAllObjects()
                    realm.commitWriteTransaction()
                }
                
                let payload = responseDict["payload"] as! NSDictionary
                currentUser.saveUserDetail(payload)
                println(appDelegate.FBUserID)
                NSUserDefaults.standardUserDefaults().setObject(appDelegate.FBUserID, forKey: kLoginFacebookId)
                NSUserDefaults.standardUserDefaults().synchronize()
                self.registerDeviceForPush()
                self.updateProfilePic()
                // Fix for
                NSNotificationCenter.defaultCenter().postNotificationName(kgetAllJobsNotification, object: nil)
                
                //loginType = kFacebookLogin
                NSUserDefaults.standardUserDefaults().setValue(kFacebookLogin, forKey: "TIDLogintype")
                NSUserDefaults.standardUserDefaults().setInteger(currentUser.userID, forKey: kUserID)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loginWithFacebookFailure(error: NSError?)
    {
        println("loginWithFacebookFailure::::: \(error)")
    }
    
    @IBAction func handleForgotPassword(sender: AnyObject)
    {
        self.userNameInput.text = ""
        self.passwordInput.text = ""
    }
    
    @IBAction func loginAction(sender: AnyObject)
    {
        if self.lblIpAddress.hidden != true
        {
            baseURL = self.lblIpAddress.text!
            println(baseURL)
        }

        var alertMsg: String!
        if userNameInput.text!.characters.count == 0
        {
            alertMsg = "Please enter a username"
        }
        else if passwordInput.text!.characters.count == 0
        {
            alertMsg = "Please enter a password"
        }
        else if Utils.isValidEmail(userNameInput.text!)
        {
            alertMsg = "Please enter a valid email"
        }
        else if passwordInput.text!.characters.count < 6
        {
            alertMsg = "Please enter a valid password"
        }
        
        if(alertMsg != nil)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        self.hideKeyboard()
        let postParams = ["login": userNameInput.text!, "password":passwordInput.text!]
        Server.processLogin(postParams)
    }
    
    func hideKeyboard()
    {
        userNameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    
    // MARK: Server calls Starts Here =====
    func loginSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        //appDelegate.showLoadingView(nil)
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                
            }
            else if statusCode == 201
            {
                if currentUser == nil
                {
                    currentSubscription = Subscription()
                    currentUser = User()
                    DBManager = Dashboard()
                    currentJob = Job()
                }
                println("Login success with response: \(responseDict)")
                currentUser.saveUserDetail(responseDict["payload"] as! NSDictionary)                
                alertMsg = "Your subscription has been expired, please subscribe to enjoy features."
                let alertView = UIAlertView(title: kAppName, message: alertMsg, delegate: self, cancelButtonTitle: "Cancel")
                alertView.addButtonWithTitle("Subscribe Now")
                alertView.show()
                return
            }
            else
            {
               alertMsg = Utils.statusMessageFor(statusCode)
                if alertMsg.characters.count != 0
                {
                    UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                    return
                }
                println("Default Case ")
            }
            
            println("Login success with response: \(responseDict)")
            if(responseDict["payload"] != nil)
            {
                let loginId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginID) as? String
                let loginFbId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginFacebookId) as? String

                if loginId?.caseInsensitiveCompare(userNameInput.text!) == NSComparisonResult.OrderedSame
                {
                    
                }
                else if FBUserID == loginFbId
                {
                    
                }
                else
                {
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    realm.deleteAllObjects()
                    realm.commitWriteTransaction()
                }
                
                let payload = responseDict["payload"] as! NSDictionary
                if currentUser == nil
                {
                    currentSubscription = Subscription()
                    currentUser = User()
                    DBManager = Dashboard()
                    currentJob = Job()
                }
                
                NSUserDefaults.standardUserDefaults().setObject(userNameInput.text, forKey: kLoginID)
                
                NSUserDefaults.standardUserDefaults().setObject(passwordInput.text, forKey: kLoginPassword)
                
                currentUser.saveUserDetail(payload)
                appDelegate.initiate()
                self.registerDeviceForPush()
                self.updateProfilePic()
                if (passwordInput.text!.characters.count != 0 && userNameInput.text!.characters.count != 0)
                {
                    //loginType = kCustomLogin
                    
                    NSUserDefaults.standardUserDefaults().setValue(kCustomLogin, forKey: "TIDLogintype")
                    NSUserDefaults.standardUserDefaults().setValue( userNameInput.text, forKey: "TIDUsername")
                    NSUserDefaults.standardUserDefaults().setValue( passwordInput.text, forKey: "TIDPassword")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }               
                NSNotificationCenter.defaultCenter().postNotificationName(kgetAllJobsNotification, object: nil)
            }
            NSUserDefaults.standardUserDefaults().setInteger(currentUser.userID, forKey: kUserID)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loginFailed(error: NSError?)
    {
        appDelegate.hideLoadingView()
        println("Login failed with error: \(error)")
        UIAlertView(title: kAppName, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        
    }
    
    func updateProfilePic()
    {
        Server.processFetchProfilePic(["userID": currentUser.userID])
    }
    
    // MARK: Server calls starts here
    func profilePicFetchSuccess(responseDict: AnyObject!)
    {
        println("profilePicFetchSuccess: \(responseDict)")
        if currentUser != nil
        {
            currentUser.profilePic = responseDict as! UIImage
        }
    }
    
    func profilePicFetchFailure(error: NSError?)
    {
        println("profilePicFetchFailure: \(error)")
        //  UIAlertView(title: kAppName, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func registerDeviceForPush()
    {
        if (appDelegate.myDeviceToken as String).characters.count != 0
        {
            let postParams = ["deviceToken": appDelegate.myDeviceToken, "deviceType":1]
            Server.processRegisterDeviceForPush(postParams)
        }
    }
    
    func registerDeviceForPushSuccess(responseDict: AnyObject!)
    {
        println("registerDeviveForPushSuccess")
    }
    
    func registerDeviceForPushFailure(error: NSError?)
    {
        println("registerDeviveForPushFailure")
    }

    func verifyUserExistenceSuccess(responseDict: AnyObject!)
    {
        println("verifyUserExistenceSuccess: \(responseDict)")
    }
    
    func verifyUserExistenceFailure(error: NSError?)
    {
        println("verifyUserExistenceFailure: \(error)")
        UIAlertView(title: kAppName, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    // MARK: Server calls Ends Here =====
    
    @IBAction func createAccountAction(sender: AnyObject)
    {
        self.userNameInput.text = ""
        self.passwordInput.text = ""
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //----------
    var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    func previousAction(sender : UITextField) {
        println("PreviousAction")
    }
    
    func nextAction(sender : UITextField) {
        println("nextAction")
    }
    
    func doneAction(sender : UITextField){
        println("doneAction")
    }
    
    func registerForKeyboardHandler()
    {
        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        returnKeyHandler.delegate = self        
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.Done
        returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.ByTag
    }
    
    // Declare below method in ViewDidLoad
    //  call self.registerForKeyboardHandler()
    //----------    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.registerForKeyboardHandler()
        
//        self.userNameInput.text = "dnreddy890@gmail.com"
//        self.passwordInput.text = "Dabble"
        
//        self.userNameInput.text = "rohit@fourvector.in"
//        self.passwordInput.text = "dabble"
        
//        self.userNameInput.text = "rovenjain@gmail.com"
//        self.passwordInput.text = "dabble"
        
//        self.userNameInput.text = "dev1@gmail.com"
//        self.passwordInput.text = "Password"
        
         let TIDLogintyp : AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("TIDLogintype")
        println("TIDLogintyp:::::  \(TIDLogintyp)  ")
        
        if(TIDLogintyp != nil)
        {
             loginType = NSUserDefaults.standardUserDefaults().valueForKey("TIDLogintype") as! String
             println("TIDLogintype:::::  \(loginType) ")
            
            if(loginType == kCustomLogin)
            {
                // Custom Login TouchID
                let TIDU : AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("TIDUsername")
                let TIDP: AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("TIDPassword")
                println("Username:::::  \(TIDU)  Password::::: \(TIDP)")
                
                if(TIDU != nil && TIDP != nil)
                {
                    TIDUsername = NSUserDefaults.standardUserDefaults().valueForKey("TIDUsername") as! String
                    TIDPassword = NSUserDefaults.standardUserDefaults().valueForKey("TIDPassword") as! String
                    println("TIDUsername:::::  \(TIDUsername)  TIDPassword::::: \(TIDPassword)")
                    self.authenticateUser()
                }
            }
            else if(loginType == kFacebookLogin)
            {
                // Facebook Login TouchID
                
                let fbUID : AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("FBUserID")
                let authCode: AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("FBAuthCode")
                
                println("FBUserID:::::  \(fbUID) \n FBAuthCode:::::  \(authCode) ")
                
                if(fbUID != nil && authCode != nil)
                {
                    TIDFBUserID = NSUserDefaults.standardUserDefaults().valueForKey("FBUserID") as! String
                    TIDFBAuthCode = NSUserDefaults.standardUserDefaults().valueForKey("FBAuthCode") as! String
                    println("TIDFBUserID:::::  \(TIDFBUserID) \n TIDFBAuthCode:::::  \(TIDFBAuthCode)")
                    self.authenticateUser()
                }
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        Server.delegate = self
        let placeholder = NSAttributedString(string: userNameInput.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor(red: 122.0/255.0, green: 122.0/255.0, blue: 122.0/255.0, alpha: 0.7)])
        userNameInput.attributedPlaceholder = placeholder;
        
        let pwdPlaceholder = NSAttributedString(string: passwordInput.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor(red: 122.0/255.0, green: 122.0/255.0, blue: 122.0/255.0, alpha: 0.7)])
        passwordInput.attributedPlaceholder = pwdPlaceholder;
        
        let isSmallIPhone :Bool = Utils.isSmallIPhone()
        
        if (isSmallIPhone)
        {
            
        }
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            println("User is already logged in")
        }
        else
        {
            println("User not logged in")
            //            loginView.readPermissions = ["public_profile", "email", "user_friends" , "user_about_me" , "user_location" , "user_birthdate"]
            //            loginView.delegate = self
        }
    }
   
    func authenticateUser()
    {
        
        //
        println(" \n TOUCH ID called ")
        
        
        
        // Get the local authentication context.
        if #available(iOS 8.0, *)
        {
            let context = LAContext()
            
            // Declare a NSError variable.
            var error: NSError?
            
            // Set the reason string that will appear on the authentication alert.
            var reasonString = "Authentication is needed to access your notes."
            
            // Check if the device can evaluate the policy.
            do {
                try context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
                [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply:
                    {
                        (success: Bool, evalPolicyError: NSError?) -> Void in
                        
                        if success
                        {
                            
                            println("SUCCESSSSSSSSSSSSSSS")
                            
                            
                            if(self.loginType == kCustomLogin)
                            {
                                var deviceToken = "1234567890987654321"
                                var postParams = ["login":self.TIDUsername, "password":self.TIDPassword, "deviceID":deviceToken]
                                self.Server.processLogin(postParams)
                                
                            }
                            else if(self.loginType == kFacebookLogin)
                            {
                                
                                var postParams = ["authCode": self.TIDFBAuthCode , "userID":self.TIDFBUserID]
                                self.Server.processLoginWithFacebook(postParams)
                            }
                        }
                        else
                        {
                            // If authentication failed then show a message to the console with a short description.
                            // In case that the error is a user fallback, then show the password alert view.
                            println(evalPolicyError?.localizedDescription)
                            
                            switch evalPolicyError!.code {
                                
                            case LAError.SystemCancel.rawValue:
                                println("Authentication was cancelled by the system")
                                
                                //appDelegate.showToastMessage(kAppName, message: "Authentication was cancelled by the system")
                                
                                
                            case LAError.UserCancel.rawValue:
                                println("Authentication was cancelled by the user")
                                //appDelegate.showToastMessage(kAppName, message:"Authentication was cancelled by the user")
                                
                            case LAError.UserFallback.rawValue:
                                println("User selected to enter custom password")
                                //appDelegate.showToastMessage(kAppName, message: "User selected to enter custom password")
                                
                                
                                // self.showPasswordAlert()
                                
                            default:
                                println("Authentication failed")
                                //appDelegate.showToastMessage(kAppName, message: "Authentication failed")
                                //self.showPasswordAlert()
                            }
                        }
                        
                })]
            } catch var error1 as NSError {
                error = error1
                // If the security policy cannot be evaluated then show a short message depending on the error.
                switch error!.code
                {
                    
                case LAError.TouchIDNotEnrolled.rawValue:
                    println("TouchID is not enrolled")
                    //appDelegate.showToastMessage(kAppName, message: "TouchID is not enrolled")
                    
                case LAError.PasscodeNotSet.rawValue:
                    println("A passcode has not been set")
                    //appDelegate.showToastMessage(kAppName, message: "A passcode has not been set")
                    
                default:
                    // The LAError.TouchIDNotAvailable case.
                    println("TouchID not available")
                    //appDelegate.showToastMessage(kAppName, message: "TouchID not available")
                }
                
                // Optionally the error description can be displayed on the console.
                println(error?.localizedDescription)
                
                // Show the custom alert view to allow users to enter the password.
                //self.showPasswordAlert()
            }
        }
        else
        {
            println("Not iOS 8.")
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        println("User Logged In")
        
        println(FBSDKAccessToken.currentAccessToken())
        
        println(FBSDKAccessToken.currentAccessToken().userID)
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled
        {
            // Handle cancellations
        }
        else
        {
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            println(result.grantedPermissions)
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        println("User Logged Out")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData()-> Void
    {
        let params = ["fields": "email, first_name, gender, last_name, location"]
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler(
            {
                (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    println("Error: \(error)")
                    //                let alertView = UIAlertView(title: "", message: "Unable to fetch information form Facebook, Please try again", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil, nil)
                }
                else
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let createAccountVC = storyBoard.instantiateViewControllerWithIdentifier("CreateAccountView") as! DBLCreateAccountViewController
                    
                    println("fetched user: \(result)")
                    var firstName : String!
                    var userMail: String!
                    var gender: String!
                    
                    if  (result.valueForKey("first_name") != nil)
                    {
                        firstName = result.valueForKey("first_name") as! String
                        createAccountVC.firstName = firstName
                    }
                    if  (result.valueForKey("last_name") != nil)
                    {
                        firstName = result.valueForKey("last_name") as! String
                        createAccountVC.lastName = firstName
                    }
                    if  (result.valueForKey("email") != nil)
                    {
                        userMail = result.valueForKey("email") as! String
                        createAccountVC.emailID = userMail
                    }
                    if  (result.valueForKey("gender") != nil)
                    {
                        gender = result.valueForKey("gender") as! String
                        createAccountVC.gender = gender
                    }
                    
                    var imageData :NSData = NSData();
                    let userID: NSString = result.valueForKey("id") as! NSString
                    let imageURL = "http://graph.facebook.com/\(userID)/picture?type=large"
                    createAccountVC.imageURL = imageURL
                    println(imageURL)
                    self.presentViewController(createAccountVC, animated: true, completion: nil)
                }
        })
    }
    
    func showNetworkError()
    {
        UIAlertView(title: "Network Error", message: "Please check your internet connection and try again.", delegate: nil, cancelButtonTitle: "OK").show()
    }

    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        activeField = textField
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        let nextTag:Int = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        let nResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        println("Tag : \(nextResponder)  nextTag:\(nextTag) nextTagMobileNo: \(nResponder)")
        if (nextTag == passwordInput.tag+1)
        {
            textField.resignFirstResponder()
            self.loginAction(self)
        }
        else
        {
            nextResponder.becomeFirstResponder()
        }
        return false;
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }
}

// Methods to Enable / Disable Log.

func println(object: Any)
{
//    print(object)
}

func print(object: Any)
{
    
}

