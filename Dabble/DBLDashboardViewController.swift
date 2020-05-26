//
//  DBLDashboardViewController.swift
//  Dabble
//
//  Created by Reddy on 7/16/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

let kLoginSuccessNotification = "LoginSuccessNotification"
let kProfilePicNotification = "ProfilePicNotification"

class DBLDashboardViewController: UIViewController, DBLServicesResponsesDelegate
{
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var itemsHolderview: UIView!
    @IBOutlet var btnCompletedForMe: UIButton!
    @IBOutlet var btnCompletedByMe: UIButton!
    @IBOutlet var jobsCreated: UIButton!
    @IBOutlet var jobsApplied: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var loaddView: UIView = UIView()
    var indicator = UIActivityIndicatorView()
    var jCompletedForMeView: ProgressCirlceView!
    var jCompletedByMeView: ProgressCirlceView!
    
    var Server = DBLServices()
    let a = 0
    var dashboardDict = NSDictionary()
    
    @IBAction func showMenu(sender: AnyObject)
    {
        let mainVC = self.mainSlideMenu()
        mainVC.openLeftMenu()
    }
    
    @IBAction func moveTohome(sender: AnyObject)
    {
//        var mainVC = self.mainSlideMenu()
//        var indexPath = NSIndexPath(forRow: 1, inSection: 0)
//      var  segueIdentifier =  mainVC.segueIdentifierForIndexPathInLeftMenu(indexPath)
//      
//        if (segueIdentifier != nil && count(segueIdentifier) > 0)
//        {
//            self.performSegueWithIdentifier(segueIdentifier, sender: self)
//        }
        
    }
    
    @IBAction func backBtnAction(sender: UIButton)
    {
//       // self.navigationController?.popViewControllerAnimated(true)
//        var HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("dblHomeViewController") as! DBLHomeViewController
//        
//        HomeViewController.fromDashboard = true
//        self.navigationController?.pushViewController(HomeViewController, animated: true)

        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
       // self.uploadAssetForJob()
        
        userProfilePic.layer.cornerRadius = userProfilePic.frame.size.height/2.0
        userProfilePic.layer.borderColor = UIColor.grayColor().CGColor
        userProfilePic.layer.masksToBounds = true
        userProfilePic.layer.borderWidth = 1.0
        
        Server.delegate = self
        self.fetchUserDetails()
        
        jobsCompletedByMe(0, title: "0%")
        jobsCompletedForMe(0, title: "0%")
        // Do any additional setup after loading the view.
    }
    
    func updateRating(myRating: Float)
    {
        self.floatRatingView.emptyImage = UIImage(named: "Star0")
        self.floatRatingView.fullImage = UIImage(named: "Star1")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = myRating
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = true
    }
        

    override func viewWillAppear(animated: Bool)
    {
        self.userProfilePic.image = currentUser.profilePic
        name.text="\(currentUser.firstName) \(currentUser.lastName)"
        address.text="\(currentUser.city) , \(currentUser.state)"
        
        // For refreshing dashboard data
        updateDashboard()
    }
    
//    func updateRating(rating: Double)
//    {
//        var tempButton: UIButton!
//        
//        for var i = 1; i<=5; i++
//        {
//            tempButton = self.view.viewWithTag(i) as? UIButton
//            if (i <= rating)
//            {
//                tempButton?.setImage(UIImage(named: "Star1"), forState: UIControlState.Normal)
//            }
//            else
//            {
//                tempButton?.setImage(UIImage(named: "Star0"), forState: UIControlState.Normal)
//            }
//        }
//    }
    
    func fetchUserDetails()
    {
        Server.processFetchUserDetails(["userID": (currentUser.userID)])
    }
    
