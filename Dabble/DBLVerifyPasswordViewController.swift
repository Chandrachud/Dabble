//
//  DBLVerifiPasswordViewController.swift
//  Dabble
//
//  Created by Reddy on 8/3/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLVerifyPasswordViewController: UIViewController, UITextFieldDelegate, DBLServicesResponsesDelegate, UIAlertViewDelegate, UITextViewDelegate
{
    @IBOutlet var reenterNewPwdInput: UITextField!
    @IBOutlet var verifyCodeInput: UITextField!
    @IBOutlet var newPasswordInput: UITextField!
    
    var userEmail: String = ""
    @IBOutlet weak var btnVerifyPwd: UIButton!
    var inputAccView:UIView = UIView()
    var activeField: UITextField = UITextField()
    
    @IBOutlet var verifyPassScrollerView: UIScrollView!
    @IBOutlet var scrollItemsHolder: UIView!
    
    var Server = DBLServices()
    @IBAction func cancelVerification(sender: UIButton)
    {
        activeField.resignFirstResponder()
        UIAlertView(title: "Verify Password", message: "Are you sure want to cancel resetting password?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "YES").show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        switch (buttonIndex)
        {
        case 0:
            print("Not sure")
            break
        case 1:
            print("Sure")
            //            self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        default:
            print("Default case")
        }
    }
    
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
        Server.delegate = self;
        Utils.addCornerRadius(btnVerifyPwd)
        self.verifyPassScrollerView.contentSize = CGSizeMake(scrollItemsHolder.frame.size.width, scrollItemsHolder.frame.size.height )
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    
    override func viewDidAppear(animated: Bool)
    {
    
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let info: NSDictionary  = notification.userInfo!
        let KeyBoardSize = info.valueForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
        
        var activeTextOrigin : CGPoint = self.activeField.frame.origin
        var activeTextHeight : CGFloat = self.activeField.frame.size.height
        
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= KeyBoardSize!.height
        
        let inputViewHeight = inputAccView.frame.size.height as CGFloat
        
        if (!CGRectContainsPoint(visibleRect, activeTextOrigin) )
        {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeTextOrigin.y - visibleRect.height + activeTextHeight + inputViewHeight+50)
            verifyPassScrollerView.setContentOffset(scrollPoint, animated: true)
        }
        
        
    }
    func keyboardWillHide(notification: NSNotification)
    {
        // accountScrollerView.setContentOffset(CGPointZero, animated: true)
        
        
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        verifyPassScrollerView.contentInset = contentInsets
        verifyPassScrollerView.scrollIndicatorInsets = contentInsets
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verifyPassword(sender: UIButton)
    {
        activeField.resignFirstResponder()
        var alertMsg :String!
        if verifyCodeInput.text!.characters.count != 6
        {
            alertMsg = "Please enter proper Verification Code."
        }
        if newPasswordInput.text!.characters.count < 6 || reenterNewPwdInput.text!.characters.count < 6
        {
            alertMsg = "Password length must be greater than or equal to 6 characters."
        }
        else if newPasswordInput.text! != reenterNewPwdInput.text!
        {
            alertMsg = "Password and Confirm Passwords are mismatch."
        }
        if (alertMsg != nil)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        newPasswordInput.resignFirstResponder()
        reenterNewPwdInput.resignFirstResponder()
        var postParams = ["pin": verifyCodeInput.text!, "newPassword":"\(newPasswordInput.text!)","email":userEmail]
        Server.processPasswordVerification(postParams)
    }
    
    func passwordVerificationSuccess(responseObj: AnyObject)
    {
        let responseDict = responseObj as! NSDictionary
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            alertMsg = "Your password has been successfully updated, log in to continue"
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            self.presentingViewController?.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
            return;
        }
        else
        {
            alertMsg = responseDict["message"] as! String
            if alertMsg.characters.count != 0
            {
                UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                return;
            }
            println("Default Case ")
        }
    }
    
    func passwprdVerificationFailure(error: NSError)
    {
        UIAlertView(title: "Failed", message:"Failed to verify password, please try again", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //        textField.resignFirstResponder()
        //        return true
        
        
        let nextTag:Int = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        let nResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        print("Tag : \(nextResponder)  nextTag:\(nextTag) nextTagMobileNo: \(nResponder)")
        if (nextTag == reenterNewPwdInput.tag+1)
        {
            
            textField.resignFirstResponder()
        }
        else
        {
            nextResponder.becomeFirstResponder()
        }
        return false;
        
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
    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        activeField = textField        
    }
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
    
    
}
