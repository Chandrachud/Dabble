//
//  HomeViewController.swift
//  Dabble
//
//  Created by Reddy on 6/30/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit
import MapKit

let kgetAllJobsNotification = "getAllJobsNotification"

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

class DBLHomeViewController: UIViewController, UITableViewDelegate , UITableViewDataSource,GMSMapViewDelegate, DBLServicesResponsesDelegate, DBLLocationHandlerDelegate, UISearchBarDelegate
{
    let a = 0
    var Server = DBLServices()
    var locationHandler = DBLLocationHandler()
    
    var catListData :NSMutableArray = NSMutableArray()
    var selectedCatList :NSMutableArray = NSMutableArray()
    // var currentLocation: CLLocation!
    
    var currentView:String = String()
    var currentHeading: CLHeading!
    var arrowDirection:Double = Double()
    var bearingAngle: Double = Double()
    
    var jobsArray = NSMutableArray()
    var eventsArray = NSMutableArray()
    var exchangesArray = NSMutableArray()
    
    @IBOutlet weak var jobSegment: UIButton!
    @IBOutlet weak var eventSegment: UIButton!
    @IBOutlet weak var exchangeSegment: UIButton!
    
    @IBOutlet weak var listJobSegment: UIButton!
    @IBOutlet weak var listExchangeSegment: UIButton!
    @IBOutlet weak var listEventSegment: UIButton!
    var distanceInMiles:Float = Float()
    
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    
    var selectedBtn: UIButton = UIButton()
    
    @IBOutlet var mapSegment: UISegmentedControl!
    @IBOutlet var listSegment: UISegmentedControl!
    
    @IBOutlet var mapPost: UIButton!
    @IBOutlet var listPost: UIButton!
    
    @IBOutlet var jobsMapView: UIView!
    @IBOutlet var mapHolderView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var mapViewBtn: UIButton!
    
    @IBOutlet var filterOptionsView: UIView!
    @IBOutlet var filterAllButton: UIButton!
    
    @IBOutlet var filterRangeButton: UIButton!
    @IBOutlet var rangeDisplay: UILabel!
    @IBOutlet var filterCategoryButton: UIButton!
    
    @IBOutlet var categoryListView: UITableView!
    @IBOutlet var rangeSlider: UISlider!
    
    @IBOutlet var jobsListView: UIView!
    @IBOutlet var jobsTableView: UITableView!
    @IBOutlet var listViewBtn: UIButton!
    var fromDashboard: Bool = false
    
    @IBOutlet  var mapSearchBar: UISearchBar!
    @IBOutlet  var listSearchBar: UISearchBar!
    
    var jobLocationCoordinates = NSMutableArray()
    var jobsListFinal = NSMutableArray()
    
    var alljobsList =  NSMutableArray()
    var rangejobsList =  NSMutableArray()
    var catogoryjobsList =  NSArray()
    
    var dblJobDetailViewController = DBLJobDetailViewController()
    var dblDirectionViewController =  DBLMapDirectionViewController()
    
    var coordArray: [CLLocation] = []
    
    @IBAction func dabbleFeetRefresh(sender: AnyObject?)
    {
        
        //        appDelegate.centralSocket.postMessage("")
        
        if Utils.isLocationServicesEnabled() == false
        {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title:kAppName , message: "We can't see you! Please turn on location services in settings", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    println(action)
                }
                alertController.addAction(cancelAction)
                
                let destroyAction = UIAlertAction(title: "Settings", style: .Destructive) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
                    println("Location services settings")
                }
                alertController.addAction(destroyAction)
                
