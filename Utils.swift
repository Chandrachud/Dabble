//
//  Utils.swift
//  Dabble
//
//  Created by Reddy on 7/3/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class Utils: NSObject
{
    class func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? false : true
        return result
    }

   class func isSmallIPhone() -> Bool
    {
        let deviceHeight :CGFloat = UIScreen.mainScreen().bounds.size.height;
        
        if (deviceHeight == 480)
        {
            return true;
        }
        return false;
    }    

//    class func isNetworkReachable() -> Bool
//    {
//        return AFNetworkReachabilityManager.sharedManager().reachable
//    }

    class func isNetworkReachable() -> Bool
    {
        let status = Reach().connectionStatus()
        switch status
        {
            case .Unknown, .Offline:
                return false
            case .Online(.WWAN):
                return true
            case .Online(.WiFi):
                return true
        }
    }
    
    class func getDateFormatterForFormat(format: String ) -> NSDateFormatter
    {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = format
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        return dateFormatter
    }
    
//    class func isIpadDevice() -> Bool
//    {
//        let deviceType = UIDevice.currentDevice().model
//        let aRange = deviceType.rangeOfString("iPad")
//        return (aRange.location == NSNotFound)?false:true
//    }
//    
//    class func isIphone5Device() -> Bool
//    {
//        return (![EHHelpers isIpadDevice] && [[UIScreen mainScreen] bounds].size.height > 480.0f) ? YES : NO;
//    }
    
    class func getAttributedLabel(rupees: Int , cents: Int , currency: String) -> NSMutableAttributedString
    {
        // USD
        let currencyFont: UIFont = UIFont(name: "verdana", size: 12.0)!
        
        let currencyFontDict: NSDictionary = NSDictionary(object:currencyFont, forKey: NSFontAttributeName)
        
        let currencyStr = NSMutableAttributedString(string: currency, attributes: currencyFontDict as? [String : AnyObject])
        
        // Amount : 100
        let currencyAmountFont: UIFont = UIFont(name: "verdana", size: 18.0)!
        
        let currencyAmountFontDict: NSDictionary = NSDictionary(object:currencyAmountFont, forKey: NSFontAttributeName)
        let currencyAmountStr = NSMutableAttributedString(string: "\(rupees)", attributes:currencyAmountFontDict as? [String : AnyObject] )
        
        // Paisa / Cents: 75
        
        let currencyCentsFont = UIFont(name: "verdana", size: 12.0)
        
        let currencyCentsDict: NSDictionary = NSDictionary(object:currencyCentsFont!, forKey: NSFontAttributeName)
        
        var currencyCentsStr:NSMutableAttributedString!
                
        if(cents < 10)
        {
            currencyCentsStr = NSMutableAttributedString(string: "0\(cents)", attributes: currencyCentsDict as? [String : AnyObject])
        }
        else
        {
            currencyCentsStr = NSMutableAttributedString(string:"\(cents)", attributes: currencyCentsDict as? [String : AnyObject])
        }
        
        let fontOffset = currencyAmountFont.capHeight - currencyFont.capHeight
        
        currencyStr.addAttribute(NSBaselineOffsetAttributeName, value: fontOffset, range: NSMakeRange(0, currencyStr.length))

        currencyCentsStr.addAttribute(NSBaselineOffsetAttributeName, value: fontOffset, range: NSMakeRange(0, currencyCentsStr.length))
        
        currencyStr.appendAttributedString(currencyAmountStr)
        currencyStr.appendAttributedString(currencyCentsStr)
        
        return currencyStr;
    }
    
    class func addCornerRadius(view: UIView)
    {
        view.layer.cornerRadius = 0.0
        view.layer.masksToBounds = true
    }
    
    class func statusMessageFor(statusCode: NSInteger)-> String
    {
        switch(statusCode)
        {
        case 0:
            return statusMessageFor0
        case 2:
            return statusMessageFor2
        case 101:
            return statusMessageFor101
        case 102:
            return statusMessageFor102
        case 103:
            return statusMessageFor103
        case 104:
            return statusMessageFor104
        case 105:
            return statusMessageFor105
        case 106:
            return statusMessageFor106
        case 107:
            return statusMessageFor107
        case 108:
            return statusMessageFor108
        case 400:
            return statusMessageFor400
        case 404:
            return statusMessageFor404
        case 500:
            return statusMessageFor500
        case 503:
            return statusMessageFor503
        default:
            return String(format: "Status message unavailable for code: %i", statusCode)
        }
    }
    
    class func getErrorMessageForFailureCode(errorCode: Int) -> String
    {
        return "The request timed out."
    
        switch(errorCode)
        {
        case -1004:
        return "Could not connect to server."
        case -1001:
        return "The request timed out."
        case 2:
        return "Pending"
        case 3:
        return "Retracted"
        case 4:
        return "Accepted"
        case 5:
        return "Completed"
        case 6:
        return "Retract Pending"
        default:
        return "0"
        }
    }    
    
    class func jobStatusMessage(status: Int) -> String
    {
        switch(status)
        {
        case 0:
            return "Active"
        case 1:
            return "Inactive"
        case 2:
            return "Pending"
        case 3:
            return "Retracted"
        case 4:
            return "Accepted"
        case 5:
            return "Completed"
        case 6:
            return "Retract Pending"
        case 7:
            return "Retract Pending"
        case 8:
            return "Retracted"
        case 9:
            return "Pending Approval"
        default:
            return "0"
        }
    }
            
    class func getSupportFormattedDate(dateString: String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
//        print(dateFormatter.stringFromDate(date!))
        return dateFormatter.stringFromDate(date!)
    }
    
    class func getSupportFormattedTime(dateString: String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let date = NSDate()
        dateFormatter.dateFormat = "HH:mm:ss"
        //        print(dateFormatter.stringFromDate(date!))
        return dateFormatter.stringFromDate(date)
    }
    
    
    
    class func registerForKeyboardActivities(target: UIViewController, var returnKeyHandler: IQKeyboardReturnKeyHandler!)
    {
//        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: target)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.Done
        returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.ByPosition
    }

    
    
   class func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage
    {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    class func isLocationServicesEnabled() -> Bool
    {
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() ==  CLAuthorizationStatus.Denied
        {
            return false
        }
        else
        {
            return true
        }
    }
}
