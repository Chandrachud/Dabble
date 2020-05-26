//
//  ChatOperations.swift
//  WFEmployee
//
//  Created by Chandu on 24/10/15.
//  Copyright © 2015 Wells Fargo. All rights reserved.
//

import UIKit


class ChatOperations: NSObject {
    
    
    func openMessageControllerForMessage(message:Message)
    {
        if let topController = UIApplication.topViewController() {
            
            if topController.isKindOfClass(MessageController)
            {
                return
            }
            
            let topNavCont = topController.navigationController
            if topNavCont == nil {return}
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let messageController: MessageController = mainStoryboard.instantiateViewControllerWithIdentifier("Message") as! MessageController
            //            let appDelegate = AppDelegate()
            let chat = self.fetchChatWithIdentifier((message.chat_id)!, isGroupedChat: false, groupChatId: "")
            if (chat != nil)
            {
                messageController.chat = chat
                topController.navigationController!.pushViewController(messageController, animated: true)
            }
        }
    }
    
    func fetchChatWithIdentifier(identifier:String, isGroupedChat:Bool, groupChatId:String) ->Chat!
    {
        let predicate = NSPredicate(format: "receiver_id BEGINSWITH [c]%@",identifier) // 1
        
        let rlmResults = Chat.objectsWithPredicate(predicate) as RLMResults!
        
        //No chat found with this identifier so creste a new one
        if rlmResults.count == 0
        {
            println("This is new chat");
            let realm = RLMRealm.defaultRealm()
            
            //            let profile = User.allObjects()
            
            //If only user profile found the chat can be initiated and saved else return nil which will be handeled from where the function ios called
            //            if let currentUserProfile = profile.firstObject(){
            
//            let rlmobject = currentUser as User
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
            println(filteredChat)
            return filteredChat
        }
    }
    
    func isModal(controller:UIViewController) -> Bool
    {
        return controller.presentedViewController == self
            || (controller.navigationController != nil && controller.navigationController?.presentingViewController?.presentedViewController == controller.navigationController)
            || controller.tabBarController?.presentingViewController is UITabBarController
    }
}