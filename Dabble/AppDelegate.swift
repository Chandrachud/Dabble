    //
    //  AppDelegate.swift
    //  Dabble
    //
    //  Created by Reddy on 6/30/15.
    //  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
    //
    import UIKit
    import Foundation

    extension UIApplication {
        class func topViewController(base: UIViewController? = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(selected)
                }
            }
            if let presented = base?.presentedViewController {
                return topViewController(presented)
            }
            return base
        }
    }
    
    @objc protocol ChatUpdateProtocol:class
    {
        optional func didSaveNewMsgToDatabase(message:Message)
    }
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate, DBLServicesResponsesDelegate, DBLLocationHandlerDelegate, CentralSocketDelegate,CentralSocketChatDelegate
    {
        var centralSocket = WFCentralSocket()
        var socket = SocketIOClient!()
        
        var window: UIWindow?
        var loadingView: UIView!
        var loadingTitle: UILabel!
        var Server = DBLServices()
        var toastAlert = UIAlertView()
        var locationHandler = DBLLocationHandler()
        var currentLocation: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: 37.7833, longitude: 122.4167) // Setting default location as sanfransisco to make sure not to crash.
        var usersLocation: CLLocation!
        var myDeviceToken: NSString = NSString()
        
        var sendMessageToUser:String!
        var sendMessageFromUser:String!
        var chatUpdateDelegate = ChatUpdateProtocol!()
        var dateAndDayProcessor = DateAndDayProcessor()
        var messageController = ChatOperations()
        
//        var brainTreeClientToken = String()
//        var brainTreeNonceCode = String()
//        var braintree: Braintree!
        
        var FBUserID = String()
        //    var FBToken = String()
        
