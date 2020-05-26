//
//  DBLLocationHandlerViewController.swift
//  Dabble
//
//  Created by Reddy on 7/21/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

enum TravelModes: Int
{
    case driving
    case walking
    case bicycling
}

class DBLLocationHandlerViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    @IBOutlet var mapCenterPinImage: UIImageView!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var pinIcon: UIImageView!
    var createAccountViewController: DBLCreateAccountViewController!
    var createJobViewController: DBLCreateJobViewController!
     var myProfileViewContorller: DBLMyProfileViewContorller!
   // var locationManager = CLLocationManager()
   // var currentLocation: CLLocation!
    var selectedLocation: GMSAddress = GMSAddress()
    
    var selectionFrom:String = String()
    var cLocation:CLLocationCoordinate2D!
    var didFindMyLocation = false
    var mapTasks = MapTasks()
    
    var locationMarker: GMSMarker!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    var markersArray: Array<GMSMarker> = []
    var waypointsArray: Array<String> = []
    var travelMode = TravelModes.driving
    
    var isEvent = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.populateDefaultUI()

        //        locationManager.delegate = self
//       
//        
//        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")))
//        {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        else
//        {
//            locationManager.startUpdatingLocation()
//        }
    }
    
    func populateDefaultUI()
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
            viewMap.delegate = self
            let camera: GMSCameraPosition? = GMSCameraPosition.cameraWithLatitude(appDelegate.currentLocation.latitude, longitude: appDelegate.currentLocation.longitude, zoom: 12.50)
            viewMap.camera = camera
            viewMap.myLocationEnabled = true
            viewMap.settings.compassButton = true
            if isEvent == true
            {
                pinIcon.image = UIImage(named: "Pin-event.png")
            }
            else
            {                 
                pinIcon.image = UIImage(named: "Pin-job.png")
            }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!)
    {
        cLocation=position.target
        reverseGeocodeCoordinate(position.target)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            
            if let address = response?.firstResult()
            {
                
                println("\n Selected reverseGeocodeCoordinate response is : \(address)")
                
                self.selectedLocation = address                   
            }
        }
    }
    
    @IBAction func pickLocationAction(sender: UIButton)
    {
        println("presentedViewController\( self.selectionFrom)")
        
        if (self.selectionFrom == "CreateAccountView")
        {
            createAccountViewController.showSelectedLocation(selectedLocation)
        }
        else if(self.selectionFrom == "CreateJobView")
        {
            createJobViewController.showSelectedLocation(selectedLocation)
        }
        else if(self.selectionFrom == "MyProfileView")
        {
            myProfileViewContorller.showSelectedLocation(selectedLocation)
        }
        else
        {
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goBack(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
//    {
//        println("didChangeAuthorizationStatus")
//        if status == CLAuthorizationStatus.AuthorizedWhenInUse
//        {
//            locationManager.startUpdatingLocation()
//            viewMap.myLocationEnabled = true
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
//    {
//        println("Locations updated")
//        viewMap.myLocationEnabled = true
//        viewMap.settings.myLocationButton = true
//        
//        var locationArray = locations as NSArray
//        var locationObj = locationArray.lastObject as! CLLocation
//        var coord = locationObj.coordinate
//        
//        var allLocations: NSArray = locations as NSArray
//        currentLocation = allLocations[0] as! CLLocation
//        //println("Current Location data is : \(currentLocation)")
//        
//         appDelegate.currentLocation = currentLocation.coordinate
//        
//        if let location = locations.first as? CLLocation
//        {
//            
//            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            
//            
//            locationManager.stopUpdatingLocation()
//            
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
//    {
//        print("Failed to fetch current location. \(error)")
//    }
    }
