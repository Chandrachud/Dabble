//
//  ForgetPasswordViewController.swift
//  Dabble
//
//  Created by Reddy on 7/20/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController, UITextViewDelegate, DBLServicesResponsesDelegate
{
    @IBOutlet var emailInput: UITextField!
    var Server = DBLServices()
    
    var inputAccView:UIView = UIView()
     var activeField: UITextField = UITextField()
    
    @IBOutlet var fPassScrollerView: UIScrollView!
    @IBOutlet var scrollItemsHolder: UIView!
    
    func DismissKeyboard(){
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        Server.delegate = self
        
                self.fPassScrollerView.contentSize = CGSizeMake(scrollItemsHolder.frame.size.width, scrollItemsHolder.frame.size.height )
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }
    
    func createInputAccessoryView()
    {
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
        
        inputAccView.addSubview(doneButton);
        
        let cancelButton = UIButton(frame:CGRectMake(10,0,70,40))
        cancelButton.setTitle("Done", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleLabel!.font = UIFont(name: fn, size: 15)
        cancelButton.addTarget(self, action: "buttonAccessoryCancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        //inputAccView.addSubview(cancelButton);
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

    @IBAction func backToLogin(sender: AnyObject){
        activeField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendNewPwdAction(sender: UIButton)
    {
        activeField.resignFirstResponder()
        emailInput.resignFirstResponder()
        var isValidEmailFormat = Utils.isValidEmail(emailInput.text!)
        var alertMsg = ""
        if emailInput.text!.characters.count == 0
        {
           alertMsg = "Please enter an email"
       }
        else if isValidEmailFormat
        {
            alertMsg = "Please enter a valid email"
        }
        
        if alertMsg.characters.count != 0
        {
           UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        var postParams = ["email": emailInput.text!]
        Server.processForgotPassword(postParams)
      
        
        
       
        
        
//        let manager = AFHTTPRequestOperationManager()
//        let requestSerializer = AFJSONRequestSerializer()
//        manager.requestSerializer = requestSerializer
//        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField:"Content-Type")
//        
//        let url = "\(baseURL)\(urlForgorPassword)"+"dnreddy890@gmail.com"
//       
//        manager.POST(url, parameters:nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//                println("Yes thies was a success \n  response is :\(responseObject)")
//            },
//            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
//                println("We got an error here.. \(error.localizedDescription)")
//        })
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        activeField = textField
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendNewPasswordSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        print("sendNewPasswordSuccess success with: \(responseDict)")
        
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
        
        if alertMsg.characters.count != 0
        {
            UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return;
        }
        
        let message = responseDict["message"] as! String!
        
        if (message == "SUCCESS")
        {
            print("Move user to VerificationViewController")
                       
            appDelegate.showToastMessage("Verify", message: "A new verification code has been sent to your email")
            
            let verifyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PasswordVerificationView") as! DBLVerifyPasswordViewController
            verifyViewController.userEmail = emailInput.text!
            self.presentViewController(verifyViewController, animated: true, completion: nil)            
        }
    }
    
    func sendNewPasswordFailed(error: NSError?)
    {
        print("sendNewPasswordFailed with Error: \(error)")
        UIAlertView(title: kAppName, message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: UITextFieldDelegate methods
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    //    {
    //
    //    }
//    func textFieldDidBeginEditing(textField: UITextField) // became first responder
//    {
//        
//        createInputAccessoryView()
//        textField.inputAccessoryView = inputAccView
//        activeField = textField
//    }
    //
    //
    //    func textFieldShouldEndEditing(textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    //    {
    //
    //    }
    //    func textFieldDidEndEditing(textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    //    {
    //
    //    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
//    {
//        if (count(string) == 0)
//        {
//            return true
//        }
//        
//        if (textField == mobileNumberInput && count(textField.text) > 9)
//        {
//            return false
//        }
//        return true
//        
//    }
    //    func textFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    //    {
    //
    //    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
//    {
//        
//        var nextTag:Int = textField.tag+1
//        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
//        let nResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
//        
//        print("Tag : \(nextResponder)  nextTag:\(nextTag) nextTagMobileNo: \(nResponder)")
//        if (nextTag == mobileNumberInput.tag+1)
//        {
//            
//            textField.resignFirstResponder()
//        }
//        else
//        {
//            nextResponder.becomeFirstResponder()
//        }
//        return false;
//        
//        
//    }

}