//        var profilePic = UIImage(named: "avatar.png")
        
        func showToastMessage(title: String, message: String)
        {
            toastAlert.title = title
            toastAlert.message = message
            toastAlert.delegate = nil
            toastAlert.show()
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "dismissAlert", userInfo: nil, repeats: false)
        }
        
        func dismissAlert()
        {
            toastAlert.dismissWithClickedButtonIndex(0, animated: true)
        }
        
        func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
        {
            println("didReceiveRemoteNotification: \(userInfo)")
            
            //        var payload = userInfo["aps"] as! NSDictionary
            //        var alertDict =  payload["alert"] as! NSDictionary
            //        var message = alertDict["body"] as! String
            ////        var type = userInfo["notificationType"]  as! String
            ////        var senderId = userInfo["senderId"] as! String
            //
            //        appDelegate.window?.rootViewController = chatController
            appDelegate.showToastMessage("Dabble", message: "Notification received")
        }
        
        func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
        {
            println("Received Device Token: \(deviceToken)")
            myDeviceToken = ObjcUtils.getFormattedDeviceToken(deviceToken)
            println("Device Token string : \(myDeviceToken)")
        }
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
        {
            let floatVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
            if floatVersion >= 8.0
            {
                if #available(iOS 8.0, *) {
                    let type: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
                    let setting = UIUserNotificationSettings(forTypes: type, categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(setting)
                    UIApplication.sharedApplication().registerForRemoteNotifications()
                    
                } else {
                    // Fallback on earlier versions
                };
            }
            else
            {
                UIApplication.sharedApplication().registerForRemoteNotificationTypes([UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
            }
            
            IQKeyboardManager.sharedManager().enable = true
            IQKeyboardManager.sharedManager().disableInViewControllerClass(MessageController)
            
            AFNetworkReachabilityManager.sharedManager().startMonitoring()
            locationHandler.delegate = self
            locationHandler.startUpdating()

            AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
                if (status == AFNetworkReachabilityStatus.ReachableViaWiFi || status == AFNetworkReachabilityStatus.ReachableViaWWAN) && self.socket != nil && self.socket.status == SocketIOClientStatus.Closed
                {
                    self.initiate()
                }
            }
//            AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
//                println("Reachability status changed to : %i", status)
//                if (status == AFNetworkReachabilityStatus.ReachableViaWiFi || status == AFNetworkReachabilityStatus.ReachableViaWWAN) && self.socket != nil && self.socket.status == SocketIOClientStatus.Closed
//                {
//                    self.initiate()
//                }
//            }
            
            self.createLoadingView()
            Server.delegate = self
            GMSServices.provideAPIKey(googleMapsApiKey)
            
//            self.initiate()
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        func createLoadingView()
        {
            if loadingView == nil
            {
                loadingView = UIView(frame: UIScreen.mainScreen().bounds)
                loadingView?.backgroundColor = UIColor.whiteColor()
                loadingView?.alpha = 0.7
                let indicator = UIActivityIndicatorView()
                indicator.hidden = false
                indicator.color = UIColor.blackColor()
                indicator.startAnimating()
                loadingView?.addSubview(indicator)
                let center = loadingView.center
                indicator.center = center
                
                loadingTitle = UILabel(frame: UIScreen.mainScreen().bounds)
                loadingTitle.text = "Loading..."
                loadingTitle.font = kAppFont
                loadingTitle.textAlignment = NSTextAlignment.Center
                loadingView.addSubview(loadingTitle)
                loadingTitle.center = CGPointMake(center.x, center.y - 30)
                self.window?.addSubview(loadingView)
            }
        }
        
        func showLoadingView(title: String?)
        {
            self.window?.addSubview(loadingView)
            if title != nil
            {
                loadingTitle.text = title
            }
            loadingView.hidden = false
            loadingView.tag = loadingView.tag + 1
        }
        
        func hideLoadingView()
        {
            loadingView.tag = loadingView.tag - 1
            if loadingView.tag <= 0
            {
                loadingView.removeFromSuperview()
                loadingView.hidden = true
            }
        }
        
        func application(application: UIApplication,
            openURL url: NSURL,
            sourceApplication: String?,
            annotation: AnyObject) -> Bool {
                return FBSDKApplicationDelegate.sharedInstance().application(
                    application,
                    openURL: url,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
        }
        
        func applicationWillResignActive(application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(application: UIApplication) {
            
            self.socket.connect()
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
            //        FBSDKAppEvents.activateApp()
        }
        
        func applicationWillTerminate(application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        //MARK: Location Handler methods
        
        func locationManager(manager: CLLocationManager!, didUpdateLocation location:CLLocation!)
        {
            currentLocation = location.coordinate
            usersLocation = location
            //         println("APPDELEGATE currentLocation:::::: \(currentLocation.latitude)")
            //         println("APPDELEGATE currentLocation:::::: \(appDelegate.currentLocation.longitude)")
        }
        
        func locationManager(manager: CLLocationManager!, failedWithError error: NSError!)
        {
            
        }
        
        func locationManager(manager: CLLocationManager!, didUpdateNewHeading heading: CLHeading!)
        {
            
        }
        
        //Migration sample code for further requirement if we need to add any extra properties to the database
        //Here we are enumerating the migration object to add new firstName and lastName properties to chat class
        //This kind of enumeration is required as we are using realm for many objects like UserProfileModel,ChatModel and also Message Model.
        //So we need to specify to which of these models is the property being added to or else it would throw an exception.
        func realmMigrationConfiguration()
        {
            //        let config = RLMRealmConfiguration.defaultConfiguration()
            //
            //        config.schemaVersion = 1
            //        let migrationBlock: RLMMigrationBlock = { migration, oldSchemaVersion in
            //            if oldSchemaVersion < 1 {
            //                migration.enumerateObjects(UserProfile.className()) { oldObject, newObject in
            //                    if oldSchemaVersion < 1 {
            //                        // combine name fields into a single field
            //                        let key = oldObject!["userEmail"] as! String
            //                        newObject!["primaryKey"] = key
            //
            //                        //                        let firstName = oldObject!["firstName"] as! String
            //                        //let lastName = oldObject!["lastName"] as! String
            //                        //newObject?["fullName"] = "\(firstName) \(lastName)"
            //                    }
            //                }
            //            }
            //        }
            //        config.migrationBlock = migrationBlock
            //        RLMRealm.migrateRealm(config)
            //        RLMRealmConfiguration.setDefaultConfiguration(config)
            
            //setDefaultRealmSchemaVersion(1, migrationBlock)
        }
        
        //MARK: Socket Initialization and Delegate Methods
            func showMainViewController()
            {
//                self.initiate()
            }
        
            func initiate(){
//                if !self.centralSocket.isOpen {
//                    let userName = "TODO_CHAT"
//                    let URL = self.prepareSocketConnection(userName)
//                    self.centralSocket.openSocketToURL(URL, delegate: self)
//                    self.centralSocket.chatDelegate = self
//                
//
//                }
                 self.socket = SocketIOClient(socketURL:"http://104.197.91.16:3000")
                 self.socket.connect()
                self.socket.reconnects = false
                 self.addHandlers()
            }
        
        func addHandlers() {
            // Our socket handlers go here
            self.socket.onAny {
                println("Got event: \($0.event), with items: \($0.items)")
                
                self.socket.on("connect", callback: { (data, emmiter) -> Void in
                    if currentUser != nil
                    {                    
                        self.socket.emit("register", "\(currentUser.userID)")
                    }
                    else
                    {
                        println("Failed to register chat since current user is nil.")
                    }

                    self.socket.on("chat", callback: { (data, emmiter) -> Void in
                        println("Message Received: \(data)");
                        self.didReceiveChatMessage( data.first as! NSDictionary)
                    })
                    self.socket.on("disconnect", callback: { (data, emmiter) -> Void in
                        println("Socket Disconnected");
                        if currentUser != nil
                        {
                            if self.socket.status == SocketIOClientStatus.Closed && Utils.isNetworkReachable() == true
                            {
                                self.initiate()
                            }
                        }
                    })
                })
            }
        }
        
        func prepareSocketConnection(userName:String) -> NSURL
        {
//                let urlString = String(format: "ws://104.197.91.16:3000/WebSocketChat/chat/%@", arguments: [userName])
            let urlString = String(format: "http://104.197.91.16:3000/?userId=1")
            return NSURL(string: urlString)!
        }
        
            func socketDidOpen() {
                println("Succesfully opened the socket")
                // Call sync method here. Sender ID,
                
            }
        
            func socketDidFailWithError(error: NSError) {
                println("Some error occurred")
                println("Trying again")
//                self.initiate()
            }
        
        //Returning the value in sendMessageFromUser property which is set from the messageController so the message is sent to inteted person
            func socketSendFromUser() -> String
            {
//                let profile = User.allObjects()
        
                //If only user profile found the chat can be initiated and saved else return nil which will be handeled from where the function ios called
//                let currentUserProfile = profile.firstObject()
//                let rlmobject = currentUserProfile as! User
                let sendFromUser = "\(currentUser.userID)" //rlmobject["userEmail"] as! String
                return sendFromUser
            }
        //Returning the value in sendMessageToUser property which is set from the messageController so the message is sent to inteted person
        func socketSendToUser() -> String {
            
            return self.sendMessageToUser
        }
        
        func didReceiveChatMessage(dictionary: NSDictionary)
        {
            println(dictionary);
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                 self.raiseLocalNotification()
            })
            var sender = ""
            let senderId = dictionary.valueForKey("MessageSenderID") as! Int
            sender = "\(senderId)"
            
            let predicate = NSPredicate(format: "receiver_id BEGINSWITH [c]%@",sender) // 1
            
            let rlmResults = Chat.objectsWithPredicate(predicate) as RLMResults!
            
            if rlmResults.count == 0
            {
                println("This is new chat");
                let realm = RLMRealm.defaultRealm()
                
                let chat = Chat()
                chat.sender_name = dictionary["MessageSenderName"] as! String
                chat.receiver_id = sender//dictionary["sender"] as! String
                chat.sender_id = sender
                chat.numberOfUnreadMessages = 0
                chat.groupChatId = ""
                realm.transactionWithBlock({ () -> Void in
                    realm.addObject(chat)
                })
                self.saveMessageToRealm(dictionary, chatId: sender)
            }
            else
            {
                self.saveMessageToRealm(dictionary, chatId: sender)
            }
        }
        
        func saveMessageToRealm(dictionary:NSDictionary, chatId:String)
        {
            let message = Message()
            message.text = dictionary["Message"] as! String
            message.senderName = dictionary["MessageSenderName"] as! String
            message.sender = MessageSender.Someone
            message.chat_id = chatId//dictionary["sender"] as! String
            
            let realm = RLMRealm.defaultRealm()
            realm.transactionWithBlock({ () -> Void in
                realm.addObject(message)
                if ((self.chatUpdateDelegate) != nil)
                {
                    self.chatUpdateDelegate.didSaveNewMsgToDatabase!(message)
                }
                else
                {
                    if #available(iOS 8.0, *) {
                        self.raiseLocalNotification(message)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
        }
        
//        fetch all chat objects from realm
            func fetchChatList() ->RLMResults!
            {
                let models = Chat.allObjects()
        //        let chat = models.objectAtIndex(0)
                return models
            }
        //
        //Fetch Chat based on identifier
        func fetchChatWithIdentifier(identifier:String, isGroupedChat:Bool, groupChatId:String) ->Chat!
        {
            let predicate = NSPredicate(format: "receiver_id BEGINSWITH [c]%@",identifier) // 1
            
            let rlmResults = Chat.objectsWithPredicate(predicate) as RLMResults!
            
            //No chat found with this identifier so creste a new one
            if rlmResults.count == 0
            {
                println("This is new chat");
                let realm = RLMRealm.defaultRealm()
                
                let profile = currentUser.userID
                
                //If only user profile found the chat can be initiated and saved else return nil which will be handeled from where the function ios called
                //            if let currentUserProfile = profile.firstObject()
                //            {
                let rlmobject = currentUser as! User
                let chat = Chat()
                chat.sender_id = "\(identifier)"
                chat.sender_name = groupChatId
                chat.receiver_id = identifier
                chat.groupChatId = groupChatId
                realm.transactionWithBlock({ () -> Void in
                    realm.addObject(chat)
                    
                })
                return chat
                //            }
                //
                //            else
                //            { return nil
                //            }
            }
                // When found the chat as existing return it
            else
            {
                let filteredChat = rlmResults.objectAtIndex(0) as! Chat
                return filteredChat
            }
        }
        
        //fetch all message objects from realm
        func fetchMessagesForChatWithIdentifier(identifier:String) ->RLMResults!
        {
            let models = Message.allObjects()
            let predicate = NSPredicate(format: "chat_id BEGINSWITH %@",identifier) // 1
            let filteredMessages = models.objectsWithPredicate(predicate)
            return filteredMessages
        }
        
        func postAcceptMeeting(messageCode:String,meetingId:String)
        {
            self.centralSocket.postAcceptMeeting(messageCode, meetingId: meetingId)
            //        self.centralSocket.postAcceptMeeting("AcceptMeeting", meetingId: meetingId)
            
        }
        //Send Message To Server
        func postMessage(message:String)
        {
            let dict = ["MessageSenderID": currentUser.userID ,"MessageReceiverID":appDelegate.sendMessageToUser ,"Message": message, "MessageSenderName" : currentUser.firstName];
            println( "Message is :\(dict)")
            self.socket.emit("chat", dict)
            
//            self.centralSocket.postMessage(message)
        }
        
        func postGroupMessage(message:String, meetingId:String)
        {
            self.centralSocket.postMessageGroup(message, meetingId: meetingId)
        }
        
        @available(iOS 8.0, *)
        func raiseLocalNotification(message:Message)
        {
            let msgReceivedFrm = message.senderName as String!
            let messageText = message.text
            let alert = UIAlertController(title:msgReceivedFrm , message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
            let topViewCont = self.window!.rootViewController
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                switch action.style{
                case .Default:
                    println("default")
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    println("destructive")
                }
            }))
            let reply = UIAlertAction(title: "Reply", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.messageController.openMessageControllerForMessage(message)
            }
            alert.addAction(reply)
            
            topViewCont!.presentViewController(alert, animated: true, completion: nil)
            
            
            let localNotification:UILocalNotification = UILocalNotification()
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.alertAction = msgReceivedFrm
            localNotification.alertBody = messageText
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
        
    }
