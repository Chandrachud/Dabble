//
//  Job.swift
//  Dabble
//
//  Created by Reddy on 18/08/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import Foundation
// DEV-TODO: Location and Profile pic missed

class Job: NSObject
{
    var sourceView: String! // Indicates that , from which view controller it is being called, from Own jobs or View Jobs
    var jobDistance: String!
    var posterImage: UIImage!
    
    var isEdited = 0
    var jobTitle: String!
    var jobDescription: String!
    
    var images: NSArray!
    var audios: NSArray!
    var videos: NSArray!
    
    var amount: Double!
    var currency: String!
    var bids: NSArray!
    var validBids: NSMutableArray = NSMutableArray()

    var chatCommunication: Bool!
    var emailCommunication: Bool!
    
    var jobId: Int!
    var lat: Double!
    var lng: Double!
    var isEvent: String!
    
    var posterId: Int!
    var acceptedBidderId: Int!
    var volunteersEnabled: Bool!
    var noOfVolunteers: Int!
    
    var posterName: String!
    var startDate: NSTimeInterval!
    var endDate: NSTimeInterval!
    var createdDate: NSTimeInterval!
    var jobStatus: Int!
    
    func saveJob(dict: NSDictionary)
    {
        jobTitle = dict["jobTitle"] as? String
        amount = dict["amount"] as! Double
        audios = dict["audios"] as! NSArray
        images = dict["images"] as! NSArray
        videos = dict["videos"] as! NSArray
        
        bids = dict["bids"] as! NSArray
        chatCommunication = dict["chatCommunication"] as! Bool
        emailCommunication = dict["emailCommunication"] as! Bool        
        currency = dict["currency"] as! String
        jobDescription = dict["description"] as! String
        
        jobId = dict["jobId"] as! Int
        isEvent = dict["event"] as! String
        lat = dict["lat"] as! Double
        lng = dict["lng"] as! Double
        posterName = dict["posterName"] as! String
        
        volunteersEnabled = dict["volunteers"] as! Bool
        noOfVolunteers = dict["numberOfVolunteers"] as! Int
        
        startDate = dict["startDate"] as! NSTimeInterval
        endDate = dict["endDate"] as! NSTimeInterval
        createdDate = dict["createdDate"] as! NSTimeInterval
        posterId = dict["posterId"] as! Int
        jobStatus = dict["status"] as! Int
    }
}

var currentJob: Job! = Job()


