//
//  WFCentralSocket.swift
//  WFEmployee
//
//  Created by Tiwari, Ashutosh on 9/21/15.
//  Copyright © 2015 Wells Fargo. All rights reserved.
//

import UIKit

protocol CentralSocketDelegate : class {
    func socketDidOpen()
    func socketDidFailWithError(error: NSError)
    func socketSendFromUser() -> String
    func socketSendToUser() -> String
}
//Adding a protocol to handle the new messages received, implementing new protocol as CentralSocketDelegate is being used at different places and the methods in that protocol are "required"
@objc protocol CentralSocketChatDelegate:class
{
optional func didReceiveChatMessage(dictionary:NSDictionary)
}

class WFCentralSocket: NSObject, SRWebSocketDelegate {
    
    private var webSocket: SRWebSocket?
    private weak var delegate: CentralSocketDelegate?
    private(set) var isOpen = false
    var chatDelegate = CentralSocketChatDelegate!()
    
    
    func openSocketToURL(url: NSURL, delegate: CentralSocketDelegate?) {
        self.delegate = delegate
        let request = NSURLRequest(URL: url)
        self.webSocket = SRWebSocket(URLRequest: request)
        self.webSocket?.delegate = self
        self.webSocket?.open()
    }
    
//    func sendSession(session: DrawSession) {
//        let groups = session.drawGroups
//        for drawGroup in groups {
//            self.sendGroup(drawGroup)
//        }
//    }
//    
//    func sendGroup(drawGroup: DrawPointGroup) {
//        for point in drawGroup.drawPoints {
//            let function = (drawGroup.function == nil) ? DrawFunction.Add : drawGroup.function!
//            self.sendPoint(point, function: function, meetingId:"")
//        }
//    }
//    
//    func sendPoint(drawPoint: DrawPoint, function: DrawFunction, meetingId:String) {
//        if (!self.isOpen) { return }
//        var user = self.delegate?.socketSendFromUser()
//        user = (user == nil) ? "" : user
//        let dictionary = ["point" : NSStringFromCGPoint(drawPoint.point!), "type" : drawPoint.type.rawValue, "function" : function.rawValue, "sender" : user!] as NSDictionary
//        self.webSocket?.send(self.createSocketMessageForOperation("", message: dictionary, meetingId:meetingId))
//    }
    
    
    //MARK: SRWebSocketDelegate methods
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        var rawData: NSData?
        if (!(message is NSData) && !(message is NSString) && !(message is String)) {
            return;
        } else if (message is NSData) {
            rawData = message as? NSData
        } else {
            rawData = message.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        if (rawData == nil) { return }
        
        let data = try! NSJSONSerialization.JSONObjectWithData(rawData!, options: []) as! NSDictionary//<String, String>
        let whiteBoardDictString = data["message"] as? String
        let meetingId = data["meetingid"] as? String
        
        let messagecode  = data["messagecode"] as? String
        
        //If this message has a empty meeting id then it is either a Whiteboard msg or chat 1-1 msg. So here we dig down in the message to check if it has coordinates or a text message so it can be handled accordingly.
        if messagecode! .isEqual("StartMeeting") || messagecode! .isEqual("StartChat") || messagecode! .isEqual("")
        {
            
            if whiteBoardDictString!.rangeOfString("{") != nil{
                
            }
            else
            {
                self.chatDelegate?.didReceiveChatMessage!(data)
                return
            }
        }
        
        //        let data = try! NSJSONSerialization.JSONObjectWithData(rawData, options: []) as! NSDictionary//<String, String>
        //        if data["meetingid"] as! String == ""
        //        {
        //            if let whiteBoardDict = data["message"] as? String
        //            {
        //                if whiteBoardDict != "" {
        //                    let data = whiteBoardDict.dataUsingEncoding(NSUTF8StringEncoding)
        //                    let jsonDrawing = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        //                    let pointString = jsonDrawing["point"]
        //                    let dataTypeString = jsonDrawing["type"]
        //                    let function = jsonDrawing["function"]
        //                    if (pointString != nil && dataTypeString != nil  && function != nil) {
        //                        let point = CGPointFromString(pointString! as! String)
        //                        let type = DrawPointType(rawValue:dataTypeString! as! String)!
        //                        let drawFunction = DrawFunction(rawValue: function! as! String)!
        //                        self.delegate?.receiveDrawPoint(DrawPoint(point: point, type: type), function: drawFunction)
        //                    }
        //                }
        //            }
        
//        if (whiteBoardDictString == nil) { return }
//        let whiteBoardDictData = whiteBoardDictString!.dataUsingEncoding(NSUTF8StringEncoding)
//        if (whiteBoardDictData == nil) { return }
//        let whiteBoardDict = try?NSJSONSerialization.JSONObjectWithData(whiteBoardDictData!, options:[]) as! NSDictionary//<String, String>
//        
//        //if (meetingId != "") { return }
//        
//        let pointString = whiteBoardDict?["point"]
//        let dataTypeString = whiteBoardDict?["type"]
//        let function = whiteBoardDict?["function"]
//        if (pointString != nil && dataTypeString != nil  && function != nil) {
//            let point = CGPointFromString(pointString! as! String)
//            let type = DrawPointType(rawValue:dataTypeString! as! String)!
//            let drawFunction = DrawFunction(rawValue: function! as! String)!
//            let user = whiteBoardDict?["sender"] as? String
//            self.delegate?.receiveDrawPoint(DrawPoint(point: point, type: type, fromUser: user), function: drawFunction)
//        }
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("Its open")
        self.isOpen = true
        if let socketDelegateMethod = self.delegate?.socketDidOpen {
            socketDelegateMethod()
        }
        //self.webSocket?.send(self.createSocketMessageForOperation("StartChat", message: ""))
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceivePong pongPayload: NSData!) {
        print("Ping");
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print("error in socket = ", error)
        self.isOpen = false
        if let socketDelegateMethod = self.delegate?.socketDidFailWithError {
            socketDelegateMethod(error)
        }
    }
    
