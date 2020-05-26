//
//  DateAndDayProcessor.swift
//  ProWidok
//
//  Created by Ash Tiwari on 8/11/15.
//  Copyright (c) 2015 Ash Tiwari. All rights reserved.
//

enum WeekDay : Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

import UIKit

class DateAndDayProcessor: NSObject {
    
    var intDay : Int?
    var shouldStartDate : NSDate?
    var dayofWeek : WeekDay {
        get {
            return WeekDay(rawValue: intDay!)!
        }
    }
    
    func getDayOfTheWeek(date:NSDate)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayOfWeekString = dateFormatter.stringFromDate(date)
        return dayOfWeekString
    }
    
    func getDayAndDateForNextTwoWeeks(startDate:NSDate) -> NSArray
    {
        self.shouldStartDate = startDate
        var collectionArray = [NSDictionary]()
        for i in 0...20 { // because 2 weeks is 14 days
            let nextDate = self.getNextDay(i)
            let dateString = self.getStringFromDate(nextDate)
            let formattedDate = self.getDateStringInFormat(nextDate)
            let day = self.getDayOfTheWeek(nextDate)
            let isToday = nextDate.isToday()
            //Adding a month field to dictionary
            let month = self.getMonthFromDate(formattedDate)
            let dayDateDict = NSDictionary(objects: [formattedDate,dateString,day,isToday,month], forKeys: ["dateInFormat","date","day","isToday","month"])
            collectionArray.append(dayDateDict)
        }
        return collectionArray
    }
    
    func getNextDay(daysToAdd:Int) -> NSDate
    {
        let dayComponenet = NSDateComponents()
        dayComponenet.day = daysToAdd
        let theCalendar = NSCalendar.currentCalendar()
        return theCalendar.dateByAddingComponents(dayComponenet, toDate: self.shouldStartDate!, options: [])!
    }
    
    func getLastWeekTodaysDate() -> NSDate
    {
        let currentDate = NSDate()
        var lastWeekDate = NSDate()
        
        if #available(iOS 8.0, *) {
            lastWeekDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.WeekOfYear, value: -1, toDate: currentDate, options: NSCalendarOptions.MatchFirst)!
        } else {
            // Fallback on earlier versions
        }
        return lastWeekDate
    }
    
    func getStringFromDate(date:NSDate)->String
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd"
        return formatter.stringFromDate(date)
    }
    
    func getDateStringInFormat(date:NSDate)->String
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.stringFromDate(date)
    }
    
    // Adding this function to calculate NSDate from string when user scrolls to the end. When user scrolls to the end we have the date of the last cell in form of string which needs to be  converted to nsdate, hence this function
    func getDateFromString(stringDate:String)->NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date:NSDate = (dateFormatter.dateFromString(stringDate))!
        return date
        
    }
    // Parse the current date to knoe the month
    func getMonthFromDate(date:String)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date:NSDate = (dateFormatter.dateFromString(date))!
        
        dateFormatter.dateFormat = "MMMM"
        let monthStr = dateFormatter.stringFromDate(date)
        return monthStr
    }
    
    func getTimeFromDate(date:String)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY HH:mm"
        let dateStr = date
        let date:NSDate = dateFormatter.dateFromString(dateStr)!
        
        dateFormatter.dateFormat = "hh:mm a"
        let monthStr = dateFormatter.stringFromDate(date)
        return monthStr
    }
    func getFormattedDate(dateString:String)->NSDate
{
    var date = NSDate();
    // "Apr 1, 2015, 8:53 AM" <-- local without seconds
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
    let defaultTimeZoneStr = formatter.stringFromDate(date)
    formatter.timeZone = NSTimeZone(abbreviation: defaultTimeZoneStr)
    
    date = formatter.dateFromString(defaultTimeZoneStr)!
    return date
    }
}

extension NSDate {
    func isToday() -> Bool {
        let cal = NSCalendar.currentCalendar()
        if cal.respondsToSelector("isDateInToday:") {
            if #available(iOS 8.0, *) {
                return cal.isDateInToday(self)
            } else {
                // Fallback on earlier versions
            }
        }
        var components = cal.components(NSCalendarUnit.NSEraCalendarUnit .union(NSCalendarUnit.NSYearCalendarUnit) .union(NSCalendarUnit.NSMonthCalendarUnit) .union(NSCalendarUnit.NSDayCalendarUnit), fromDate:NSDate())
        let today = cal.dateFromComponents(components)!
        
        components = cal.components(NSCalendarUnit.NSEraCalendarUnit .union(NSCalendarUnit.NSYearCalendarUnit) .union(NSCalendarUnit.NSMonthCalendarUnit) .union(NSCalendarUnit.NSDayCalendarUnit), fromDate:self)
        
        let otherDate = cal.dateFromComponents(components)!
        return today.isEqualToDate(otherDate)
    }
}


