//
//  AddBidViewController.swift
//  Dabble
//
//  Created by Reddy on 7/13/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLAddBidViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,DBLServicesResponsesDelegate, UIGestureRecognizerDelegate
{
    var addJobDetails:NSDictionary = NSDictionary()
    @IBOutlet var addBidScroll: UIScrollView!
    @IBOutlet var scrollItemsHolder: UIView!
    
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet weak var lblBidCost: UILabel!
    @IBOutlet weak var lblChatCountDisplay: UILabel!
    
    //    @IBOutlet var CategoryTitle: UILabel!
    @IBOutlet var jobCreatedDate: UILabel!
    
    @IBOutlet var estimatedCostLbl: UILabel!
    @IBOutlet var currencyLbl: UILabel!
    
    @IBOutlet var bidValueInput: UITextField!
    @IBOutlet var bidComment: UITextView!
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet var charLeftStr: UILabel!
    
    @IBOutlet weak var viewHeaderTitle: UILabel!
    var Server = DBLServices()
    
    @IBOutlet weak var btnAddBid: UIButton!
    var activeField: UITextField = UITextField()
    var activeTextView: UITextView =  UITextView()
    var text: String = String()
    
    @IBAction func backToBidList(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addBidAction(sender: AnyObject)
    {
        activeField.resignFirstResponder()
        activeTextView.resignFirstResponder()
        
        var alertMsg :String!
        
        if bidValueInput.text!.characters.count == 0 && currentJob.volunteersEnabled != true
        {
            alertMsg = "Please enter a bid amount"
        }
        else if (bidValueInput.text! as NSString).doubleValue <= 0.0 && currentJob.volunteersEnabled != true
        {
            alertMsg = "A bid has to be greater than zero"
        }
        
        if (alertMsg != nil)
        {
            UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        var comment = self.bidComment.text!
        comment = comment.stringByReplacingOccurrencesOfString("\n", withString: kNewLineChar)
        
        let postParams = ["amount":"\((bidValueInput.text! as NSString).doubleValue)" ,"currency": "USD" ,"comment":comment, "jobId": currentJob.jobId ]
        Server.processCreateBid(postParams)
    }
    
    func bidCreateSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("bidCreateSuccess: \(responseDict)")
        
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            currentJob.isEdited = YES
            println("Service executed successfully.")
            
             // If user is adding the bid against the job he already bided.
            if currentJob.sourceView != kSourceJobsApplied
            {
                DBManager.jobsBidFor = DBManager.jobsBidFor + 1
            }
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
        
        if(responseDict.count != 0)
        {
            let message = responseDict["message"] as! String
            if(message == "SUCCESS")
            {
                var alertMsg = "Your bid was successfully submitted"
                if currentJob.volunteersEnabled == true
                {
                    alertMsg = "Thank you for volunteering, the poster will contact you"
                }
                appDelegate.showToastMessage(kAppName, message:alertMsg)
                let bids: NSArray = responseDict["payload"] as! NSArray
                println("Bids are : \(bids)")
                currentJob.bids = bids
                println("Bids are : \(currentJob.bids)")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func bidCreateFailure(error: NSError)
    {
        println("bidCreateFailure \(error)")
        error.code
        Utils.getErrorMessageForFailureCode(error.code)
        appDelegate.showToastMessage("Failure", message: "Your bid failed to post, please try again")
    }
    
    func  subscriptionIsExpired()
    {
//        appDelegate.showToastMessage("Expired", message: "Your subscription has been expired, please subscribe to enjoy features.")
//        self.performSegueWithIdentifier("SubscriptionsViewSegue", sender: self)
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
        self.registerForKeyboardHandler()
        Server.delegate = self
        Utils.addCornerRadius(bidComment)
        Utils.addCornerRadius(currencyLbl)
        
        if currentJob.volunteersEnabled == true
        {
            currencyLbl.hidden = true
            bidValueInput.hidden = true
            lblBidCost.hidden = true
            viewHeaderTitle.text = "Volunteer"
            btnAddBid.setTitle("Become Volunteer", forState: UIControlState.Normal)
            lblComment.frame = lblBidCost.frame
            bidComment.frame = CGRectMake(bidComment.frame.origin.x, currencyLbl.frame.origin.y, bidComment.frame.size.width, bidComment.frame.size.height)
            lblChatCountDisplay.frame = CGRectMake(lblChatCountDisplay.frame.origin.x, bidComment.frame.origin.y + bidComment.frame.size.height + 5, lblChatCountDisplay.frame.size.width, lblChatCountDisplay.frame.size.height)                                    
        }
        
        // Do any additional setup after loading the view.
        println("After Sending  addJobDetails : \(addJobDetails)")
        self.addBidScroll.contentSize = CGSizeMake(self.view.frame.size.width, scrollItemsHolder.frame.size.height)
        
        populateDetails()
    }
    
    func populateDetails()
    {
        jobTitle.text = currentJob.jobTitle // addJobDetails.valueForKey("jobTitle") as? String
        
        estimatedCostLbl.text = "Estimated cost: \(currentJob.amount) \(currentJob.currency)"
        
        if ((currentJob.createdDate) != nil)
        {
            let ti = NSDate(timeIntervalSince1970: (currentJob.createdDate)/1000)
            let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
            let dateString = dateFormatter.stringFromDate(ObjcUtils.toGlobalTime(ti))
            jobCreatedDate.text = String(format: "Created Date: %@",dateString)
        }
        
        
        //        estimateCostLbl.text = "\(currentJob.amount)"// (currentJob.amount as NSNumber).stringValue //(addJobDetails.valueForKey("amount") as! NSNumber).stringValue
        //        currencyLbl.text = currentJob.currency // addJobDetails.valueForKey("currency") as? String
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        bidComment.resignFirstResponder()
        bidValueInput.resignFirstResponder()
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
        if(text == "textField" && activeField == bidValueInput)
        {
            bidComment.becomeFirstResponder()
        }
        else
        {
            activeField.resignFirstResponder()
            activeTextView.resignFirstResponder()
        }
    }

    func textFieldDidBeginEditing(textField: UITextField) // became first responder
    {
        text = "textField"
        activeField = textField
    }
    
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
        {
            if textField == bidValueInput
            {
                let countdots = textField.text!.componentsSeparatedByString(".").count - 1
                if countdots > 0 && string == "."
                {
                    return false
                }
            }
            return true
        }
    
    func textFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        
        textField.resignFirstResponder()
        return true;
        
        //        var nextTag:Int = textField.tag+1
        //        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        //
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
        
        
    }
    
    //MARK: UITextViewDelegate methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        text = "textView"
        activeTextView = textView
        textView.returnKeyType = UIReturnKeyType.Default
        return true
    }    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if textView.text.characters.count > 500 && text.characters.count != 0
        {
            return false
        }
        
        charLeftStr.text = "\(500 - textView.text.characters.count) Characters Remaining"
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    }
}