                self.presentViewController(alertController, animated: true)
                    {
                        
                }
            }
            return
        }
        
        self.filterAllButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        self.filterAllButton.selected = true
    }
    
    
    
    @IBAction func handleMapActivities(sender: AnyObject)
    {
        let button: UIButton = sender as! UIButton
        if button.tag == 1
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                listJobSegment.selected = false
                listJobSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                listJobSegment.selected = true
                //                listJobSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
        else if button.tag == 2
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                listEventSegment.selected = false
                listEventSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                listEventSegment.selected = true
                //                listEventSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
        else if button.tag == 3
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                listExchangeSegment.selected = false
                listExchangeSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                listExchangeSegment.selected = true
                //                listEventSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
    }
    
    @IBAction func handleListActivities(sender: AnyObject)
    {
        let button: UIButton = sender as! UIButton
        if button.tag == 1
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                jobSegment.selected = false
                jobSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                jobSegment.selected = true
                //                jobSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
        else if button.tag == 2
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                eventSegment.selected = false
                eventSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                eventSegment.selected = true
                //                eventSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
        else if button.tag == 3
        {
            if button.selected == true
            {
                button.selected = false
                button.backgroundColor = appClearColor
                exchangeSegment.selected = false
                exchangeSegment.backgroundColor = appClearColor
                self.showActivitiesBasedonSelection()
            }
            else
            {
                button.selected = true
                //                button.backgroundColor = appBluecolor
                exchangeSegment.selected = true
                //                eventSegment.backgroundColor = appBluecolor
                self.showActivitiesBasedonSelection()
            }
        }
    }
    
    func separateJobsAndEvents()
    {
        eventsArray.removeAllObjects()
        jobsArray.removeAllObjects()
        
        var obj: NSDictionary
        for item in alljobsList
        {
            obj = item as! NSDictionary
            if obj["event"] as! String == "0"
            {
                jobsArray.addObject(obj)
            }
            else if obj["event"] as! String == "1"
            {
                eventsArray.addObject(obj)
            }
            else if obj["event"] as! String == "2"
            {
                exchangesArray.addObject(obj)
            }
        }
    }
    
    func showActivitiesBasedonSelection()
    {
        if jobsListFinal.count != 0
        {
            jobsListFinal.removeAllObjects()
        }

        if jobSegment.selected == true && eventSegment.selected == true && exchangeSegment.selected == true
        {
            // Event and Job are selected, show both
            jobsListFinal.addObjectsFromArray(alljobsList as [AnyObject])
        }
        else{
        
         if (jobSegment.selected == true)
        {
            // Just show Jobs
            jobsListFinal.addObjectsFromArray(jobsArray as [AnyObject])
        }
         if (eventSegment.selected == true)
        {
            // Show just events
            jobsListFinal.addObjectsFromArray(eventsArray as [AnyObject])
        }
         if (exchangeSegment.selected == true)
        {
            // Show just events
            jobsListFinal.addObjectsFromArray(exchangesArray as [AnyObject])
        }
    
//        else
//        {
//            jobsListFinal.removeAllObjects()
//        }
    }
        println("List of jobs are: \(jobsListFinal)")
        
        //        if jobsListFinal.count != 0
        
        if true
        {
            if(currentView == "ListView")
            {
                self.populateTableViewWithJobs(jobsListFinal)
            }
            else if(currentView == "MapView")
            {
                self.populateMapViewWithJobs(jobsListFinal)
            }
        }
    }
    
    @IBAction func showMenu(sender: AnyObject)
    {
        mapSearchBar.resignFirstResponder()
        mapSearchBar.showsCancelButton = false
        
        listSearchBar.resignFirstResponder()
        listSearchBar.showsCancelButton = false
        let mainVC = self.mainSlideMenu()
        mainVC.openLeftMenu()
    }
    
    @IBAction func backToDashboard(sender: UIButton)
    {
        //self.navigationController?.popViewControllerAnimated(true)
        
        //        var DashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("showDashboard") as! DBLDashboardViewController
        //
        //        self.navigationController?.pushViewController(DashboardViewController, animated: true)
        
        
        if(fromDashboard == true)
        {
            fromDashboard = false
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            
        }
        
    }
    
    var i = 0
    func getCatList()-> NSMutableArray
    {
        let tempArray = NSMutableArray()
        //        for (i ; i < appDelegate.categories.count ; i++)
        //        {
        //            var tempCat: NSDictionary = appDelegate.categories.objectAtIndex(i) as! NSDictionary
        //            tempArray.addObject(tempCat["categoryName"]!)
        //        }
        //        println("All Category names: \(tempArray)")
        return tempArray
        
    }
    
    @IBAction func moveBackToListAction(sender: AnyObject)
    {
        mapViewBtn.hidden = false
        listViewBtn.hidden = true
        
        mapSearchBar.resignFirstResponder()
        mapSearchBar.showsCancelButton = false
        
        listSearchBar.resignFirstResponder()
        listSearchBar.showsCancelButton = false
        
        currentView = "ListView"
        if(currentView == "ListView")
        {
            println("CurrentView: \(currentView)")
            
            locationHandler.startUpdatingHeading()
        }
        
        
        self.jobsListView.hidden = false
        // self.view.bringSubviewToFront(self.jobsListView)
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.filterRangeButton.selected = false
                self.jobsListView.frame = CGRectMake(0, 0, self.jobsListView.frame.size.width, self.jobsListView.frame.size.height)
                
                
            }, completion: { finished in
        })
        
        if (jobsListFinal.count != 0)
        {
            dispatch_async(dispatch_get_main_queue())
                {
                    self.jobsTableView.reloadData()
            }
        }
    }
    
    @IBAction func showJobsMapView(sender: AnyObject)
    {
        mapViewBtn.hidden = true
        listViewBtn.hidden = false
        
        mapSearchBar.resignFirstResponder()
        mapSearchBar.showsCancelButton = false
        
        listSearchBar.resignFirstResponder()
        listSearchBar.showsCancelButton = false
        
        currentView = "MapView"
        if(currentView == "MapView")
        {
            println("CurrentView: \(currentView)")
            locationHandler.stopUpdatingHeading()
        }
        
        //        self.jobsMapView.hidden = false
        //        self.view.bringSubviewToFront(self.jobsMapView)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
            {
                self.filterRangeButton.selected = false
                //                self.jobsMapView.frame = CGRectMake(0, 0, self.jobsMapView.frame.size.width, self.jobsMapView.frame.size.height)
                
                self.jobsListView.frame = CGRectMake(0, self.view.frame.size.height, self.jobsListView.frame.size.width, self.jobsListView.frame.size.height)
                
                
            }, completion: { finished in
        })
        
        
        ////////
        ////////Set Users Location in Map
        ////////
        
        println("All jobsListFinal Maps: \(jobsListFinal)")
        
        if(appDelegate.currentLocation != nil)
        {
            //println("Current Location data is Maps : \(currentLocation)")
            let coordinate:CLLocationCoordinate2D = appDelegate.currentLocation
            
            mapView.clear()
            
            println("rangeSlider.value::::::: \(rangeSlider.value)")
            
            var zoom:Float = 0.0
            let sliderRange:Float = rangeSlider.value
            println("rangeSlider.value::::::: \(sliderRange)")
            
            if(sliderRange == 2.0 )
            {
                zoom = 12.55
                println("zoom.value::::::: \(zoom)")
            }
            else if(sliderRange > 2.0 && sliderRange < 3.0)
            {
                zoom = 12.0
                println("zoom.value::::::: \(zoom)")
            }
            else if(sliderRange >= 3.0 && sliderRange < 4.0)
            {
                zoom = 11.55
                println("zoom.value::::::: \(zoom)")
            }
            else if(sliderRange >= 4.0 && sliderRange < 5.0)
            {
                zoom = 11.25
                println("zoom.value::::::: \(zoom)")
            }
                
            else if(sliderRange >= 5.0 && sliderRange < 6.0)
            {
                zoom = 10.95
                println("zoom.value::::::: \(zoom)")
            }
            else if(sliderRange >= 6.0 && sliderRange < 7.0)
            {
                zoom = 10.75
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 7.0 && sliderRange < 8.0)
            {
                zoom = 10.55
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 8.0 && sliderRange < 9.0)
            {
                zoom = 10.35
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 9.0 && sliderRange < 10.0)
            {
                zoom = 10.20
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 10.0 && sliderRange < 11.0)
            {
                zoom = 10.10
                println("zoom.value::::::: \(zoom)")
                
            }  else if(sliderRange >= 11.0 && sliderRange < 12.0)
            {
                zoom = 9.98
                println("zoom.value::::::: \(zoom)")
                
                
            }  else if(sliderRange >= 12.0 && sliderRange < 13.0)
            {
                zoom = 9.86
                println("zoom.value::::::: \(zoom)")
                
                
            }  else if(sliderRange >= 13.0 && sliderRange < 14.0)
            {
                zoom = 9.74
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 14.0 && sliderRange < 15.0)
            {
                zoom = 9.62
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 15.0 && sliderRange < 16.0)
            {
                zoom = 9.50
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 16.0 && sliderRange < 17.0)
            {
                zoom = 9.40
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 17.0 && sliderRange < 18.0)
            {
                zoom = 9.33
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 18.0 && sliderRange < 19.0)
            {
                zoom = 9.25
                println("zoom.value::::::: \(zoom)")
                
            }
            else if(sliderRange >= 19.0 && sliderRange <= 20.0)
            {
                zoom = 9.2
                println("zoom.value::::::: \(zoom)")
            }
            mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom:zoom)
            mapView.myLocationEnabled = true
            mapView.settings.compassButton = true
            //mapView.settings.myLocationButton = true
            
            
            
            ////////
            ////////Set Users Location marker in Map
            ////////
            //            locationMarker = GMSMarker(position: coordinate)
            //            locationMarker.map = mapView
            //
            //            locationMarker.title = mapTasks.fetchedFormattedAddress
            //            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            //            locationMarker.opacity = 0.75
            //            locationMarker.flat = true
            //            locationMarker.title = "Hi"
            //            locationMarker.snippet = "This is your location"
            
            ////////
            ////////Set Radius around User in Map
            ////////
            let radius:Float = sliderRange * 1609.34 as Float //rangeSlider.value
            let circ:GMSCircle = GMSCircle(position: coordinate, radius: CLLocationDistance(radius))
            
            circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
            circ.strokeColor = UIColor.orangeColor()
            circ.strokeWidth = 1
            circ.map = mapView
            
            //self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(<#bounds: GMSCoordinateBounds!#>)
            
            //            var visibleRegion : GMSVisibleRegion = mapView.f
            //
            //            let bounds = GMSCoordinateBounds(region: visibleRegion)
            //
            //            self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 20.0))
            //
            //mapView.fitBounds(circ.getBounds());
            
            
            
        }
        
        ////////
        ////////Adding Job Markers around User in Map
        ////////
        if (jobsListFinal.count != 0)
        {
            coordArray.removeAll()
            for (index, element) in jobsListFinal.enumerate()
            {                
                let lat:Double = element.valueForKey("lat") as! Double
                let lon:Double = element.valueForKey("lng") as! Double
                
                coordArray.removeAll()
                
                //                let jobCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake( CLLocationDegrees(lat),  CLLocationDegrees(lon))
                
                coordArray.append(CLLocation(latitude: lat, longitude: lon))
                self.showAnnotation(coordArray, jobDict: element as! NSDictionary)
                
                //                self.setupJobLocationMarkerwithCoordinate(jobCoordinate, andJobData: element as! NSDictionary)
            }
//            self.showAnnotation(coordArray, jobsDict: jobsListFinal)
        }
    }
    
    func setupJobLocationMarkerwithCoordinate(coordinate: CLLocationCoordinate2D, andJobData jobdata:NSDictionary)
    {
        //println("\n \n setupJobLocationMarkerwithCoordinate /////////// \(jobdata)")
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        //        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        
        if(jobdata.valueForKey("event") as! String == "0")
        {
            //job
            //locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
            println("\n \n job marker image /////////// ")
            locationMarker.icon = UIImage(named: "Pin-job.png")
        }
        else if(jobdata.valueForKey("event") as! String == "1")
        {
            //event
            //locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
            println("\n \n event marker image /////////// ")
            locationMarker.icon = UIImage(named: "Pin-event.png")
        }
        
        else if(jobdata.valueForKey("event") as! String == "2")
        {
            //event
            //locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
            println("\n \n event marker image /////////// ")
            locationMarker.icon = UIImage(named: "Pin_green.png")
        }

        locationMarker.opacity = 1.0
        //locationMarker.flat = true
        locationMarker.snippet = jobdata.valueForKey("jobTitle") as? String
        //        locationMarker.title = jobdata.valueForKey("categoryName") as? String
        locationMarker.userData = jobdata
    }    
    
    // Temp: TODO
    
    func showMarker(coordinate: CLLocationCoordinate2D)
    {
        //println("\n \n setupJobLocationMarkerwithCoordinate /////////// \(jobdata)")
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        //        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        
        
        locationMarker.icon = UIImage(named: "Pin-job.png")
        
        locationMarker.opacity = 1.0
        //locationMarker.flat = true
        //        locationMarker.snippet = jobdata.valueForKey("jobTitle") as? String
        //        //        locationMarker.title = jobdata.valueForKey("categoryName") as? String
        //        locationMarker.userData = jobdata
    }
    
    
    
    /////////////////////////////////
    ///// GMSMapViewDelegate Methods
    ////////////////////////////////
    
    //    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool
    //    {
    //
    //        println("didTapMarker /////////// ")
    //
    //        println("didTapMarker ///////////  \(marker.userData) ")
    //
    //        return true
    //    }
    
    //    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView!
    //    {
    //
    //        var markerView:UIView = UIView(frame: CGRectMake(0.0, 0.0, 100.0, 50.0))
    //        markerView.backgroundColor = UIColor .whiteColor()
    //        markerView.alpha = 1.0
    //
    //        var jobTitleLab = UILabel(frame: CGRectMake(0, 0, 100, 25))
    //        jobTitleLab.textAlignment = NSTextAlignment.Center
    //        markerView.addSubview(jobTitleLab)
    //
    //        var jobCatagoryLab = UILabel(frame: CGRectMake(0, 25, 100, 25))
    //        jobCatagoryLab.textAlignment = NSTextAlignment.Center
    //
    //        markerView.addSubview(jobCatagoryLab)
    //
    //        if(marker.userData != nil)
    //        {
    //            println("markerInfoWindow /////////// \(marker.userData)")
    //            var jobData:NSDictionary = marker.userData as! NSDictionary
    //            jobTitleLab.text = jobData.valueForKey("categoryName") as? String
    //            jobCatagoryLab.text = jobData.valueForKey("categoryName") as? String
    //
    //        }else{
    //            jobTitleLab.text = marker.title
    //            jobCatagoryLab.text = marker.snippet
    //
    //        }
    //
    //        return markerView
    //    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!)
    {
        
        if(marker.userData != nil)
        {
            println("didTapInfoWindowOfMarker /////////// \(marker.userData)")
            
            let jobData:NSDictionary = marker.userData as! NSDictionary
            
            let lat:Double = jobData.valueForKey("lat") as! Double
            let lon:Double = jobData.valueForKey("lng") as! Double
            
            let distance:Float =   findDistancewithLatitiude(lat, longitide: lon)
            
            
            let jobDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("showJobDetails") as! DBLJobDetailViewController
            
            currentJob.sourceView = kSourceSearchJobs
            
            // jobDetailViewController.jobDetails = marker.userData as! NSDictionary
            currentJob.saveJob(marker.userData as! NSDictionary)
            
            // jobDetailViewController.distanceinMil = String(format: "%.1f Miles", distance)
            currentJob.jobDistance =  String(format: "%.1f Miles", distance)
            
            jobDetailViewController.shouldDownloadImage = true
            self.navigationController?.pushViewController(jobDetailViewController, animated: true)
        }
        
    }
    
    
    
    
    
    @IBAction func filterCategoryAction(sender: AnyObject)
    {
        let fontSize = self.filterAllButton.titleLabel?.font.pointSize
        if (selectedCatList.count != 0 && filterCategoryButton.selected)
        {
            filterCategoryButton.selected = false
            var selCatsStr :String = selectedCatList.componentsJoinedByString(",")
            
            //            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            //                self.filterView.frame = CGRectMake( 0, self.view.frame.size.height - (self.filterAllButton.frame.size.height  + self.displaySelectedCats.frame.size.height),  self.filterView.frame.size.width, self.filterView.frame.size.height)
            //                }, completion: { finished in
            //            })
            self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
            self.categoryListView.hidden = true
        }
        if (selectedCatList.count == 0 && filterCategoryButton.selected)
        {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                }, completion: { finished in
            })
            
            self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
            self.categoryListView.hidden = false
            self.filterCategoryButton.selected = false
            self.categoryListView.reloadData()
        }
        else
        {
            self.filterCategoryButton.selected = true
            self.filterAllButton.selected = false
            self.filterRangeButton.selected = false
            self.categoryListView.hidden = false
            self.filterCategoryButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size:fontSize!)
            self.filterAllButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
            self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
            self.categoryListView.reloadData()
        }
        println("Show Entire Jobs list")
    }
    
    @IBAction func handleRangeSelection(sender: UISlider)
    {
        let intRange: Int = Int(sender.value)
        rangeDisplay.text = "\(intRange) Miles"
        self.getJobsForFilter()
    }
    
    func getJobsForFilter()
    {
        
        //        var joiner = ":"
        //        var elements = ["one", "two", "three"]
        //        var joinedStrings = joiner.join(elements)
        //
        
        
        let array = self.getSelectedCatIDs()
        
        var catStr = "["
        
        for (var i=0 ; i < array.count ; i++ )
        {
            if ( i == 0 )
            {
                catStr = catStr+"\(array[i])"
            }
            else
            {
                catStr = catStr+",\(array[i])"
            }
        }
        catStr = "\(catStr)]"
        //        var postParams = ["lat" : 17.4317, "lng": 78.3917, "range" : (rangeSlider.value * 1600), "categories": catStr]
        
        if(appDelegate.currentLocation != nil)
        {
            
            let postParams = ["lat" : String(format: "%f",appDelegate.currentLocation.latitude), "lng": String(format: "%f",appDelegate.currentLocation.longitude), "range" : (rangeSlider.value * 1600),  "searchText" : ""]
            
            
            //        var postParams = ["lat" : String(format: "%f",appDelegate.currentLocation.latitude), "lng": String(format: "%f",appDelegate.currentLocation.longitude), "range" : (rangeSlider.value * 1500), "categories": catStr]
            //
            Server.processFetchJobsByRangeAndCategories(postParams)
        }
    }
    
    
    func getSelectedCatIDs() -> NSArray
    {
        let array = NSMutableArray()
        for (var i = 0 ; i < selectedCatList.count ; i++ )
        {
            array.addObject(self.getIdForCategory(selectedCatList[i] as! String))
        }
        return array
    }
    
    func getIdForCategory(catName: String) -> Int
    {
        //        var i = 0
        //        var tempCatName = String()
        //        for (i ; i < appDelegate.categories.count ; i++)
        //        {
        //            var tempCat: NSDictionary = appDelegate.categories.objectAtIndex(i) as! NSDictionary
        //            tempCatName = tempCat["categoryName"]! as! String
        //            if (tempCatName == catName)
        //            {
        //                return tempCat["categoryId"] as! Int
        //            }
        //        }
        return 0
    }
    
    
    
    @IBAction func selectedCategoriesAction(sender: AnyObject)
    {
        self.filterCategoryButton.selected = false
        self.getJobsForFilter()
    }
    
    @IBAction func selectRangeAction(sender: UIButton)
    {
        let fontSize = self.filterRangeButton.titleLabel?.font.pointSize
        
        if (sender.selected)
        {
            sender.selected = false
            self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
        }
        else
        {
            sender.selected = true
            
            self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size:fontSize!)
            
            self.filterAllButton.selected = false
            self.filterAllButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
            
            self.filterCategoryButton.selected = false
            self.filterCategoryButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size:fontSize!)
        }
        self.categoryListView.hidden = true
        println("Show Entire Jobs list")
    }
    
    func setUsersLocation()
    {
        if(appDelegate.currentLocation != nil)
        {
            // println("Current Location data is Maps : \(currentLocation)")
            let coordinate:CLLocationCoordinate2D = appDelegate.currentLocation as CLLocationCoordinate2D
            
            mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom:12.55)
            mapView.myLocationEnabled = true
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
            
            ////////
            ////////Set Users Location marker in Map
            ////////
            //            locationMarker = GMSMarker(position: coordinate)
            //            locationMarker.map = mapView
            //
            //            locationMarker.title = mapTasks.fetchedFormattedAddress
            //            locationMarker.appearAnimation = kGMSMarkerAnimationPop
            //            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            //            locationMarker.opacity = 0.75
            //            locationMarker.flat = true
            //            locationMarker.title = "Hi"
            //            locationMarker.snippet = "This is your location"
            
            ////////
            ////////Set Radius around User in Map
            ////////
            let radius:Float = self.rangeSlider.value * 1609.34 as Float //rangeSlider.value
            let circ:GMSCircle = GMSCircle(position: coordinate, radius: CLLocationDistance(radius))
            
            circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
            circ.strokeColor = UIColor.orangeColor()
            circ.strokeWidth = 1
            circ.map = mapView
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Server.delegate = self
        
        self.jobsTableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.jobsListView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        
        self.jobSegment.selected = true
        self.eventSegment.selected = true
        self.listEventSegment.selected = true
        self.listJobSegment.selected = true
        self.listExchangeSegment.selected = true
        self.exchangeSegment.selected = true
        self.rangeSlider.setThumbImage(UIImage(named: "SliderThumb"), forState:UIControlState.Normal)
        self.rangeSlider.minimumTrackTintColor = appPrimaryColor
        self.rangeSlider.maximumTrackTintColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        
        mapViewBtn.hidden = true
        listViewBtn.hidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateHomeviewController"), name: kgetAllJobsNotification, object: nil)
        
        //        if (currentUser.userID <= 0)
        //        {
        //            self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
        //            return
        //        }
        
        //===================================================================
        
        let loginId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginID) as? String
        let password = NSUserDefaults.standardUserDefaults().objectForKey(kLoginPassword) as? String
        let loginFbId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginFacebookId) as? String
        
        println("Login id: \(loginFbId)")
        println("Login id: \(password)")
        println("Login id: \(loginFbId)")
        
        if currentUser == nil || currentUser.userID <= 0
        {
            if loginId != nil && password != nil
            {
                println("User credentials are exist: \(loginId) - \(password)")
                println("Call Login service with General Login Credentials.")
                
                if Utils.isNetworkReachable()
                {
                    self.loginAction()
                }
                else
                {
                    self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                    self.closeTransactions()
                    return
                }
                //
            }
            else if (loginFbId != nil)
            {
                println(loginFbId)
                println("Previously Logged in with Facebook with Id: \(loginFbId)")
                println("Call Facebook Login service with General Login Credentials.")
                if Utils.isNetworkReachable()
                {
                    self.loginWithFacebook()
                }
                else
                {
                    self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                    self.closeTransactions()
                    return
                }
            }
            else if currentUser == nil || currentUser.userID <= 0
            {
                self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                return
                
                /*
                i) Check the Login details are there in defaults
                if exists General Login
                else
                Check for FB USERid
                if try login with FB
                else
                shownlogin page
                
                */
            }
        }
        //        else
        //        {
        //            if currentUser == nil
        //            {
        //                currentSubscription = Subscription()
        //                currentUser = User()
        //                DBManager = Dashboard()
        //                currentJob = Job()
        //            }
        //
        ////            let userObject = User.allObjects().lastObject()
        ////            currentUser = userObject as! User
        //
        //            let recentUserData = (NSUserDefaults.standardUserDefaults().objectForKey(kPersistCurrentUserData)) as! NSData
        //            let recentUserDetailsDict: NSDictionary =  NSKeyedUnarchiver.unarchiveObjectWithData(recentUserData) as! NSDictionary
        //            println(recentUserDetailsDict);
        //            currentUser.saveUserDetail(recentUserDetailsDict)
        //            self.updateProfilePic()
        //            return
        //        }
        
        if currentUser.userID != 0
        {
            self.updateHomeviewController()
        }
    }
    
    func updateProfilePic()
    {
        Server.processFetchProfilePic(["userID": currentUser.userID])
    }
    
    // MARK: Server calls starts here
    func profilePicFetchSuccess(responseDict: AnyObject!)
    {
        println("profilePicFetchSuccess: \(responseDict)")
//        currentUser.profilePic = responseDict as! UIImage
        if currentUser != nil
        {
            currentUser.profilePic = responseDict as! UIImage
        }
    }
    
    func profilePicFetchFailure(error: NSError?)
    {
        println("profilePicFetchFailure: \(error)")
        if currentUser.userID != 0
        {
//            self.updateHomeviewController()
        }
    }
    
    func updateHomeviewController()
    {
        if Utils.isLocationServicesEnabled() == false
        {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title:kAppName , message: "We can't see you! Please turn on location services in settings", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    println(action)
                }
                alertController.addAction(cancelAction)
                
                let destroyAction = UIAlertAction(title: "Settings", style: .Destructive) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
                    println("Location services settings")
                }
                alertController.addAction(destroyAction)
                
                self.presentViewController(alertController, animated: true)
                    {
                        
                }
            }
            return
        }
        self.mapView.delegate = self
        
        locationHandler.delegate = self
        locationHandler.startUpdating()
        
        mapSearchBar.delegate = self
        listSearchBar.delegate = self
        
        self.currentView = "MapView"
        println("CurrentView: \(currentView)")
        
        self.setUsersLocation()
        
        self.filterAllButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        self.filterAllButton.selected = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // MARK: LocationHandler Methods
        locationHandler.startUpdating()
        
        if currentJob != nil
        {
            if currentJob.isEdited == YES
            {
                self.dabbleFeetRefresh(nil)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        locationHandler.stopUpdatingHeading()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleActivity(sender: UISegmentedControl)
    {
        if(sender.tag == 11)
        {
            // MapView SegmentedControl
        }
        else if(sender.tag == 22)
        {
            // ListView SegmentedControl
        }
    }
    
    @IBAction func postAction(sender: UIButton)
    {
        if(sender.tag == 11)
        {
            // MapView postAction
        }
        else if(sender.tag == 22)
        {
            // ListView postAction
        }
    }
    
    @IBAction func filterAllAction(sender: AnyObject)
    {
        // rangeSlider.value = rangeSlider.value
        //        self.view.bringSubviewToFront(self.filterView)
        //        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations:
        //            {
        //            self.filterView.frame = CGRectMake( 0, self.view.frame.size.height - 50,  self.filterView.frame.size.width, self.filterView.frame.size.height)
        //            }, completion: { finished in
        //        })
        self.filterRangeButton.selected = false;
        self.filterCategoryButton.selected = false
        self.filterAllButton.selected = true;
        
        let fontSize = self.filterAllButton.titleLabel?.font.pointSize
        self.filterAllButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size:fontSize!)
        self.filterRangeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size:fontSize!)
        self.filterCategoryButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size:fontSize!)
        
        selectedCatList.removeAllObjects()
        self.filterAllButton.setTitleColor(UIColor.whiteColor(), forState: filterAllButton.state)
        println("Show Entire Jobs list")
        
        if(appDelegate.currentLocation != nil)
        {
            println(" HomeViewController appDelegate.currentLocation:::::: \(appDelegate.currentLocation.latitude)")
            let lat = String(format: "%f",appDelegate.currentLocation.latitude)
            let lng = String(format: "%f",appDelegate.currentLocation.longitude)
            
            let postParams = ["lat" : lat, "lng": lng, "range" : (rangeSlider.value * 1600),  "searchText" : ""]
            
            Server.processFetchAllJobs(postParams)
        }
    }
    
    func fetchAllJobsSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("fetchAllJobsSuccess: \(responseDict)")
        
        if(responseDict.count != 0)
        {
            let statusCode = responseDict["code"] as! Int
            var alertMsg = ""
            
            if statusCode == 0
            {
                if alljobsList.count != 0
                {
                    alljobsList.removeAllObjects()
                }
                
                // Filtering all jobs for active jobs.
                var job: NSDictionary
                
                for item in responseDict["payload"] as! NSArray as [AnyObject]
                {
                    job = item as! NSDictionary
                    if job["status"] as! Int == 0
                    {
                        alljobsList.addObject(job)
                    }
                }
                
                //                alljobsList.addObjectsFromArray(responseDict["payload"] as! NSArray as [AnyObject])
                
                self.separateJobsAndEvents()
                self.showActivitiesBasedonSelection()
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
    }
    
    func fetchAllJobsFailure(error:NSError?)
    {
        appDelegate.showToastMessage("Failure", message: (error?.localizedDescription)!)
        println("fetchAllJobsFailure")
    }
    
    func populateMapViewWithJobs(listJobs:NSArray)
    {
        //        jobsListFinal = NSMutableArray(array: listJobs)
        
        dispatch_async(dispatch_get_main_queue())
            {
                self.mapViewBtn.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
    }
    
    func populateTableViewWithJobs(listJobs:NSArray)
    {
        //        jobsListFinal = NSMutableArray(array: listJobs)
        
        dispatch_async(dispatch_get_main_queue())
            {
                self.jobsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.separatorColor = UIColor.clearColor()
        if jobsListFinal.count != 0
        {
            tableView.hidden = false
            return jobsListFinal.count;
        }
        else
        {
            tableView.hidden = true
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier : String = "HomeTableViewCell";
        var jobCell : HomeTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? HomeTableViewCell
        if (jobCell == nil)
        {
            jobCell = HomeTableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier)
        }
        
        let jobData:NSDictionary = jobsListFinal.objectAtIndex(indexPath.row) as! NSDictionary
        let url = String(format: urlUserProfile, jobData.valueForKey("posterId") as! Int)
        println(url)
        let url_request = NSURLRequest(URL: NSURL(string: url)!)
        let placeholder = UIImage(named: "avatar.png")
        
        jobCell?.jobPoster.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { [weak jobCell] (request:NSURLRequest!,response:NSHTTPURLResponse?, image:UIImage!) -> Void in
            if let cell_for_image = jobCell {
                //                    if(tableView.visibleCells.containsObject(jobCell)) {
                jobCell?.jobPoster.image? = image
            }
            }, failure: { [weak jobCell]
                (request:NSURLRequest!,response:NSHTTPURLResponse?, error:NSError!) -> Void in
                if let cell_for_image = jobCell {
                    //                        jobImage.image = nil
                    //                        cell_for_image.setNeedsLayout()
                }
            })
        
        jobCell?.JobDes.text=jobData.valueForKey("description") as! String
        jobCell?.jobTitle.text = jobData.valueForKey("jobTitle") as? String
        
        if jobData["event"] as? Int == YES
        {
            jobCell?.jobTitle.textColor = kEventTitleColor
        }
        else
        {
            jobCell?.jobTitle.textColor = kJobTitleColor
        }
        
        if(appDelegate.currentLocation != nil)
        {
            let lat:Double = jobData.valueForKey("lat") as! Double
            let lon:Double = jobData.valueForKey("lng") as! Double
            let distance:Float =   findDistancewithLatitiude(lat, longitide: lon)
            jobCell?.jobDistance.setTitle(String(format: "%.1f Miles", distance), forState: UIControlState.Normal)
            jobCell?.jobDistanceLbl.text = String(format: "%.1f Miles", distance)
            jobCell?.jobDistance.tag = indexPath.row
            println("jobDistance.tag: \(jobCell?.jobDistance.tag)")
        }
        
        //        if(appDelegate.currentLocation != nil)
        //        {
        //            bearingAngle = setLatLonForDistanceAndAngle(appDelegate.currentLocation, toLatitude: lat, toLonngitude: lon)
        //        }
        //        directArrow.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(arrowDirection ) + bearingAngle))
        
        return jobCell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let imageView = cell?.contentView.viewWithTag(1) as! UIImageView
        
        //dblJobDetailViewController.jobImage = imageView.image!
        
        currentJob.posterImage = imageView.image!
        dblJobDetailViewController.shouldDownloadImage = false
        //        self.performSegueWithIdentifier("showJobDesViewSegue", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func findDistancewithLatitiude(latitide:Double, longitide:Double) ->Float
    {
        let lat: CLLocationDegrees = latitide
        let long: CLLocationDegrees = longitide
        
        let jobLocation: CLLocation = CLLocation(latitude: lat,
            longitude: long)
        
        //         var GMdistanceInMeters:CLLocationDistance = GMSGeometryDistance(appDelegate.usersLocation.coordinate, jobLocation.coordinate)
        //         var MKdistanceInMeters:CLLocationDistance = jobLocation.distanceFromLocation(appDelegate.usersLocation)
        //         println("GMdistanceInMeters:::::::: \(GMdistanceInMeters)")
        //         println("MKdistanceInMeters:::::: \(MKdistanceInMeters)")
        
        let distanceInMeters:CLLocationDistance = jobLocation.distanceFromLocation(appDelegate.usersLocation)
        //println("DistanceInMts: \(distanceInMeters)")
//        var distanceInKM:Float = Float (distanceInMeters/1000)
        //println("DistanceInKM: \(distanceInKM)")
        
        distanceInMiles = Float (distanceInMeters * 0.000621371192)
        // println("DistanceInMiles: \(distanceInMiles)")
        return distanceInMiles
    }
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 190.0/M_PI
    }
    
    func DegreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    func setLatLonForDistanceAndAngle(userLocation: CLLocationCoordinate2D ,toLatitude latitud:Double, toLonngitude longitud:Double) -> Double
    {
        let lat1 = DegreesToRadians(userLocation.latitude)
        let lon1 = DegreesToRadians(userLocation.longitude)
        
        let lat2 = DegreesToRadians(latitud); // jobLat
        let lon2 = DegreesToRadians(longitud); // jobLon
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        var radiansBearing = atan2(y, x);
        if(radiansBearing < 0.0)
        {
            radiansBearing += 2*M_PI;
        }
        return radiansBearing;
    }
    
    //MARK: DBLLocationHandlerDelegate methods
    func locationManager(manager: CLLocationManager!, didUpdateLocation location:CLLocation!)
    {
        
        //        // var allLocations: NSArray = locations as NSArray
        //        appDelegate.currentLocation = location.coordinate
        //        currentLocation = location
        //
        //        // println("Current Location data is : \(currentLocation)")
        //
        //        var currentLocationCoord = location.coordinate
        //        sharedManager.stopUpdating()
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateNewHeading heading: CLHeading!)
    {
        // println("Current heading data is : \(heading)")
        
        let direction = -heading.trueHeading as Double
        arrowDirection = direction
        currentHeading = heading
        
        
        //locationHandler.stopUpdatingHeading()
        //jobsTableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager!, failedWithError error: NSError!)
    {
        println("Failed to pick the current location")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {
        if segue!.identifier == "showJobDetailsSegue"
        {
            let senderIsTableviewCell:Bool! = sender?.isKindOfClass(UITableViewCell)
            if (senderIsTableviewCell == true)
            {
                
                let jobCell : HomeTableViewCell =  sender as! HomeTableViewCell
                
                println ("showJobDetailsSegue")
                let indexPath = self.jobsTableView.indexPathForSelectedRow
                
                let distanceButton:UIButton = jobCell.jobDistance as UIButton
                let distanceInMiles:String = distanceButton.titleLabel!.text!
                println("indexPath!.row: \(indexPath!.row)")
                currentJob.saveJob(jobsListFinal[indexPath!.row] as! NSDictionary)
                currentJob.jobDistance =  String(format: "%@", distanceInMiles)
                currentJob.sourceView = kSourceSearchJobs
            }
        }
        
        if segue!.identifier == "mapDirection"
        {
            dblDirectionViewController = segue!.destinationViewController as! DBLMapDirectionViewController
            
            let senderIsTableviewCell:Bool! = sender?.isKindOfClass(UIButton)
            if (senderIsTableviewCell == true)
            {
                println ("aaaaa mapDirection tag::::\((sender?.tag)!) ")
                //do something
                let distanceButton:UIButton = sender as! UIButton
                let distanceInMiles:String = distanceButton.titleLabel!.text!
                println ("aaaaa distanceButton tag::::\(distanceButton.tag) ")
                
                currentJob.saveJob(jobsListFinal[(sender?.tag)!] as! NSDictionary)
                currentJob.jobDistance =  String(format: "%@", distanceInMiles)
                currentJob.sourceView = kSourceSearchJobs
            }
        }
    }
    
    //func print(object: AnyObject)
    //{
    
    //}
    
    //func println(object: AnyObject)
    //{
    
    //}
    
    
    //MARK: UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.tintColor = UIColor.whiteColor()
        //println("1.DidBeginEditing")
        
        //        for (UIView *possibleButton in searchBar.subviews)
        //        {
        //            if ([possibleButton isKindOfClass:[UIButton class]])
        //            {
        //                UIButton *cancelButton = (UIButton*)possibleButton;
        //                cancelButton.enabled = YES;
        //                break;
        //            }
        //        }
        //
        for view in searchBar.subviews
        {
            
        }
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        //println("2.DidEndEditing")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        // println("3.CancelButtonClicked")
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.dabbleFeetRefresh(nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        //println("4.SearchButtonClicked")
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if(searchBar.tag == 11)
        {
            // MapView Searchbar
            //             println(" MapView Searchbar::::::")
            //             println(" MapView Searchbar:::::: searchBar.text \( searchBar.text)")
            //             println(" MapView Searchbar:::::: rangeSlider.value \(rangeSlider.value)")
            
            
            if(rangeSlider.value > 2.0)
            {
                // println(" MapView Searchbar::::::processFetchJobsByRangeAndCategories")
                if(appDelegate.currentLocation != nil)
                {
                    let postParams = ["lat" : String(format: "%f",appDelegate.currentLocation.latitude), "lng": String(format: "%f",appDelegate.currentLocation.longitude), "range" : (rangeSlider.value * 1600), "searchText" : searchBar.text!]
                    Server.processFetchJobsByRangeAndCategories(postParams)
                }
            }
            else
            {
                //println(" MapView Searchbar::::::processFetchAllJobs")
                if(appDelegate.currentLocation != nil)
                {
                    
                    let lat = String(format: "%f",appDelegate.currentLocation.latitude)
                    let lng = String(format: "%f",appDelegate.currentLocation.longitude)
                    
                    let postParams = ["lat" : lat, "lng":lng, "range": rangeSlider.value*1600, "searchText" : searchBar.text!]
                    Server.processFetchAllJobs(postParams)
                }
            }
        }
        else if(searchBar.tag == 22)
        {
            
            // ListView Searchbar
            
            //            println(" ListView Searchbar::::::")
            //            println(" ListView Searchbar:::::: searchBar.text \( searchBar.text)")
            //            println(" ListView Searchbar:::::: rangeSlider.value \( rangeSlider.value)")
            
            if(rangeSlider.value > 2.0)
            {
                // println(" ListView Searchbar::::::processFetchJobsByRangeAndCategories")
                if(appDelegate.currentLocation != nil)
                {
                    
                    let postParams = ["lat" : String(format: "%f",appDelegate.currentLocation.latitude), "lng": String(format: "%f",appDelegate.currentLocation.longitude), "range" : (rangeSlider.value * 1600), "searchText" : searchBar.text!]
                    Server.processFetchJobsByRangeAndCategories(postParams)
                }
                
                
            }
            else
            {
                // println(" ListView Searchbar::::::processFetchAllJobs")
                if(appDelegate.currentLocation != nil)
                {
                    let lat = String(format: "%f",appDelegate.currentLocation.latitude)
                    let lng = String(format: "%f",appDelegate.currentLocation.longitude)
                    
                    let postParams = ["lat" : lat, "lng":lng, "range": rangeSlider.value*1600,  "searchText" : searchBar.text!]
                    Server.processFetchAllJobs(postParams)
                }
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        // println("5.textDidChange")
    }
    
    
    // MARK: Methods to display multiple annotations at same location.
    
    var annotations: [MKAnnotation] = []
    
    func showAnnotation(locations: NSArray, jobDict: NSDictionary)
    {
        println(coordArray.count)
        
        annotations.removeAll()
        // construct and add annotations for our model
        for shop in coordArray {
            let p = constructAnnotationForTitle(CLLocationCoordinate2D(latitude: shop.coordinate.latitude, longitude: shop.coordinate.longitude))
            annotations.append(p)
        }
        
        let newAnnotations:[MKAnnotation] = ContestedAnnotationTool.annotationsByDistributingAnnotations(annotations) { (oldAnnotation:MKAnnotation, newCoordinate:CLLocationCoordinate2D) in
            self.constructAnnotationForTitle(newCoordinate)
        }
        println(newAnnotations)
        
        // replace annotations
        //        mapView.clear()
        
//        print(newAnnotations)
        for i in 0 ... newAnnotations.count - 1
        {
            self.setupJobLocationMarkerwithCoordinate(newAnnotations[i].coordinate, andJobData: jobDict )
        }
    }
    
    // Constructs an MKAnnotation, in this demo just a point
    private func constructAnnotationForTitle(coordinate: CLLocationCoordinate2D) -> MKAnnotation
    {
        let p = MKPointAnnotation()
        p.coordinate = coordinate
        p.title = title
        return p
    }
    
    //#MARK: Auto Login Services:
    
    func loginAction()
    {
        let loginId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginID) as! String
        let password = NSUserDefaults.standardUserDefaults().objectForKey(kLoginPassword) as! String
        
        let postParams = ["login": loginId, "password": password];
        Server.processLogin(postParams)
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
                appDelegate.showToastMessage("Expired", message: alertMsg)
//                let alertView = UIAlertView(title: kAppName, message: alertMsg, delegate: self, cancelButtonTitle: "Cancel")
//                alertView.addButtonWithTitle("Subscribe Now")
//                alertView.show()
                self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                self.closeTransactions()
                return
            }
            else
            {
                alertMsg = Utils.statusMessageFor(statusCode)
                if alertMsg.characters.count != 0
                {
                self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                    self.closeTransactions()
                    return;
                }
                println("Default Case ")
            }
            
            println("Login success with response: \(responseDict)")
            if(responseDict["payload"] != nil)
            {
                let payload = responseDict["payload"] as! NSDictionary
                
                if currentUser == nil
                {
                    currentSubscription = Subscription()
                    currentUser = User()
                    DBManager = Dashboard()
                    currentJob = Job()
                }
                currentUser.saveUserDetail(payload)
                appDelegate.initiate()
                self.updateProfilePic()
                NSNotificationCenter.defaultCenter().postNotificationName(kgetAllJobsNotification, object: nil)
            }
        }
    }
    
    func loginFailed(error: NSError?)
    {
        appDelegate.hideLoadingView()
        println("Login failed with error: \(error)")
//        UIAlertView(title: kAppName, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
        self.closeTransactions()
        return
    }
    
    func loginWithFacebook()
    {
        let loginFbId = NSUserDefaults.standardUserDefaults().objectForKey(kLoginFacebookId) as! String
        //    let fbUID : AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey(kLoginFacebookId)        
        if(loginFbId.characters.count != 0)
        {
            let postParams = ["userID": loginFbId]
            Server.processLoginWithFacebook(postParams)
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
            if statusCode == 201
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
                appDelegate.showToastMessage("Expired", message: alertMsg)
                
//                let alertView = UIAlertView(title: kAppName, message: alertMsg, delegate: self, cancelButtonTitle: "Cancel")
//                alertView.addButtonWithTitle("Subscribe Now")
//                alertView.show()
                self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                self.closeTransactions()
                return
            }
            else
            {
                alertMsg = Utils.statusMessageFor(statusCode)
                if alertMsg.characters.count != 0
                {
                    UIAlertView(title: "Failed", message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
                    self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
                    self.closeTransactions()
                    return
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
                let payload = responseDict["payload"] as! NSDictionary
                currentUser.saveUserDetail(payload)
                appDelegate.initiate()
                self.updateProfilePic()
                NSNotificationCenter.defaultCenter().postNotificationName(kgetAllJobsNotification, object: nil)
            }
        }
    }
    
    func loginWithFacebookFailure(error: NSError?)
    {
        println("loginWithFacebookFailure::::: \(error)")
        self.navigationController?.performSegueWithIdentifier("showLoginViewSegue", sender: nil)
        self.closeTransactions()
        return
    }
    
    func closeTransactions()
    {
//        let manager = AFHTTPRequestOperationManager()
//        manager.operationQueue.cancelAllOperations()
//        appDelegate.socket.close()
    }
}
//======================================================================================

/**
* Tool to construct new annotations
*/
public struct ContestedAnnotationTool {
    
    private static let radiusOfEarth = Double(6378100)
    
    public typealias annotationRelocator = ((oldAnnotation:MKAnnotation, newCoordinate:CLLocationCoordinate2D) -> (MKAnnotation))
    
    public static func annotationsByDistributingAnnotations(annotations: [MKAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MKAnnotation] {
        
        // 1. group the annotations by coordinate
        
        let coordinateToAnnotations = groupAnnotationsByCoordinate(annotations)
        
        // 2. go through the groups and redistribute
        
        var newAnnotations = [MKAnnotation]()
        
        for (_, annotationsAtCoordinate) in coordinateToAnnotations
        {
            
            let newAnnotationsAtCoordinate = ContestedAnnotationTool.annotationsByDistributingAnnotationsContestingACoordinate(annotationsAtCoordinate, constructNewAnnotationWithClosure: ctor)
            
            newAnnotations.appendContentsOf(newAnnotationsAtCoordinate)
        }
        
        return newAnnotations
    }
    
    private static func groupAnnotationsByCoordinate(annotations: [MKAnnotation]) -> [CLLocationCoordinate2D: [MKAnnotation]] {
        var coordinateToAnnotations = [CLLocationCoordinate2D: [MKAnnotation]]()
        for annotation in annotations {
            let coordinate = annotation.coordinate
            let annotationsAtCoordinate = coordinateToAnnotations[coordinate] ?? [MKAnnotation]()
            coordinateToAnnotations[coordinate] = annotationsAtCoordinate + [annotation]
        }
        return coordinateToAnnotations
    }
    
    private static func annotationsByDistributingAnnotationsContestingACoordinate(annotations: [MKAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MKAnnotation] {
        
        var newAnnotations = [MKAnnotation]()
        
        let contestedCoordinates = annotations.map{ $0.coordinate }
        
        let newCoordinates = coordinatesByDistributingCoordinates(contestedCoordinates)
        
        var newCoordinate: CLLocationCoordinate2D!
        var newAnnotation: MKAnnotation!
        for (i, annotation) in annotations.enumerate() {
            
            newCoordinate = newCoordinates[i]
            newAnnotation = ctor(oldAnnotation: annotation, newCoordinate: newCoordinate)
            newAnnotations.append(newAnnotation)
        }
        
        return newAnnotations
    }
    
    private static func coordinatesByDistributingCoordinates(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        
        if coordinates.count == 1 {
            return coordinates
        }
        
        var result = [CLLocationCoordinate2D]()
        
        let distanceFromContestedLocation: Double = 3.0 * Double(coordinates.count) / 2.0
        let radiansBetweenAnnotations = (M_PI * 2) / Double(coordinates.count)
        
        for (i, coordinate) in coordinates.enumerate() {
            
            let bearing = radiansBetweenAnnotations * Double(i)
            let newCoordinate = calculateCoordinateFromCoordinate(coordinate, onBearingInRadians: bearing, atDistanceInMetres: distanceFromContestedLocation)
            
            result.append(newCoordinate)
        }
        return result
    }
    
    private static func calculateCoordinateFromCoordinate(coordinate: CLLocationCoordinate2D, onBearingInRadians bearing: Double, atDistanceInMetres distance: Double) -> CLLocationCoordinate2D {
        
        let coordinateLatitudeInRadians = coordinate.latitude * M_PI / 180;
        let coordinateLongitudeInRadians = coordinate.longitude * M_PI / 180;
        
        let distanceComparedToEarth = distance / radiusOfEarth;
        
        let resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) + cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearing));
        let resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearing) * sin(distanceComparedToEarth) * cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) * sin(resultLatitudeInRadians));
        
        let latitude = resultLatitudeInRadians * 180 / M_PI;
        let longitude = resultLongitudeInRadians * 180 / M_PI;
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// To use CLLocationCoordinate2D as a key in a dictionary, it needs to comply with the Hashable protocol
extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        get {
            return (latitude.hashValue&*397) &+ longitude.hashValue;
        }
    }
}

// To be Hashable, you need to be Equatable too
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
