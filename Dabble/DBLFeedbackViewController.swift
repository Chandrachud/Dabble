//
//  FeedbackViewController.swift
//  Dabble
//
//  Created by Reddy on 7/4/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLFeedbackViewController: UIViewController, DBLServicesResponsesDelegate, FloatRatingViewDelegate
{
    @IBOutlet weak var userInfoHolder: UIView!
    @IBOutlet var ratingDisplay: UILabel!
    @IBOutlet weak var commentTxVw: UITextView!
    @IBOutlet weak var btnPostComment: UIButton!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var sourceView = NSString()
    
    @IBOutlet weak var jobTitle: UILabel!
    var Server = DBLServices()
    var rating = 1

    var bidderId = 0
    var jobId = 0
    var posterId = 0

    @IBOutlet weak var bidderImage: UIImageView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBAction func postComment(sender: AnyObject)
    {
        if commentTxVw.text.characters.count == 0 || commentTxVw.text == "Enter comment"
        {            appDelegate.showToastMessage("Feedback", message: "Please enter some feedback")
            return
        }
        if sourceView == kSourceJobsApplied
        {
            let postParams = ["comment": commentTxVw.text , "rating": "\(rating)", "commentee": posterId , "jobId": jobId]
          Server.processSendFeedbackToPoster(postParams)
        }
        else
        {
            let postParams = ["comment": commentTxVw.text , "rating": "\(rating)", "commentee": bidderId , "jobId": jobId]
            Server.processSendFeedbackToBidder(postParams)
        }
    }
    
    @IBAction func moveBack(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateRating(myRating: Float)
    {
        self.floatRatingView.emptyImage = UIImage(named: "Star0")
        self.floatRatingView.fullImage = UIImage(named: "Star1")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.delegate = self
        self.floatRatingView.rating = myRating
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Server.delegate = self
        Utils.addCornerRadius(commentTxVw)
        Utils.addCornerRadius(userInfoHolder)
        Utils.addCornerRadius(bidderImage)
        Utils.addCornerRadius(btnPostComment)
        self.updateRating(1.0)
        if sourceView == kSourceJobsCreated
        {
            println(currentJob.jobTitle)
            self.jobId =  currentJob.jobId
            self.bidderId = self.getAcceptedBidderId()
            self.lblName.text = self.getAcceptedBidderName()
            self.jobTitle.text = currentJob.jobTitle            
            let imageURL = String(format: urlUserProfile, self.bidderId)
            self.downloadImage(imageURL, imageView: profilePic)
            headingLbl.text = "Job done by"
        }
        else
        {
            self.jobId = currentJob.jobId
            self.posterId = currentJob.posterId
            self.lblName.text = currentJob.posterName
            self.jobTitle.text = currentJob.jobTitle
            let imageURL = String(format: urlUserProfile, self.posterId)
            self.downloadImage(imageURL, imageView: profilePic)
            headingLbl.text = "Job posted by"
        }
        
        if commentTxVw.text == ""
        {
            commentTxVw.text = "Enter comment"
            commentTxVw.textColor = UIColor.lightGrayColor()
        }
    }
    
    func downloadImage(url: String, imageView: UIImageView)
    {
        ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
            imageView.image = image

        })
    }
    
    func getAcceptedBidderId () -> Int
    {
        var tempBids = NSArray()
        var bid = NSDictionary()
        
        tempBids = currentJob.bids
        let k = tempBids.count
        var l = 0
        for l = 0 ; l < k ; l++
        {
            bid = tempBids.objectAtIndex(l) as! NSDictionary
            if (bid["status"] as! Int == 4)
            {
                return bid["bidderId"] as! Int
            }
        }
        return 0
    }
    
    func getAcceptedBidderName () -> String
    {
        var tempBids = NSArray()
        var bid = NSDictionary()
        
        tempBids = currentJob.bids
        let k = tempBids.count
        var l = 0
        for l = 0 ; l < k ; l++
        {
            bid = tempBids.objectAtIndex(l) as! NSDictionary
            return bid["bidderName"] as! String
        }
        return "Bidder Name"
    }
        
    override func viewWillAppear(animated: Bool)
    {
        println("\(posterId) - \(jobId) - \(bidderId)")
    }    
    
    func writeFeedbackSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("writeFeedbackSuccess");
        
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
            appDelegate.showToastMessage(kAppName, message: "Your feedback was successfully posted")
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

    func writeFeedbackFailure(error: NSError?)
    {
        println("writeFeedbackFailure");
        appDelegate.showToastMessage(kAppName, message: "Your feedback did not post, please try again")
    }
    
    //MARK- TextViewDelegates 
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == "Enter comment"
        {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text == ""
        {
            textView.text = "Enter comment"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        commentTxVw.resignFirstResponder()
    }
    
    //MARK: FloatRatingView delegate methods
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float)
    {
        self.ratingDisplay.text = NSString(format: "%i/5", Int(self.floatRatingView.rating)) as String
        self.rating = Int(self.floatRatingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float)
    {
        self.ratingDisplay.text = NSString(format: "%i/5", Int(self.floatRatingView.rating)) as String
        self.rating = Int(self.floatRatingView.rating)
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
