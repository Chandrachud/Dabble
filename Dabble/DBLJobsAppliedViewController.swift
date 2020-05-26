//
//  DBLJobsAppliedViewController.swift
//  Dabble
//
//  Created by Reddy on 7/23/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLJobsAppliedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DBLServicesResponsesDelegate
{
    var Server = DBLServices()
    var distanceInMiles:Float = Float()
    @IBOutlet weak var myJobsListView: UITableView!
    var myJobsArray = NSMutableArray()
    
    @IBAction func moveBack(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.delegate = self
        Server.processFetchJobsIApplied()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool)
    {
//        Server.processFetchJobsIApplied()
    }
    
    func fetchJobsAppliedByMeSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
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
        
        if myJobsArray.count != 0
        {
            myJobsArray.removeAllObjects()
        }
        
        myJobsArray = NSMutableArray(array:responseDict["payload"] as! NSArray)

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
        
        */
        
//        myJobsArray.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
        
//        var allJobs = responseDict["payload"] as! NSArray
//        var validJobs = NSMutableArray()
//        
//        var i = allJobs.count
//        var j = 0
//
//        var k = 0
//        var l = 0
//        
//        var tempBids = NSArray()
//        var tempJob = NSDictionary()
//        var bid = NSDictionary()
//        
//        for j = 0; j < i ; j++
//        {
//            tempJob = allJobs.objectAtIndex(j) as! NSDictionary
//            if (tempJob["status"] as! Int == 0)
//            {
//                tempBids = tempJob["bids"] as! NSArray
//                
//                k = tempBids.count
//                
//                for l = 0 ; l < k ; l++
//                {
//                    bid = tempBids.objectAtIndex(l) as! NSDictionary
//                    if (bid["status"] as! Int == 0 && bid["bidderId"] as! Int == currentUser.userID)
//                    {
//                        myJobsArray.addObject(tempJob)
//                        break
//                    }
//                }
//            }
//        }
        
//        myJobsArray.removeObjectIdenticalTo(myJobsArray[0])
//        myJobsArray.removeObjectsInRange(NSMakeRange(0, myJobsArray.count - 1))
//        print("all Valid Jobs are : \(myJobsArray)")
        myJobsListView.reloadData()
    }
    
    func fetchJobsAppliedByMeFailure(error: NSError?)
    {
        println("error is: \(error)")
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
        var jobCell : UITableViewCell? = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell!)!
        if (jobCell == nil)
        {
            jobCell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier)
        }

        jobCell?.selectionStyle = UITableViewCellSelectionStyle.None
        let tempJob = myJobsArray[indexPath.row] as! NSDictionary
        let bgImageView = jobCell?.contentView.viewWithTag(1) as! UIImageView
        Utils.addCornerRadius(bgImageView)
       
        if tempJob["status"] as! Int == 5
        {
            jobCell?.userInteractionEnabled = false
        }
        
        let jobTitle = jobCell?.contentView.viewWithTag(2) as! UILabel
        let jobDescription = jobCell?.contentView.viewWithTag(3) as! UITextView
        let jobCreatedDate = jobCell?.contentView.viewWithTag(4) as! UILabel
        let jobStatusLbl = jobCell?.contentView.viewWithTag(5) as! UILabel
//        let acceptBtn = jobCell?.contentView.viewWithTag(10) as! UIButton
//
//        Utils.addCornerRadius(acceptBtn)
//        
//        if tempJob["status"] as! Int == 4
//        {
//            acceptBtn.hidden = false
//            acceptBtn.badgeValue = "\(indexPath.row)"
//            acceptBtn.badgeBGColor = UIColor.clearColor()
//            acceptBtn.badgeTextColor = UIColor.clearColor()
//        }
//        else
//        {
//            acceptBtn.hidden = true
//        }        
        
        jobStatusLbl.text = String(format: "Status: %@", Utils.jobStatusMessage(tempJob["status"] as! Int))
        let timeInterval: NSTimeInterval =  tempJob["startDate"] as! NSTimeInterval
        
        let date = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        println("Date is : \(date)")
        
        jobTitle.text = tempJob["jobTitle"] as? String
        jobDescription.text = tempJob["description"] as! String
        
        let jobDistance:UIButton = jobCell?.contentView.viewWithTag(6) as! UIButton
        if(appDelegate.currentLocation != nil)
        {
            let lat:Double = tempJob.valueForKey("lat") as! Double
            let lon:Double = tempJob.valueForKey("lng") as! Double
            //println("LAT $ LON: \(lat) \(lon)")
            let distance:Float =   findDistancewithLatitiude(lat, longitide: lon)
            jobDistance.setTitle(String(format: "%.1f Miles", distance), forState: UIControlState.Normal)
        }

        if (tempJob["startDate"] != nil)
        {
            let ti = NSDate(timeIntervalSince1970: (tempJob["startDate"] as! NSTimeInterval)/1000)
            let dateFormatter = Utils.getDateFormatterForFormat("dd-MMM-yyyy")
            let dateString = dateFormatter.stringFromDate(ObjcUtils.toGlobalTime(ti))
            println("Temp job is : \(tempJob)")
            jobCreatedDate.text = String(format: "Job Starts: %@", dateString)
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

        return jobCell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        println("didSelectRowAtIndexPath")
    }
    
    
    func findDistancewithLatitiude(latitide:Double, longitide:Double) ->Float
    {
        let lat: CLLocationDegrees = latitide
        let long: CLLocationDegrees = longitide
        
        let jobLocation: CLLocation = CLLocation(latitude: lat,
            longitude: long)
        
        let distanceInMeters:CLLocationDistance = jobLocation.distanceFromLocation(appDelegate.usersLocation)
        //println("DistanceInMts: \(distanceInMeters)")
        //println("DistanceInKM: \(distanceInKM)")
        
        distanceInMiles = Float (distanceInMeters * 0.000621371192)
        println("DistanceInMiles: \(distanceInMiles)")
        return distanceInMiles
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {        
        
        if segue!.identifier == "FeedbackViewSegue"
        {
            
            let feedbackViewController =  segue!.destinationViewController as! DBLFeedbackViewController
            //            feedbackViewController.bidderId = "\(bidderId)"
            
            let senderIsTableviewCell:Bool! = sender?.isKindOfClass(UIButton)
            if (senderIsTableviewCell == true)
            {
                let row = Int((sender?.badgeValue)!)
                let thisJob = myJobsArray[row!] as! NSDictionary
                feedbackViewController.sourceView = kSourceJobsApplied
                currentJob.saveJob(thisJob)
                return
            }
        }
        
//        if segue!.identifier == "showJobDetailsSegue"
//        {
        
            let distanceButton:UIButton = sender?.viewWithTag(6) as! UIButton
            let distanceInMiles:String = distanceButton.titleLabel!.text!
            
            let indexPath = self.myJobsListView.indexPathForSelectedRow
        
            currentJob.saveJob(myJobsArray[indexPath!.row] as! NSDictionary)
            currentJob.jobDistance =  String(format: "%@", distanceInMiles)
            currentJob.sourceView = kSourceJobsApplied
            
        //}
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