    func userDetailFetchSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        appDelegate.hideLoadingView()
        
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                if(responseDict["payload"] != nil)
                {
                    dashboardDict = responseDict["payload"] as! NSDictionary
                    DBManager.saveDashboardData(dashboardDict)
                    self.updateDashboard()
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
            
//            if(responseDict["payload"] != nil)
//            {
//                dashboardDict = responseDict["payload"] as! NSDictionary
//                self.updateDashboard()
//            }
        }
    }
    
    func userDetailFetchFailure(error: NSError?)
    {
        appDelegate.hideLoadingView()
        
        println("userDetailFetchFailure: \(error)")
        UIAlertView(title: kAppName, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }

    func updateDashboardfromLogin(notification : NSNotification)
    {
        println("userdashboardLOGINNNNNN: \(notification.userInfo)")
        
        let dashboardDictLogin: NSDictionary = notification.userInfo!
        
        let jobsBidFor:Float=dashboardDictLogin["jobsBidFor"] as! Float
        let jobsBidAndCompleted:Float=dashboardDictLogin["jobsBidAndCompleted"] as! Float
        //var jobsAppliedFor:Float=dashboardDict["jobsAppliedFor"] as! Float
        let jobsBidAndInProgress:Float=dashboardDictLogin["jobsBidAndInProgress"] as! Float
        let jobsWon:Float=dashboardDictLogin["jobsWon"] as! Float
        let jobsCreatedCount:Float=dashboardDictLogin["jobsCreated"] as! Float
        let jobsCreatedAndCompleted:Float=dashboardDictLogin["jobsCreatedAndCompleted"] as! Float
        let jobsCreatedInProgress:Float=dashboardDictLogin["jobsCreatedInProgress"] as! Float
        
        println("Outputs: a \(jobsBidFor) b \(jobsBidAndCompleted)  d \(jobsBidAndInProgress) e \(jobsWon) f \(jobsCreatedCount) g \(jobsCreatedAndCompleted) h \(jobsCreatedInProgress)")
        
        if(jobsBidAndCompleted != 0.0 && jobsWon != 0.0 && jobsCreatedAndCompleted != 0.0 && jobsCreatedCount != 0.0)
        {
            
            let percentForMeF:Float=((jobsCreatedAndCompleted) / (jobsCreatedCount))*100
            let percentForMe:Int=Int(percentForMeF)
            jobsCompletedForMe(percentForMe, title: "\(percentForMe)%")
            println("Outputs: percentForMe \(percentForMe)")
            
            let percentByMeF:Float=((jobsBidAndCompleted) / (jobsWon))*100
            let percentByMe:Int=Int(percentByMeF)
            jobsCompletedByMe(percentByMe, title: "\(percentByMe)%")
            println("Outputs: percentByMe \(percentByMe)")
            
        }
        else
        {
            jobsCompletedByMe(0, title: "0%")
            jobsCompletedForMe(0, title: "0%")
        }
        
        
        name.text="\(currentUser.firstName) \(currentUser.lastName)"
        address.text="\(currentUser.city) , \(currentUser.state)"
        
        self.userProfilePic.image = currentUser.profilePic
        jobsCreated.setTitle("\( Int(jobsCreatedCount))", forState: UIControlState.Normal)
        jobsApplied.setTitle("\(Int(jobsBidFor))", forState: UIControlState.Normal)
    }

    
    
    func updateDashboardData()
    {
        Server.processFetchUserDetails(["userID": (currentUser.userID)])
    }
    
    func jobsCompletedByMe(percent: Int, title: String)
    {
        jCompletedByMeView = ProgressCirlceView(frame: btnCompletedByMe.frame)
        jCompletedByMeView.circleColor = UIColor(red: 255.0/255.0, green: 92.0/255.0, blue: 1.0/255.0,
            alpha: 1.0)
        
        jCompletedByMeView.percent = Int32(percent);
        btnCompletedByMe.setTitle(title, forState: UIControlState.Normal)
        
        btnCompletedByMe.layer.cornerRadius = btnCompletedForMe.frame.size.height/2.0
        btnCompletedByMe.layer.borderColor = UIColor.grayColor().CGColor
        btnCompletedByMe.layer.borderWidth = 1.0
        
//        self.itemsHolderview.addSubview(jCompletedByMeView)
    }
    func jobsCompletedForMe(percent: Int, title: String)
    {
        jCompletedForMeView = ProgressCirlceView(frame: btnCompletedForMe.frame)
        jCompletedForMeView.circleColor = UIColor(red: 139.0/255.0, green: 120.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        
        jCompletedForMeView.percent = Int32(percent);
        btnCompletedForMe.setTitle(title, forState: UIControlState.Normal)
        
        btnCompletedForMe.layer.cornerRadius = btnCompletedForMe.frame.size.height/2.0
        btnCompletedForMe.layer.borderColor = UIColor.grayColor().CGColor
        btnCompletedForMe.layer.borderWidth = 1.0
        
//        self.itemsHolderview.addSubview(jCompletedForMeView)
    }

    func updateDashboard()
    {
        println("userdashboardDictDetailFetchSuccess: \(dashboardDict)")
        
        
        let jobsBidFor: Int = DBManager.jobsBidFor
        let jobsBidAndCompleted: Int = DBManager.jobsBidAndCompleted
        let jobsBidAndInProgress: Int = DBManager.jobsBidAndInProgress
        let jobsWon: Int = DBManager.jobsWon
        let jobsCreatedCount: Int = DBManager.jobsCreated
        let jobsCreatedAndCompleted: Int = DBManager.jobsCreatedAndCompleted
        let jobsCreatedInProgress: Int = DBManager.jobsCreatedInProgress
        
        self.updateRating(DBManager.userRating)
        
        if(jobsBidAndCompleted != 0 && jobsWon != 0 && jobsCreatedAndCompleted != 0 && jobsCreatedCount != 0)
        {
            
            let percentForMeF = ((jobsCreatedAndCompleted) / (jobsCreatedCount))*100
            let percentForMe:Int=Int(percentForMeF)
            jobsCompletedForMe(percentForMe, title: "\(percentForMe)%")
            println("Outputs: percentForMe \(percentForMe)")
            
            let percentByMeF = ((jobsBidAndCompleted) / (jobsWon))*100
            let percentByMe: Int=Int(percentByMeF)
            jobsCompletedByMe(percentByMe, title: "\(percentByMe)%")
            println("Outputs: percentByMe \(percentByMe)")
        }
        else
        {
            jobsCompletedByMe(0, title: "0%")
            jobsCompletedForMe(0, title: "0%")
        }
        name.text="\(currentUser.firstName) \(currentUser.lastName)"
        address.text = "";
        if (currentUser.city.characters.count != 0 && currentUser.state.characters.count != 0)
        {
            address.text="\(currentUser.city) , \(currentUser.state)"
        }
        else if (currentUser.city.characters.count != 0 && currentUser.state.characters.count == 0)
        {
            address.text = currentUser.city;
        }
        else if (currentUser.city.characters.count == 0 && currentUser.state.characters.count != 0)
        {
            address.text = currentUser.state;
        }
        
        jobsCreated.setTitle("\( Int(jobsCreatedCount))", forState: UIControlState.Normal)
        jobsApplied.setTitle("\(Int(jobsBidFor))", forState: UIControlState.Normal)
    }
    
    func getCategoriesSuccess(responseObj: AnyObject)
    {
        let responseDict = responseObj as! NSDictionary
        println("List of categories are : \(responseDict)")
        
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
    
    func getCategoriesFailure(error: NSError) {
        println("getCategoriesFailure:\(error)")
        UIAlertView(title: kAppName, message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }

    // MARK: Server calls ends here
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
