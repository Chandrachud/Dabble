//
//  DBLMapDirectionViewController.swift
//  Dabble
//
//  Created by Reddy on 7/16/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class DBLMapDirectionViewController: UIViewController, GMSMapViewDelegate,DBLLocationHandlerDelegate
{
    
    let apiKey = goolgeMapsServerKey
    var session: NSURLSession
        {
            return NSURLSession.sharedSession()
    }
    // var locationHandler = DBLLocationHandler()
    var bearingAngle: Double = Double()
    var currentHeading: CLHeading!
    var arrowDirection:Double = Double()
    
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var distanceLbl: UILabel!
    @IBOutlet var directionImg: UIImageView!
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var travelOptionsView: UIView!
    @IBOutlet var carModeBtn: UIButton!
    @IBOutlet var busModeBtn: UIButton!
    @IBOutlet var walkModeBtn: UIButton!
    @IBOutlet var bicycleModeBtn: UIButton!
    
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    
    var endLocationList : NSMutableArray = NSMutableArray()
    var startLocationList : NSMutableArray = NSMutableArray()
    var travelModeList : NSMutableArray = NSMutableArray()
    var duration:Float = Float()
    var distance:Double = Double()
    
    var routeLine: GMSPolyline!
    var orginRouteLine: GMSPolyline!
    var destRouteLine: GMSPolyline!
    var travelMode:String = String()
    var origin: CLLocationCoordinate2D!
    var destination: CLLocationCoordinate2D!
    
    // let dataProvider = GoogleDataProvider()
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        directionImg.hidden = true
        //locationHandler.delegate = self
        //locationHandler.startUpdating()
        
        Utils.addCornerRadius(distanceLbl)
        Utils.addCornerRadius(durationLbl)
        
        self.travelMode = "driving"
        carModeBtn.setImage(UIImage(named: "Car_Sel"), forState: UIControlState.Normal)
        busModeBtn.setImage(UIImage(named: "Bus_UnSel"), forState: UIControlState.Normal)
        walkModeBtn.setImage(UIImage(named: "Walk_UnSel"), forState: UIControlState.Normal)
        bicycleModeBtn.setImage(UIImage(named: "By_UnSel"), forState: UIControlState.Normal)
        
        
        
        
        if(appDelegate.currentLocation != nil && currentJob.lat != nil && currentJob.lng != nil)
        {
            
            println("appDelegate.currentLocation::::\(appDelegate.currentLocation.latitude)")
            println("appDelegate.currentLocation::::\(appDelegate.currentLocation.longitude)")
            self.origin =  appDelegate.currentLocation
            
            println("currentJob.lat::::\(currentJob.lat)")
            println("currentJob.lng::::\(currentJob.lng)")
            self.destination = CLLocationCoordinate2DMake(currentJob.lat, currentJob.lng)
            
            self.setDirections()
            
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //locationHandler.startUpdating()
        //locationHandler.startUpdatingHeading()
        
        //        var direction:CLLocationDirection =   GMSGeometryHeading(origin, destination)
        //        println("direction::::\(direction)")
        //        self.directionImg.transform = CGAffineTransformMakeRotation(CGFloat(direction))
        
        
        //bearingAngle = setLatLonForDistanceAndAngle(appDelegate.currentLocation, toLatitude: currentJob.lat, toLonngitude: currentJob.lng)
        //self.directionImg.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(arrowDirection ) + bearingAngle))
        
        
        
    }
    override func viewWillDisappear(animated: Bool)
    {
        //locationHandler.stopUpdatingHeading()
    }
    
    var randomLineColor: UIColor
        {
        get
        {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }

    
    func setDirections()
    {
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(origin.latitude, longitude: origin.longitude, zoom: 12.50)
        
        mapView.camera = camera
        //mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        
        //Origin Location
        let locationMarkerOri = GMSMarker(position: origin)
        locationMarkerOri.map = self.mapView
        locationMarkerOri.appearAnimation = kGMSMarkerAnimationPop
        locationMarkerOri.icon = UIImage(named: "userLoca.png")
        locationMarkerOri.opacity = 1.0
        //locationMarkerOri.flat = true
        
        //Destination Location
        let locationMarkerDest = GMSMarker(position: destination)
        locationMarkerDest.map = mapView
        locationMarkerDest.appearAnimation = kGMSMarkerAnimationPop
        
        if(currentJob.isEvent == "0")
        {
            locationMarkerDest.icon = UIImage(named: "Pin-job.png")
            locationMarkerDest.snippet = "Job Location"
        }
         if(currentJob.isEvent == "1")
        {
            locationMarkerDest.icon = UIImage(named: "Pin-event.png")
            locationMarkerDest.snippet = "Event Location"
        }
        if(currentJob.isEvent == "2")
        {
            locationMarkerDest.icon = UIImage(named: "Pin_green.png")
            locationMarkerDest.snippet = "Event Location"
        }

        
        locationMarkerDest.opacity = 1.0
        //locationMarkerDest.flat = true
        
        
        
        
        self.setDirectionsFrom(self.origin, to: self.destination, travelMode: self.travelMode)
    }
    
    func setDirectionsFrom(origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D , travelMode: String)
    {
        
        let GMdistanceInMeters:CLLocationDistance = GMSGeometryDistance(origin, destination)
        println("GMdistanceInMiles:::::::: \(GMdistanceInMeters * 0.000621371192)")
        
        
        appDelegate.showLoadingView(nil)
        
        self.fetchDirectionsFrom(origin , to: destination , travelMode:travelMode)
            {
                optionalRoute in
                
                
                if(optionalRoute == "No Routes")
                {
                    
                    appDelegate.hideLoadingView()
                    self.distanceLbl.text = "No"
                    self.durationLbl.text = "Route"
                    appDelegate.showToastMessage(kAppName, message: "Unable to fetch route ,please try other travel mode.")
                }
                else if let encodedRoute = optionalRoute
                {
                    appDelegate.hideLoadingView()
                    
                    // println("travelModeList::::\(self.travelModeList)")
                    println("totalDistance::::\(self.totalDistance)")
                    println("totalDuration::::\(self.totalDuration)")
                    
                    self.distanceLbl.text = self.totalDistance
                    self.durationLbl.text = self.totalDuration
                    
                    self.mapView.clear()
                    
                    
                    
                    let path = GMSPath(fromEncodedPath: encodedRoute)
                    self.routeLine = GMSPolyline(path: path)
                    self.routeLine.strokeWidth = 3.0
                    self.routeLine.strokeColor =  UIColor.blueColor() // self.randomLineColor //
                    self.routeLine.tappable = true
                    self.routeLine.geodesic = true
                   // self.routeLine.map = self.mapView
                    
                    // Origin to First point
                    let oriPath = GMSMutablePath()
                    oriPath.addCoordinate(origin)
                    oriPath.addCoordinate(path.coordinateAtIndex(0))
                    self.orginRouteLine = GMSPolyline(path: oriPath)
                    
                    let clearColor = GMSStrokeStyle.solidColor(UIColor.clearColor())
                    let solidBlue = GMSStrokeStyle.solidColor(UIColor.darkGrayColor())
                    
                    self.orginRouteLine.spans = [GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09),
                        GMSStyleSpan(style: solidBlue, segments:0.09)
                    ];
                    
                    
                    self.orginRouteLine.strokeWidth = 3.0
                    self.orginRouteLine.geodesic = true
                    //self.orginRouteLine.map = self.mapView
                    
                    
                    
                    // Destination to last point
                    let desPath = GMSMutablePath()
                    desPath.addCoordinate(destination)
                    desPath.addCoordinate(path.coordinateAtIndex(path.count() - 1))
                    self.destRouteLine = GMSPolyline(path: desPath)
                    
                    self.destRouteLine.spans = [GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09) ,
                        GMSStyleSpan(style: solidBlue, segments:0.09) ,
                        GMSStyleSpan(style: clearColor, segments:0.09),
                        GMSStyleSpan(style: solidBlue, segments:0.09)
                    ];
                    
                    
                    self.destRouteLine.strokeWidth = 3.0
                    self.destRouteLine.geodesic = true
                   // self.destRouteLine.map = self.mapView
                    
                    
                    
                    
                    //Origin Location
                    // var firstLocation: CLLocation = self.startLocationList.firstObject as! CLLocation
                    // var firstPoint: CLLocationCoordinate2D = firstLocation.coordinate
                    
                    let locationMarkerOri = GMSMarker(position: origin) //path.coordinateAtIndex(0)
                    locationMarkerOri.map = self.mapView
                    locationMarkerOri.appearAnimation = kGMSMarkerAnimationPop
                    locationMarkerOri.icon = UIImage(named: "userLoca.png")
                    locationMarkerOri.opacity = 1.0
                    locationMarkerOri.flat = true
                    
                    
                    let circ:GMSCircle = GMSCircle(position: path.coordinateAtIndex(0), radius: 0.1)
                    
                    circ.fillColor = UIColor.blueColor()
                    circ.strokeColor = UIColor.blueColor()
                    circ.strokeWidth = 1
                   // circ.map = self.mapView
                    
                    
                    //
                    //                var circ1:GMSCircle = GMSCircle(position: path.coordinateAtIndex(0), radius: 0.3)
                    //
                    //                circ1.fillColor = UIColor.whiteColor()
                    //                //circ.strokeColor = UIColor.orangeColor()
                    //                circ1.strokeWidth = 1
                    //                circ1.map = self.mapView
                    
                    
                    
                    let circ2:GMSCircle = GMSCircle(position: path.coordinateAtIndex(path.count() - 1), radius: 0.1)
                    
                    circ2.fillColor = UIColor.blueColor()
                    circ2.strokeColor = UIColor.blueColor()
                    circ2.strokeWidth = 1
                   // circ2.map = self.mapView
                    
                    
                    //
                    //                var circ3:GMSCircle = GMSCircle(position: path.coordinateAtIndex(path.count() - 1), radius: 0.3)
                    //
                    //                circ3.fillColor = UIColor.whiteColor()
                    //                //circ.strokeColor = UIColor.orangeColor()
                    //                circ3.strokeWidth = 1
                    //                circ3.map = self.mapView
                    
                    
                    
                    
                    //Destination Location
                    //                var lastLocation: CLLocation = self.endLocationList.lastObject as! CLLocation
                    //                var lastPoint: CLLocationCoordinate2D = lastLocation.coordinate
                    
                    let locationMarkerDest = GMSMarker(position:destination )// path.coordinateAtIndex(path.count() - 1)
                    locationMarkerDest.map = self.mapView
                    locationMarkerDest.appearAnimation = kGMSMarkerAnimationPop
                    if(currentJob.isEvent == "0")
                    {
                        locationMarkerDest.icon = UIImage(named: "Pin-job.png") //  "map_job.png"
                         locationMarkerDest.snippet = "Job Location"
                    }
                    else if(currentJob.isEvent == "1")
                    {
                        locationMarkerDest.icon = UIImage(named: "Pin-event.png" ) //  "map_event.png"
                         locationMarkerDest.snippet = "Event Location"
                        
                    }
                  
                    locationMarkerDest.opacity = 1.0
                   
                    //locationMarkerDest.flat = true
                    
                    
                    
//                   self.mapView.settings.myLocationButton = true
//                    self.mapView.myLocationEnabled = true
//                    
//                   self.mapView.settings.indoorPicker = true
//                    self.mapView.indoorEnabled = true
                    
                    self.mapView.settings.compassButton = true
                    
                    
                    
                    self.mapView.selectedMarker = nil
                    
                    
                    let bounds = GMSCoordinateBounds(path: path)
                    
                    self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 60.0))//30.0
                }
        }
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func carBtnAction(sender: UIButton)
    {
        // self.routeLine.map = nil
        self.mapView.clear()
        self.travelMode = "driving"
        carModeBtn.setImage(UIImage(named: "Car_Sel"), forState: UIControlState.Normal)
        busModeBtn.setImage(UIImage(named: "Bus_UnSel"), forState: UIControlState.Normal)
        walkModeBtn.setImage(UIImage(named: "Walk_UnSel"), forState: UIControlState.Normal)
        bicycleModeBtn.setImage(UIImage(named: "By_UnSel"), forState: UIControlState.Normal)
        
        self.setDirectionsFrom(self.origin, to: self.destination, travelMode: self.travelMode)
    }
    @IBAction func busBtnAction(sender: UIButton)
    {
        //self.routeLine.map = nil
        self.mapView.clear()
        self.travelMode = "transit"
        carModeBtn.setImage(UIImage(named: "Car_UnSel"), forState: UIControlState.Normal)
        busModeBtn.setImage(UIImage(named: "Bus_Sel"), forState: UIControlState.Normal)
        walkModeBtn.setImage(UIImage(named: "Walk_UnSel"), forState: UIControlState.Normal)
        bicycleModeBtn.setImage(UIImage(named: "By_UnSel"), forState: UIControlState.Normal)
        
        self.setDirectionsFrom(self.origin, to: self.destination, travelMode: self.travelMode)
    }
    @IBAction func walkBtnAction(sender: UIButton)
    {
        //self.routeLine.map = nil
        self.mapView.clear()
        self.travelMode = "walking"
        carModeBtn.setImage(UIImage(named: "Car_UnSel"), forState: UIControlState.Normal)
        busModeBtn.setImage(UIImage(named: "Bus_UnSel"), forState: UIControlState.Normal)
        walkModeBtn.setImage(UIImage(named: "Walk_Sel"), forState: UIControlState.Normal)
        bicycleModeBtn.setImage(UIImage(named: "By_UnSel"), forState: UIControlState.Normal)
        
        self.setDirectionsFrom(self.origin, to: self.destination, travelMode: self.travelMode)
    }
    
    @IBAction func bicycleBtnAction(sender: UIButton)
    {
        // self.routeLine.map = nil
        self.mapView.clear()
        self.travelMode = "bicyling"
        carModeBtn.setImage(UIImage(named: "Car_UnSel"), forState: UIControlState.Normal)
        busModeBtn.setImage(UIImage(named: "Bus_UnSel"), forState: UIControlState.Normal)
        walkModeBtn.setImage(UIImage(named: "Walk_UnSel"), forState: UIControlState.Normal)
        bicycleModeBtn.setImage(UIImage(named: "By_Sel"), forState: UIControlState.Normal)
        
        self.setDirectionsFrom(self.origin, to: self.destination, travelMode: self.travelMode)
    }
    
    
    @IBAction func backToJobsList(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //TODO: Commeneted backup
    //    func fetchDirectionsFrom(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, travelMode:String, completion: ((String?) -> Void)) -> ()
    //    {
    //        println("travel_mode = ::::\(travelMode)")
    //        let urlString = "https://maps.googleapis.com/maps/api/directions/json?key=\(apiKey)&origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&mode=\(travelMode)"
    //
    //        // println("urlString::::\(urlString)")
    //
    //        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    //
    //        session.dataTaskWithURL(NSURL(string: urlString)!)
    //            {data, response, error in
    //                // println("data::::\(data)")
    //                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //                var encodedRoute: String?
    //                if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? [String:AnyObject]
    //                {
    //                     println("json::::\(json)")
    //                    if let routes = json["routes"] as AnyObject? as? [AnyObject]
    //                    {
    //                         println("routes::::\(routes)")
    //                        if let route = routes.first as? [String : AnyObject]
    //                        {
    ////                             println("origin::::::: \(self.origin.latitude)  \(self.origin.longitude)")
    //                             println("route::::\(route)")
    //
    //                            if let polyline = route["overview_polyline"] as AnyObject? as? [String : String]
    //                            {
    //                                println("polyline::::\(polyline)")
    //                                if let points = polyline["points"] as AnyObject? as? String
    //                                {
    //                                     println("points::::\(points)")
    //                                    encodedRoute = points
    //                                    println("encodedRoute::::\(encodedRoute)")
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //                dispatch_async(dispatch_get_main_queue())
    //                    {
    //                        completion(encodedRoute)
    //                }
    //            }.resume()
    //    }
    
    
    
    
    
    
    func fetchDirectionsFrom(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, travelMode:String, completion: ((String?) -> Void)) -> ()
    {
        println("travel_mode = ::::\(travelMode)")
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?key=\(apiKey)&origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&mode=\(travelMode)"
        
        // println("urlString::::\(urlString)")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        session.dataTaskWithURL(NSURL(string: urlString)!)
            {
                data, response, error in
                //                println("response::::\(response)")
                //                println("error::::\(error)")
                
                //                if(response["status"])
                //                {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                var encodedRoute: String?
                if let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options:[])) as? [String:AnyObject]
                {
                    
                    
                    var routes: NSArray = json["routes"] as! NSArray
                    //println("routes::::\(routes)")
                    
                    if(routes.count != 0)
                    {
                        let firstRoute: NSDictionary = routes.objectAtIndex(0) as! NSDictionary
                        //println("firstRoute::::\(firstRoute)")
                        
                        let leg: NSDictionary = firstRoute["legs"]!.objectAtIndex(0) as! NSDictionary
                        //println("leg::::\(leg)")
                        
                        let steps: NSArray = leg["steps"] as! NSArray
                        // println("steps::::\(steps)")
                        
                        var step: NSDictionary!
                        for (index, item) in steps.enumerate()
                        {
                            step = item as! NSDictionary
                            //println("step::::\(step)")
                            
                            let distanceD: NSDictionary = step["distance"] as! NSDictionary
                            //self.calcuateTotalDistance(distanceD["text"] as! String)
                            
                            let durationD: NSDictionary = step["duration"] as! NSDictionary
                            //self.calcuateTotalDuration(durationD["text"] as! String)
                            
                            let startLocationD: NSDictionary = step["start_location"] as! NSDictionary
                            self.startLocationList.addObject(self.coordinateWithLocation(startLocationD))
                            
                            let endLocationD: NSDictionary = step["end_location"] as! NSDictionary
                            self.endLocationList.addObject(self.coordinateWithLocation(endLocationD))
                            
                            
                            let travelModeD: String = step["travel_mode"] as! String
                            self.travelModeList.addObject(travelModeD)
                            
                            
                        }
                        
                        if let routes = json["routes"] as AnyObject? as? [AnyObject]
                        {
                            
                            self.selectedRoute = (json["routes"] as! Array<Dictionary<NSObject, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<NSObject, AnyObject>
                            self.calculateTotalDistanceAndDuration()
                            
                            if let route = routes.first as? [String : AnyObject]
                            {
                                
                                if let polyline = route["overview_polyline"] as AnyObject? as? [String : String]
                                {
                                    
                                    if let points = polyline["points"] as AnyObject? as? String
                                    {
                                        
                                        encodedRoute = points
                                        
                                    }
                                }
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue())
                            {
                                completion(encodedRoute)
                        }
                        
                        
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue())
                            {
                                completion("No Routes")
                        }
                    }
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue())
                        {
                            completion("No Routes")
                    }
                    
                }
            }.resume()
        
        //}
        
    }
    
    
    func calculateTotalDistanceAndDuration()
    {
        let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
        }
        
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        let distanceInMiles: Double = Double(distanceInKilometers * 0.621371192)
        totalDistance =  String(format: "Distance: %.2f Miles", distanceInMiles)
        
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        if(days == 0)
        {
            totalDuration = "Duration: \(remainingHours) h : \(remainingMins) min : \(remainingSecs) sec"
        }
        if(hours == 0 && days == 0)
        {
            totalDuration = "Duration: \(remainingMins) min : \(remainingSecs) sec"
        }
        
        if(hours != 0 && days != 0)
        {
            totalDuration = "Duration: \(days) d : \(remainingHours) h : \(remainingMins) min : \(remainingSecs) sec"
            
        }
    }
    
    
    func coordinateWithLocation(location: NSDictionary) -> CLLocation
    {
        
        
        let lat: CLLocationDegrees = (location["lat"] as! NSNumber).doubleValue
        let long: CLLocationDegrees = (location["lng"] as! NSNumber).doubleValue
        
        let location: CLLocation = CLLocation(latitude: lat, longitude: long)
        
        return location
    }
    
    func calcuateTotalDuration(time: String)
    {
        
        var myStringArr = time.componentsSeparatedByString(" ")
        duration += (myStringArr[0] as NSString).floatValue
        
    }
    
    func calcuateTotalDistance(distan: String)
    {
        
        var myStringArr = distan.componentsSeparatedByString(" ")
        var distancetemp:Double = Double()
        if(myStringArr[1] == "km")
        {
            distancetemp = (myStringArr[0] as NSString).doubleValue * 1000
            
            
        }else if(myStringArr[1] == "m")
        {
            distancetemp = ((myStringArr[0] as NSString).doubleValue)
        }
        
        distance += distancetemp
        distance = distance * 0.000621371192
        
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
        print("Failed to pick the current location")
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
    
    
    //    class func callGoogleServiceToGetRouteDataFromSource(sourceLocation: CLLocation, toDestination destinationLocation: CLLocation, onMap mapView_: GMSMapView)
    //    {
    //        var baseUrl: String = "http://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation.coordinate.latitude),\(sourceLocation.coordinate.longitude)&destination=\(destinationLocation.coordinate.latitude),\(destinationLocation.coordinate.longitude)&sensor=false"
    //        var url: NSURL = NSURL.URLWithString(baseUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))
    //        NSLog("Url: %@", url)
    //        var request: NSURLRequest = NSURLRequest.requestWithURL(url)
    //
    //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
    //            {
    //            (response: NSURLResponse, data: NSData, connectionError: NSErrorPointer) in        var path: GMSMutablePath = GMSMutablePath.path()
    //
    //            var error: NSErrorPointer? = nil
    //            var result: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: 0, error: &error)
    //
    //            var routes: [AnyObject] = result["routes"]
    //
    //            var firstRoute: [NSObject : AnyObject] = routes.objectAtIndex(0)
    //
    //            var leg: [NSObject : AnyObject] = firstRoute["legs"].objectAtIndex(0)
    //
    //            var steps: [AnyObject] = leg["steps"]
    //
    //            var stepIndex: Int = 0
    //            var stepCoordinates: CLLocationCoordinate2D
    //
    //            for step: [NSObject : AnyObject] in steps
    //            {
    //                var start_location: [NSObject : AnyObject] = step["start_location"]
    //                stepCoordinates[++stepIndex] = self.coordinateWithLocation(start_location)
    //                path.addCoordinate(self.coordinateWithLocation(start_location))
    //                var polyLinePoints: String = step["polyline"]["points"]
    //                var polyLinePath: GMSPath = GMSPath.pathFromEncodedPath(polyLinePoints)
    //
    //                for var p = 0; p < polyLinePath.count; p++
    //                {
    //                    path.addCoordinate(polyLinePath.coordinateAtIndex(p))
    //                }
    //                if steps.count() == stepIndex
    //                {
    //                    var end_location: [NSObject : AnyObject] = step["end_location"]
    //                    stepCoordinates[++stepIndex] = self.coordinateWithLocation(end_location)
    //                    path.addCoordinate(self.coordinateWithLocation(end_location))
    //                }
    //            }
    //            var polyline: GMSPolyline? = nil
    //            polyline = GMSPolyline.polylineWithPath(path)
    //            polyline.strokeColor = UIColor.grayColor()
    //            polyline.strokeWidth = 3.
    //                polyline.map = mapView_
    //
    //        })
    //    }
    //
}