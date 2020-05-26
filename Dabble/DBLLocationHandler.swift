//
//  DBLLocationHandler.swift
//  Dabble
//
//  Created by Reddy on 7/29/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol DBLLocationHandlerDelegate
{
    optional func locationManager(manager: CLLocationManager!, didUpdateLocation location:CLLocation!)
    optional func locationManager(manager: CLLocationManager!, failedWithError error: NSError!)
    optional func locationManager(manager: CLLocationManager!, didUpdateNewHeading heading:CLHeading!)
}

let sharedManager = DBLLocationHandler()

class DBLLocationHandler: NSObject, CLLocationManagerDelegate
{
    var delegate: DBLLocationHandlerDelegate?
    var locationManager :CLLocationManager!
    var temp = 10
    var currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var GeoAngle = 0.0
    var marker = GMSMarker()
    var jobLat = Double()
    var jobLon = Double()
    
    func getCurrentLocation() -> CLLocationCoordinate2D
    {
        if (CLLocationManager .locationServicesEnabled() == false)
        {
            appDelegate.showToastMessage("LocationServices", message: "Please enable location services in settings")
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return currentLocation.coordinate
    }
    
    func getDistanceFromCoard(origin: CLLocationCoordinate2D) -> CGFloat
    {
        if (CLLocationManager .locationServicesEnabled() == false)
        {
            appDelegate.showToastMessage("LocationServices", message: "Please enable location services in settings")
            return 10.0
        }
        return 10.0
    }
    
    override init()
    {
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func isLocationServicesEnabled() -> Bool
    {
        if CLLocationManager.locationServicesEnabled()
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func startUpdating()
    {
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")))
        {
            if #available(iOS 8.0, *) {
                locationManager.requestWhenInUseAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            locationManager.startUpdatingLocation()
            self.startUpdatingHeading()
        }
    }
    
    
    
    func stopUpdating()
    {
        locationManager.stopUpdatingLocation()
        
    }
    
    
    func startUpdatingHeading()
    {
        
        locationManager.startUpdatingHeading()
    }
    
    
    func stopUpdatingHeading()
    {
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        println("didChangeAuthorizationStatus")
        if #available(iOS 8.0, *) {
            if status == CLAuthorizationStatus.AuthorizedWhenInUse
            {
                locationManager.startUpdatingLocation()
                self.startUpdatingHeading()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        let allLocations: NSArray = locations as NSArray
        currentLocation = allLocations[0] as! CLLocation
        appDelegate.currentLocation = currentLocation.coordinate
        appDelegate.usersLocation = currentLocation
        
        if (self.delegate != nil)
        {
            self.delegate!.locationManager!(manager, didUpdateLocation:locationObj)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        
        if (self.delegate != nil)
        {
            self.delegate!.locationManager!(manager, didUpdateNewHeading: newHeading)            
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        println("locationManager didFailWithError \(error)")
        
        self.delegate?.locationManager!(manager, failedWithError: error)
    }
    
    
    
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 190.0/M_PI
    }
    
    func DegreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    
    
    //    func locationManager(manager: CLLocationManager!,
    //        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    //    {
    //            var shouldIAllow = false
    //            var locationStatus:String? = nil
    //            switch status {
    //            case CLAuthorizationStatus.Restricted:
    //                locationStatus = "Restricted Access to location"
    //            case CLAuthorizationStatus.Denied:
    //                locationStatus = "User denied access to location"
    //            case CLAuthorizationStatus.NotDetermined:
    //                locationStatus = "Status not determined"
    //            default:
    //                locationStatus = "Allowed to location Access"
    //                shouldIAllow = true
    //            }
    //
    //            if (shouldIAllow == true)
    //            {
    //                NSLog("Location to Allowed")
    //                locationManager.startUpdatingLocation()
    //            }
    //            else
    //            {
    //                NSLog("Denied access: \(locationStatus)")
    //            }
    //    }
}