    // MARK: Helper methods
    func createSocketMessageForOperation(code: String, message: AnyObject, meetingId:String) -> String?
    {
        let currentActiveUser = self.delegate?.socketSendToUser()
        let selfUser = self.delegate?.socketSendFromUser()
        if (currentActiveUser == nil || selfUser == nil) { return nil }
        
        let jsonDictionary = NSMutableDictionary()
        if meetingId.isEmpty {
//            jsonDictionary["name"] = "chat"
//            jsonDictionary["touser"] = currentActiveUser!
        }
        else{
//            jsonDictionary["messagecode"] = "StartMeeting"
//            jsonDictionary["touser"] = ""
        }

        print(message);        
//        jsonDictionary["name"] = "chat"
        jsonDictionary["Message"] = message as! String
        jsonDictionary["MessageSenderID"] = selfUser!
        jsonDictionary["MessageReceiverID"] = currentActiveUser
        
        
        let dict = [
            "name": "chat",
            "args": jsonDictionary
        ]
        
        var data: NSData?
        let jsonStr: NSString?
        do {
            data = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
            
            //Changes - Yogish
            //Converting the NSData back to NSString and adding the UTF8 encoding so that we will send the encoded data
            jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        } catch _ {
            data = nil
            jsonStr = nil
        }
        
        return jsonStr as String?
    }
    
    //Posting a message to Socket
    func postMessage(message:String)
    {
        let message = self.createSocketMessageForOperation("", message:message, meetingId:"")
        print("Message to server is : \(message)");
        print(webSocket)
        webSocket?.send(message)
    }
    //Reusing above function but with changes in the way the dictionary is formed, as Group messages have quite a few changes in the parameters to be sent to server
    func postMessageGroup(message:String, meetingId:String)
    {
        let message = self.createSocketGroupMessageForOperation("", message: message, meetingId: meetingId)
        print("Message to server is : \(message)");
        
        webSocket?.send(message)
    }
    
    func postAcceptMeeting(code:String, meetingId:String)
    {
        let message = self.createSocketGroupMessageForOperation(code, message: "", meetingId: meetingId)
        
        webSocket?.send(message)
    }
    
    func createSocketGroupMessageForOperation(code: String, message: AnyObject, meetingId:String) -> String? {
        
        
        //        let currentActiveUser = self.delegate?.socketSendToUser()
        let selfUser = self.delegate?.socketSendFromUser()
        if (selfUser == nil) { return nil }
        
        let jsonDictionary = NSMutableDictionary()
        
        jsonDictionary["messagecode"] = code
        jsonDictionary["message"] = message
        jsonDictionary["meetingid"] = meetingId
        jsonDictionary["messagetype"] = ""
        jsonDictionary["sender"] = selfUser!
        jsonDictionary["received"] = ""
        jsonDictionary["touser"] = ""
        
        var data: NSData?
        let jsonStr: NSString?
        do {
            data = try NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: [])
            
            //Changes - Yogish
            //Converting the NSData back to NSString and adding the UTF8 encoding so that we will send the encoded data
            jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        } catch _ {
            data = nil
            jsonStr = nil
        }
        
        return jsonStr as String?
    }
    
    
}
