//
//  Chat.h
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Message.h"
#import <Realm/Realm.h>

//
// This class is responsable to store information
// displayed in ChatController
//

@interface Chat : RLMObject
{
    
}
@property (strong, nonatomic) Message *last_message;
@property (strong, nonatomic) NSString *sender_name;
@property (strong, nonatomic) NSString *sender_id;
@property (strong, nonatomic) NSString *receiver_id;
@property (assign, nonatomic) NSInteger numberOfUnreadMessages;
@property (strong, nonatomic) NSString *groupChatId;

-(NSString *)identifier;
@end
