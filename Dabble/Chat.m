//
//  Chat.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "Chat.h"

@implementation Chat

-(NSString *)identifier
{
    return _receiver_id;
}

- (instancetype)init
{
    if( self = [super init])
    {
        self.sender_id = 0;
        self.sender_name = @"";
//        self.last_message = @"";
        self.receiver_id = 0;
        self.numberOfUnreadMessages = 0;
        self.groupChatId = @"";
    }
    return self;
}

@end
