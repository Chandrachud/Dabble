//
//  DBLJobsCreatedViewController.swift
//  Dabble
//
//  Created by Reddy on 7/23/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLJobsCreatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DBLServicesResponsesDelegate,MGSwipeTableCellDelegate,BidViewDelegate
 {
    @IBOutlet weak var numberOfBids: UILabel!
    @IBOutlet weak var myJobsListView: UITableView!
     var distanceInMiles:Float = Float()
    var Server = DBLServices()
    var myJobsArray = NSMutableArray()
    var tempJob: NSDictionary!
    @IBAction func moveBack(sender: UIButton) {        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.delegate = self
        Server.processFetchMyJobs()
        // Do any additional setup after loading the view.
    }
    
    override  func viewWillAppear(animated: Bool)
    {
        if currentJob.isEdited == YES
        {
            Server.processFetchMyJobs()
        }
    }
    
    func fetchMyJobsSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("Fetched all My Jobs: \(responseDict)")
        
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        if statusCode == 0
        {
            if myJobsArray.count != 0
            {
                myJobsArray.removeAllObjects()
            }
            myJobsArray =  NSMutableArray(array:responseDict["payload"] as! NSArray)
            
            /*
            let myBids: NSMutableArray =  NSMutableArray(array:responseDict["payload"] as! NSArray)
            
            var obj: NSDictionary
            for item in myBids
            {
                obj = item as! NSDictionary
                
                if obj["status"] as! Int == kJobActive
                {
                    myJobsArray.addObject(obj)
                }
            }            
            myBids.removeObjectsInArray(myJobsArray as [AnyObject])
            
            for item in myBids
            {
                obj = item as! NSDictionary
                if obj["status"] as! Int == kJobPending
                {
                    myJobsArray.addObject(obj)
                }
            }
            myBids.removeObjectsInArray(myJobsArray as [AnyObject])
            
            for item in myBids
            {
                obj = item as! NSDictionary
                if obj["status"] as! Int == kJobAccepted
                {
                    myJobsArray.addObject(obj)
                }
            }
            myBids.removeObjectsInArray(myJobsArray as [AnyObject])            
            myJobsArray.addObjectsFromArray(myBids as [AnyObject])
            
            myJobsArray.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
            */
            myJobsListView.reloadData()
            print(myJobsArray)
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
        
//        if myJobsArray.count != 0
//        {
//            myJobsArray.removeAllObjects()
//        }
//        myJobsArray.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
//        myJobsListView.reloadData()
    }
    
    func fetchMyJobsFailure(error: NSError?)
    {
        println("Failed to fetch all My Jobs: \(error)")
        UIAlertView(title: "Failed", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
    }
    
    func openChatView(identifier:String)
    {
        let messageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Message") as! MessageController
        let chatOp = ChatOperations()
        let chat = chatOp.fetchChatWithIdentifier(identifier, isGroupedChat: false, groupChatId: currentJob.posterName)
        messageController.chat = chat;
        println(chat)
        self.navigationController?.pushViewController(messageController, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myJobsArray.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier : String = "JobCell";
//        var jobCell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell!
//        if (jobCell == nil)
//        {
//            jobCell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier)
//        }
//        jobCell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        var jobCell: MGSwipeTableCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MGSwipeTableCell
        
        if jobCell == nil {
            tableView.registerNib(UINib(nibName: "JobCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            jobCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MGSwipeTableCell
        }
        jobCell.delegate = self

        tempJob = myJobsArray[indexPath.row] as! NSDictionary
        println("Temp Job is : \(tempJob)")
        let bgImageView = jobCell?.contentView.viewWithTag(1) as! UIImageView
        Utils.addCornerRadius(bgImageView)
        
        let jobTitle = jobCell?.contentView.viewWithTag(2) as! UILabel
        let jobDescription = jobCell?.contentView.viewWithTag(3) as! UITextView
        let jobCreatedDate = jobCell?.contentView.viewWithTag(4) as! UILabel
        let jobStatusLbl = jobCell?.contentView.viewWithTag(5) as! UILabel
        let noOfBids = jobCell?.contentView.viewWithTag(6) as! UILabel
        let lblBids = jobCell?.contentView.viewWithTag(9) as! UILabel
        let acceptBtn = jobCell?.contentView.viewWithTag(10) as! UIButton
        
        if tempJob["status"] as! Int == 9
        {
            acceptBtn.hidden = false
            noOfBids.hidden = true
            lblBids.hidden = true
            acceptBtn.badgeValue = "\(indexPath.row)"
            acceptBtn.badgeBGColor = UIColor.clearColor()
            acceptBtn.badgeTextColor = UIColor.clearColor()
        }
        else
        {
            acceptBtn.hidden = true
            noOfBids.hidden = false
            lblBids.hidden = false
        }
        
        let jobDistance:UIButton = jobCell?.contentView.viewWithTag(7) as! UIButton
        if(appDelegate.currentLocation != nil)
        {
            let lat:Double = tempJob.valueForKey("lat") as! Double
            let lon:Double = tempJob.valueForKey("lng") as! Double
            //println("LAT $ LON: \(lat) \(lon)")
            let distance:Float =   findDistancewithLatitiude(lat, longitide: lon)
            jobDistance.setTitle(String(format: "%.1f Miles", distance), forState: UIControlState.Normal)
        }

        jobStatusLbl.text = String(format: "Status: %@", Utils.jobStatusMessage(tempJob["status"] as! Int))
        
        if tempJob["status"] as! Int == kJobCompleted || tempJob["status"] as! Int == kJobRetracted
        {
            println("Completed job is :\(tempJob)")
            jobCell?.userInteractionEnabled = false
        }
        else
        {
            jobCell?.userInteractionEnabled = true
        }
        
        jobTitle.text = tempJob["jobTitle"] as? String
        jobDescription.text = tempJob["description"] as! String

        if (tempJob["createdDate"] != nil) //startDate
        {
            let ti = NSDate(timeIntervalSince1970: (tempJob["createdDate"] as! NSTimeInterval)/1000)
            let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
            let dateString = dateFormatter.stringFromDate(ObjcUtils.toGlobalTime(ti))
            println("Temp job is : \(tempJob)")
            jobCreatedDate.text = String(format: "Job Created: %@", dateString)
        }
        
        if (tempJob["event"] as! String) == "1"
        {
            println("--------------------It is an event.")
            lblBids.text = "Attendees"
        }
        else if (tempJob["volunteers"] as! Int) == 1
        {
            println("--------------------It is job")
            lblBids.text = "Volunteers"
        }
        else
        {
            println("--------------------Non volunteered job.")
            lblBids.text = "Bids"
        }
        
        if tempJob["event"] as! String == "1"
        {
            jobTitle.textColor = kEventTitleColor
        }
        if tempJob["event"] as! String == "0"
        {
            jobTitle.textColor = kJobTitleColor
        }
        
        if tempJob["event"] as! String == "2"
        {
            jobTitle.textColor = UIColor.greenColor()
        }

        
        noOfBids.text = String(format:"%i", self.getNoOfValidBids(tempJob["bids"] as! NSArray))
        
        
        //        let tempJob = myJobsArray[indexPath.row] as! NSDictionary
        jobCell.rightButtons = [MGSwipeButton(title: "Retract", backgroundColor: UIColor.redColor())]
        jobCell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D

        let tempBids = self.getNoOfValidBids(tempJob["bids"] as! NSArray) //tempJob["bids"] as! NSArray
        if tempJob["status"] as! Int == kJobActive && tempBids == 0 && !(tempJob["event"] as! String == "1")
        {
            jobCell.rightButtons = [MGSwipeButton(title: "Retract", backgroundColor: UIColor.redColor())]
            jobCell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        }

         if tempJob["status"] as! Int == kJobActive && tempBids == 1 && !(tempJob["event"] as! String == "1")
        {
        jobCell.rightButtons = [MGSwipeButton(title: "Accept", icon: UIImage(named:"check.png"), backgroundColor:primaryColorOfApp)]
            jobCell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        }

         if tempJob["status"] as! Int == kJobAccepted && !(tempJob["event"] as! String == "1")
        {
            jobCell.rightButtons = [MGSwipeButton(title: "Chat", icon: UIImage(named:"chat"), backgroundColor: UIColor.purpleColor())]
            jobCell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D

        }
        return jobCell!;
    }
    
    func getNoOfValidBids(allBids: NSArray) -> NSInteger
    {
        var l = 0
        let k = allBids.count
        var bid: NSDictionary!
        var validBids = 0
        for l = 0 ; l < k ; l++
        {
            bid = allBids[l] as! NSDictionary
            if (bid["status"] as! Int == 0 || bid["status"] as! Int == 4)// || bid["status"] as! Int == 4
            {
                validBids++
            }
        }
        return validBids
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let job = myJobsArray[indexPath.row] as! NSDictionary
        currentJob.saveJob(job)
        currentJob.sourceView = kSourceJobsCreated
        self.performSegueWithIdentifier("showBids", sender: self)
        println("didSelectRowAtIndexPath")
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
//    {
//        return true
//    }
    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
//    {
//        let tempJob = myJobsArray[indexPath.row] as! NSDictionary
//        if tempJob["status"] as! Int == kJobActive
//        {
//            let tempBids = tempJob["bids"] as! NSArray
//            if (tempBids.count == 1)
//            {
//                
//            }
//            return UITableViewCellEditingStyle.Delete
//        }
//        else
//        {
//            return UITableViewCellEditingStyle.None
//        }
//    }
    
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        let indexPath = myJobsListView.indexPathForCell(cell)?.row
        let job = myJobsArray[indexPath!] as! NSDictionary
         let tempBids = self.getNoOfValidBids(job["bids"] as! NSArray) //tempJob["bids"] as! NSArray


        if job["status"] as! Int == kJobActive && tempBids == 0
        {
            let postParams: NSDictionary = ["jobId" : job.valueForKey("jobId") as! Int]
            Server.processRetractJob(postParams)

        }
        else if job["status"] as! Int == kJobActive && tempBids == 1
        {
            let bidsArray = job["bids"] as? NSArray
            let bid = bidsArray?.objectAtIndex(0) as! NSDictionary
            let bidID = bid["bidId"]
            let postParams: NSDictionary = ["bidId": bidID as! Int]
            appDelegate.showLoadingView("")
            self.Server.processAcceptBid(postParams)

        }
        else if job["status"] as! Int == kJobAccepted
        {
            currentJob.saveJob(job)
//            let messageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Message") as! MessageController
//            let tempBidderId = self.getAcceptedBidderId(job) 
//            let identifier =  "\(tempBidderId)"
//            let chatOp = ChatOperations()
//            let chat = chatOp.fetchChatWithIdentifier(identifier, isGroupedChat: false, groupChatId: currentJob.posterName)
//            messageController.chat = chat;
//            println(chat)
//            self.navigationController?.pushViewController(messageController, animated: true)
            let tempBidderId = self.getAcceptedBidderId(job)
            let identifier =  "\(tempBidderId)"

            self.openChatView(identifier)
        }
        
//        let indexPath = myJobsListView.indexPathForCell(cell)?.row
//        let job = myJobsArray[indexPath!] as! NSDictionary
//        switch (index)
//        {
//        case 0:
//            
//            if job["status"] as! Int == kJobActive
//            {
//                let postParams: NSDictionary = ["jobId" : job.valueForKey("jobId") as! Int]
//                Server.processRetractJob(postParams)
//            }
//
//            break
//            
//        case 1:
//        print("Chat Button")
//            break
//            
//        case 2:
//            let bidsArray = job["bids"] as? NSArray
//            let bid = bidsArray?.objectAtIndex(0) as! NSDictionary
//            let bidID = bid["bidId"]
//            let postParams: NSDictionary = ["bidId": bidID as! Int]
//            appDelegate.showLoadingView("")
//            self.Server.processAcceptBid(postParams)
//
//            break
//        default:
//
//            break
//        }
        
        return true
    }

//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
//    {
//        if (editingStyle == UITableViewCellEditingStyle.Delete)
//        {
////            myJobsArray.removeObjectAtIndex(indexPath.row)
////            print(myJobsArray[indexPath.row])
////            tempJob = myJobsArray[indexPath.row] as! NSDictionary
//            let postParams: NSDictionary = ["jobId" : tempJob.valueForKey("jobId") as! Int]
//            Server.processRetractJob(postParams)
//        }
//    }
    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
//    {
//        return "Retract"
//    }
    
    func retractJobSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        let statusCode = responseDict["code"] as! Int
        var alertMsg = ""
        if statusCode == 0
        {
            appDelegate.showToastMessage(kAppName, message: "You successfully retracted your job")
            if myJobsArray.count != 0
            {
                myJobsArray.removeAllObjects()
            }            
            myJobsArray.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
            myJobsListView.reloadData()
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
        
        

//        print("Rectract job success: \(responseDict)")
//        appDelegate.showToastMessage(kAppName, message: "Job retracted successfully.")
//        if myJobsArray.count != 0
//        {
//            myJobsArray.removeAllObjects()
//        }
//        
//        myJobsArray.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
//        myJobsListView.reloadData()        
    }
    
    func retractJobFailure(error: NSError?)
    {
        appDelegate.showToastMessage(kAppName, message: "Failed to retract job at this time, please try again later.")
        println("Retract job failure \(error)")
    }
    
    
    func findDistancewithLatitiude(latitide:Double, longitide:Double) ->Float
    {
        let lat: CLLocationDegrees = latitide
        let long: CLLocationDegrees = longitide
        
        let jobLocation: CLLocation = CLLocation(latitude: lat,
            longitude: long)
        
        let distanceInMeters:CLLocationDistance = jobLocation.distanceFromLocation(appDelegate.usersLocation)
        //println("DistanceInMts: \(distanceInMeters)")
        var distanceInKM:Float = Float (distanceInMeters/1000)
        //println("DistanceInKM: \(distanceInKM)")
        
        distanceInMiles = Float (distanceInMeters * 0.000621371192)
         println("DistanceInMiles: \(distanceInMiles)")
        return distanceInMiles
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {
        if segue!.identifier == "showJobDetailsSegue"
        {
            
            let distanceButton:UIButton = sender?.viewWithTag(7) as! UIButton
            let distanceInMiles:String = distanceButton.titleLabel!.text!
            
            let indexPath = self.myJobsListView.indexPathForSelectedRow
             
            currentJob.saveJob(myJobsArray[indexPath!.row] as! NSDictionary)
            currentJob.jobDistance = String(format: "%@", distanceInMiles)
            currentJob.sourceView = kSourceJobsCreated
            
        }
        else if segue!.identifier == "FeedbackViewSegue"
        {
            
            let feedbackViewController =  segue!.destinationViewController as! DBLFeedbackViewController
            let senderIsTableviewCell:Bool! = sender?.isKindOfClass(UIButton)
            if (senderIsTableviewCell == true)
            {
                let row = Int((sender?.badgeValue)!)
                let thisJob = myJobsArray[row!] as! NSDictionary
                feedbackViewController.sourceView = kSourceJobsCreated
                currentJob.saveJob(thisJob)
            }
        }
        else if segue!.identifier == "showBids"
        {
            let bidCont =  segue!.destinationViewController as! DBLBidViewController
            bidCont.delegate = self
        }
    }

    func getAcceptedBidderId (currentJob: NSDictionary) -> Int
    {
        var tempBids = NSArray()
        var tempJob = NSDictionary()
        var bid = NSDictionary()
        
        tempBids = currentJob["bids"] as! NSArray
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


    func bidAcceptSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                var alertMsg = "You have accepted the bid"
//                if currentJob.isEvent == "1" //|| currentJob.volunteersEnabled == true
//                {
//                    alertMsg = "You have accepted the RSVP"
//                }
                appDelegate.showToastMessage(kAppName, message: alertMsg)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else if statusCode == 201
            {
                self.subscriptionIsExpired()
            }
            else
            {
                alertMsg = responseDict["message"] as! String
                if alertMsg.characters.count != 0
                {
                    UIAlertView(title: kAppName, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                    return;
                }
            }
        }
    }
    
    func bidAcceptFailure(error: NSError)
    {
        appDelegate.showToastMessage(kAppName, message: error.description)
    }

    func  subscriptionIsExpired()
    {
        
    }

    func didInitiateChatWithId(id: Int) {
        
        let identifier = String(id)
        self.openChatView(identifier)
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
