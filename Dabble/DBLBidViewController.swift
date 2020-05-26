//
//  DBLBidViewController.swift
//  Dabble
//
//  Created by Reddy on 7/13/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

@objc protocol BidViewDelegate
{
    func didInitiateChatWithId(id:Int)
}

class DBLBidViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,DBLServicesResponsesDelegate,MGSwipeTableCellDelegate
{
    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet weak var btnAddBid: UIButton!
    @IBOutlet var estimatedCostLbl: UILabel!
    @IBOutlet var estimateCostLbl: UILabel!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var bidValueBtn: UIButton!
    var bidsArray:NSMutableArray = NSMutableArray()
    var numberOfBids:Int!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    // var jobImage:UIImage = UIImage()
    
    // var bidJobDetails:NSDictionary = NSDictionary()
    //    var bidsArray = NSMutableArray()
    var Server = DBLServices()
    var dblBidDetailViewController = DBLBidDetailViewController()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var delegate: BidViewDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Server.delegate = self
        estimatedCostLbl.text = "Estimated cost: \(currentJob.amount) \(currentJob.currency)"
        // numberOfBids = currentJob.validBids.count
        
        if currentJob.volunteersEnabled == true
        {
            lblHeaderTitle.text = "Volunteers"
            btnAddBid.setTitle("Volunteer", forState: UIControlState.Normal)
        }
        else if currentJob.isEvent == "1"
        {
            lblHeaderTitle.text = "Attendees"
            btnAddBid.setTitle("Attend", forState: UIControlState.Normal)
        }
        //        for bid in currentJob.bids
        //        {
        //            bidsArray.addObject(bid)
        //        }
        Server.delegate = self
    }
    
    @IBAction func processAttendEvent(sender: UIButton?)
    {
        if sender!.titleForState(UIControlState.Normal) == "Attend" || sender!.titleForState(UIControlState.Normal) == "Volunteer"
        {
            let postParams = ["amount":"0.0" ,"currency": "USD" ,"comment": "","jobId": currentJob.jobId]
            Server.processAttendForAnEvent(postParams)
        }
    }
    
    func attendingEventSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if responseDict.count != 0
        {
            if responseDict["code"] as! Int == 0
            {
                currentJob.isEdited = YES // To refresh in Home page
                appDelegate.showToastMessage("Success", message: "You are successfully registered for an event.")
                btnAddBid.hidden = true
                DBManager.jobsBidFor = DBManager.jobsBidFor + 1
                
                let bids: NSArray = responseDict["payload"] as! NSArray
                println("Bids are : \(bids)")
                currentJob.bids = bids
                println("Bids are : \(currentJob.bids)")
                self.navigationController?.popViewControllerAnimated(true)
                //                self.populateJobDetails()
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
    
    @IBAction func addBidAction(sender: UIButton)
    {
        if sender.titleForState(UIControlState.Normal) == "Volunteer" || sender.titleForState(UIControlState.Normal) == "Attend"
        {
            self.processAttendEvent(nil)
        }
        else
        {
            
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if currentJob.sourceView == kSourceJobsCreated
        {
            self.btnAddBid.hidden = true
        }
        else
        {
            let bids :NSArray = currentJob.valueForKey("bids") as! NSArray
            
            var bidderId = 0
            var bid: NSDictionary
            
            for item in bids
            {
                bid = item as! NSDictionary
                
                bidderId = bid["bidderId"] as! Int
                if ((bidderId == currentUser.userID) && (currentJob.isEvent == "1" || currentJob.volunteersEnabled == true) && bid["status"] as! Int != kJobRetracted)
                {
                    self.btnAddBid.hidden = true
                }
            }
        }
        if bidsArray.count != 0
        {
            bidsArray.removeAllObjects()
        }
        //        bidsArray.addObjectsFromArray(currentJob.bids as NSArray as [AnyObject])
        
        let i = currentJob.bids.count
        var j = 0
        for j = 0; j < i ; j++
        {
            let bidsDict: NSDictionary = currentJob.bids.objectAtIndex(j) as! NSDictionary
            if (bidsDict["status"] as! Int == 0 || bidsDict["status"] as! Int == kJobAccepted)//|| bidsDict["status"] as! Int == 4
            {
                if bidsDict["bidderId"] as! Int == currentUser.userID && currentJob.isEvent == "1"
                {
                    btnAddBid.hidden = true
                }
                bidsArray.addObject(bidsDict)
            }
        }
        if currentJob.jobStatus == kJobAccepted || currentJob.jobStatus == kJobPendingApproval
        {
            btnAddBid.hidden = true
        }
        myTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        myTableView.setEditing(false, animated: true)
    }
    
    @IBAction func backToJobDetail(sender: UIButton)
    {
        if currentJob.sourceView == kSourceJobsCreated
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.allowsMultipleSelectionDuringEditing = true
        return bidsArray.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellIdentifier : String = "BidCell";
        if currentJob.volunteersEnabled == true || currentJob.isEvent == "1"
        {
            cellIdentifier = "VolunteerCell"
        }
        else
        {
            cellIdentifier = "BidCell"
        }
        
        var bidCell: MGSwipeTableCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MGSwipeTableCell
        if (bidCell == nil)
        {
            bidCell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier) as! MGSwipeTableCell
        }
        bidCell.delegate = self
        let bidDictionary = bidsArray.objectAtIndex(indexPath.row) as! NSDictionary
        let bidderProfilePic:UIImageView = bidCell?.contentView.viewWithTag(1) as! UIImageView
        let bidderName:UILabel = bidCell?.contentView.viewWithTag(2) as! UILabel
        let jobsCompleted:UILabel = bidCell?.contentView.viewWithTag(4) as! UILabel
        //        let bidderRating:UIButton = bidCell?.contentView.viewWithTag(5) as! UIButton
        
        let bidValue:UILabel = bidCell?.contentView.viewWithTag(7) as! UILabel
        let bidderID = bidDictionary.valueForKey("bidderId") as? Int
        
        Utils.addCornerRadius(bidderProfilePic)
        if(currentJob.sourceView == kSourceJobsCreated)
        {
            bidderProfilePic.image = UIImage(named: "avatar.png")
            bidderName.text = bidDictionary.valueForKey("bidderName") as? String
            let imageURL = String(format: urlUserProfile, bidderID!)
            self.downloadImage(imageURL, imageView: bidderProfilePic)
            jobsCompleted.text =  String(format: "Status: %@", Utils.jobStatusMessage(bidDictionary["status"] as! Int))
        }
        else if(currentJob.sourceView == kSourceSearchJobs || currentJob.sourceView == kSourceJobsApplied)
        {
            if bidderID == currentUser.userID
            {
                //TODO change the profile image
//                bidderProfilePic.image = currentUser.profilePic
                bidderProfilePic.image = UIImage(named: "avatar.png")

                bidderName.text = bidDictionary.valueForKey("bidderName") as? String
                jobsCompleted.text =  String(format: "Status: %@", Utils.jobStatusMessage(bidDictionary["status"] as! Int))
                //                    bidderRating.hidden = false
                Utils.addCornerRadius(bidderProfilePic)
            }
            else
            {
                bidderProfilePic.image = UIImage(named: "avatar.png")
                bidderName.text = "XXXXXXXXXX"
                jobsCompleted.text = "XXXXXXXXXXXXXX"
                //                bidderRating.hidden = true
            }
        }
        let amount: String = (bidDictionary.valueForKey("amount") as! NSNumber).stringValue
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
            bidValue.attributedText = Utils.getAttributedLabel((myStringArr [0] as NSString).integerValue, cents: cents, currency:
                bidDictionary.valueForKey("currency") as! String)
        }
        else
        {
            bidValue.attributedText = Utils.getAttributedLabel(Int(amount)!, cents: 00, currency: bidDictionary.valueForKey("currency") as! String)
        }
        
        if currentJob.jobStatus == kJobAccepted
        {
            if bidDictionary["status"] as! Int == kJobAccepted
            {
                bidCell?.userInteractionEnabled = true
            }
            else
            {
                bidCell?.userInteractionEnabled = false
            }
        }
        //        else if currentJob.jobStatus == kJobAccepted && currentJob.volunteersEnabled != true
        //        {
        //
        //        }
        
        if bidderID == currentUser.userID && bidDictionary["status"] as! Int != kJobAccepted
        {
            bidCell.rightButtons = [MGSwipeButton(title: "Chat", icon: UIImage(named:"check.png"), backgroundColor: UIColor.redColor()),MGSwipeButton(title: "Accept", icon: UIImage(named:"check.png"), backgroundColor:primaryColorOfApp)]
        }
        else
        {
            bidCell.rightButtons = [MGSwipeButton(title: "Chat", icon: UIImage(named:"check.png"), backgroundColor: UIColor.purpleColor())]
        }
        return bidCell!;
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        let cellIndex = myTableView.indexPathForCell(cell)?.row
        let bidDictionary = bidsArray.objectAtIndex(cellIndex!) as! NSDictionary
        let bidderID = bidDictionary.valueForKey("bidderId") as? Int
        if bidderID == currentUser.userID && bidDictionary["status"] as! Int != kJobAccepted
        {
            if index == 0
            {
                let bidID: AnyObject? = bidsArray[cellIndex!]["bidId"]
                let postParams = ["bidId":bidID as! Int]
                
                Server.processAcceptBid(postParams)
                Server.bidID = bidID as! Int
            }
            else
            {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.delegate?.didInitiateChatWithId(bidderID!)
                })
            }
        }
            
        else
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.delegate?.didInitiateChatWithId(bidderID!)
            })
        }
        return true
    }
    
    func downloadImage(url: String, imageView: UIImageView)
    {
        ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
            imageView.image = image
            
        })
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    {
        return "Retract"
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    //    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    //
    //        let bidDictionary = bidsArray.objectAtIndex(indexPath.row) as! NSDictionary
    //        let bidderID = bidDictionary.valueForKey("bidderId") as? Int
    //        if bidderID == currentUser.userID && bidDictionary["status"] as! Int != kJobAccepted
    //        {
    //            return UITableViewCellEditingStyle.Delete
    //        }
    //        return UITableViewCellEditingStyle.None
    //    }
    
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    //    {
    //        if (editingStyle == UITableViewCellEditingStyle.Delete)
    //        {
    //            //            var bidDictionary = bidsArray.objectAtIndex(indexPath.row) as! NSDictionary
    //
    //            println("Delete Bid form the list.")
    //            // appDelegate.showToastMessage("TODO", message: "Call processRetractBid service to delete Bid.")
    //            let bidID: AnyObject? = bidsArray[indexPath.row]["bidId"]
    //            let postParams = ["bidId":bidID as! Int]
    //
    //            Server.processRetractBid(postParams)
    //            Server.bidID = bidID as! Int
    //            _ = indexPath.row
    //            //            bidsArray.removeObjectAtIndex(indexPath.row)
    //            tableView.reloadData()
    //        }
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if currentJob.sourceView == kSourceJobsApplied
        {
            dblBidDetailViewController.bidDetails = bidsArray.objectAtIndex(indexPath.row) as! NSDictionary
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            let bidderPic = selectedCell?.contentView.viewWithTag(1) as! UIImageView
            dblBidDetailViewController.profilePicHolder = bidderPic.image!
            self.performSegueWithIdentifier("showBidDetails", sender: self)
        }
    }
    
    func bidAcceptSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if(responseDict.count != 0)
        {
            let message = responseDict["message"] as! String
            if(message == "SUCCESS")
            {
                if currentJob.volunteersEnabled == true
                {
                    appDelegate.showToastMessage(kAppName, message: "You have accepted the RSVP")
                }
                else
                {
                    appDelegate.showToastMessage(kAppName, message: "You have accepted the bid")
                }
            }
        }
    }
    
    func bidAcceptFailure(error: NSError)
    {
        appDelegate.showToastMessage("Failure", message: error.description)
    }
    
    func bidRetractSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("bidRetractSuccess: \(responseDict)")
        if(responseDict.count != 0)
        {
            currentJob.isEdited = YES // To refresh in Home page
            println("createJobSuccess \(responseDict)")
            
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
        }
        
        if(responseDict.count != 0)
        {
            let message = responseDict["message"] as! String
            
            if(message == "SUCCESS")
            {
                var alertMsg = "You have successfully removed your bid"
                if currentJob.volunteersEnabled == true
                {
                    alertMsg = "You have successfully withdrawn your volunteership."
                }
                appDelegate.showToastMessage(kAppName, message:alertMsg)
                
                if bidsArray.count != 0
                {
                    bidsArray.removeAllObjects()
                }
                
                let bids = responseDict["payload"] as! NSArray
                let i = bids.count
                var j = 0
                for j = 0; j < i ; j++
                {
                    let bidsDict: NSDictionary = bids.objectAtIndex(j) as! NSDictionary
                    if (bidsDict["status"] as! Int == kJobActive)
                    {
                        bidsArray.addObject(bidsDict)
                    }
                }
                if bidsArray.count != 0
                {
                    currentJob.bids = bidsArray
                }
                currentJob.isEdited = YES
                println("Service executed successfully.")
                DBManager.jobsBidFor = DBManager.jobsBidFor - 1
                
                myTableView.reloadData()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else
            {
                appDelegate.showToastMessage("Failed", message:message)
            }
        }
        
    }
    
    func bidRetractFailure(error:NSError?)
    {
        println("bidRetractFailure \(error)")
        appDelegate.showToastMessage("Error", message: "Failed to remove bid. Please try again")
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        println("shouldPerformSegueWithIdentifier : \(identifier)")
        if (sender?.isKindOfClass(UIButton) == true)
        {
            if (identifier == "addBidSegue" && sender?.titleForState(UIControlState.Normal) == "Volunteer") || sender?.titleForState(UIControlState.Normal) == "Attend"
            {
                return false
            }
        }
        else
            if(identifier == "addBidSegue")
            {
                return true
            }
            else if(identifier == "showBidDetails" && currentJob.sourceView == kSourceJobsCreated)
            {
                return true
            }
            else if(identifier == "showBidDetails" && (currentJob.sourceView == kSourceSearchJobs || currentJob.sourceView == kSourceJobsApplied))
            {
                let indexPath = self.myTableView.indexPathForSelectedRow
                let bidDictionary = bidsArray.objectAtIndex(indexPath!.row) as! NSDictionary
                let bidderID = bidDictionary.valueForKey("bidderId") as? Int
                
                if( bidderID == currentUser.userID )
                {
                    return true
                }
                else
                {
                    return false
                }
        }
        return true
    }
    
    func fetchBidListSuccess(responseObj: AnyObject)
    {
        let responseDict = responseObj as! NSDictionary
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        
        if statusCode == 0
        {
            let bids = responseDict["payload"] as! NSArray
            let i = bids.count
            var j = 0
            for j = 0; j < i ; j++
            {
                let bidsDict: NSDictionary = bids.objectAtIndex(j) as! NSDictionary
                if (bidsDict["status"] as! Int == 0)
                {
                    bidsArray.addObject(bidsDict)
                }
            }
            myTableView.reloadData()
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
    
    func fetchBidListFailure(error: NSError) {
        
        appDelegate.showToastMessage(kAppName, message: "Bids were not retrieved, please try again")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if (segue.identifier == "addBidSegue")
        {
            //viewController.addJobDetails = bidJobDetails
        }
        
        if segue.identifier == "showBidDetails"
        {
            dblBidDetailViewController = segue.destinationViewController as! DBLBidDetailViewController
            
            //            dblBidDetailViewController.bidDetails = currentJob.bids[indexPath!.row] as! NSDictionary
            //            dblBidDetailViewController.jobImage = jobImage
            
        }
    }
}
