//
//  MessageGateway.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/4/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//
@class ChatUpdateProtocol;
#import "MessageGateway.h"
#import "LocalStorage.h"
#import "Dabble-Swift.h"

@interface MessageGateway()<ChatUpdateProtocol>
@property (strong, nonatomic) NSMutableArray *messages_to_send;
@property (strong, nonatomic) Message *receivedMessage;

@end


@implementation MessageGateway

+(id)sharedInstance
{
    static MessageGateway *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        self.messages_to_send = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)loadOldMessages
{
    //     *array = [[LocalStorage sharedInstance] queryMessagesForChatID:self.chat.receiver_id];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.chatUpdateDelegate = self;
    RLMResults *results = [delegate fetchMessagesForChatWithIdentifier:self.chat.receiver_id];
    
    NSArray  *array = [self RLMResultsToNSArray:results];
    
    if (self.delegate)
    {
        [self.delegate gatewayDidReceiveMessages:array];
    }
    NSArray *unreadMessages = [self queryUnreadMessagesInArray:array];
    [self updateStatusToReadInArray:unreadMessages];
}


-(NSArray*)RLMResultsToNSArray:(RLMResults *)results
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:results.count];
    for (RLMObject *object in results) {
        [array addObject:object];
    }
    return array;
}

-(void)updateStatusToReadInArray:(NSArray *)unreadMessages
{
    NSMutableArray *read_ids = [[NSMutableArray alloc] init];
    for (Message *message in unreadMessages)
    {
        message.status = MessageStatusRead;
        [read_ids addObject:message.identifier];
    }
    //    self.chat.numberOfUnreadMessages = 0;
    [self sendReadStatusToMessages:read_ids];
}
-(NSArray *)queryUnreadMessagesInArray:(NSArray *)array
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.status == %d", MessageStatusReceived];
    return [array filteredArrayUsingPredicate:predicate];
}
-(void)news
{
    
}
-(void)dismiss
{
    self.delegate = nil;
}

-(void)fakeMessageUpdate:(Message *)message
{
    [self performSelector:@selector(updateMessageStatus:) withObject:message afterDelay:2.0];
}
-(void)updateMessageStatus:(Message *)message
{
    if (message.status == MessageStatusSending)
        message.status = MessageStatusFailed;
    else if (message.status == MessageStatusFailed)
        message.status = MessageStatusSent;
    else if (message.status == MessageStatusSent)
        message.status = MessageStatusReceived;
    else if (message.status == MessageStatusReceived)
        message.status = MessageStatusRead;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gatewayDidUpdateStatusForMessage:)])
    {
        [self.delegate gatewayDidUpdateStatusForMessage:message];
    }
    
    //
    // Remove this when connect to your server
    // fake update message
    //
    if (message.status != MessageStatusRead)
        [self fakeMessageUpdate:message];
}

#pragma mark - Exchange data with API

-(void)sendMessage:(Message *)message isGroupChat:(BOOL)isGroupChat groupChatId:(NSString *)groupChatId
{
    //
    // Add here your code to send message to your server
    // When you receive the response, you should update message status
    // Now I'm just faking update message
    //
    //    [[LocalStorage sharedInstance] storeMessage:message];
    //[self fakeMessageUpdate:message];
    
    [self writeMessageToRealm:message];
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (isGroupChat) {
        [delegate postGroupMessage:message.text meetingId:groupChatId];
    }
    else
    {
        delegate.sendMessageToUser = message.chat_id;
        [delegate postMessage:message.text];
    }
    //TODO
}

-(void)writeMessageToRealm:(Message *)message
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:message];
    }];
    
    //    realm.transactionWithBlock({ () -> Void in
    //        realm.addObject(message)
    //    })
    
}
-(void)sendReadStatusToMessages:(NSArray *)message_ids
{
    if ([message_ids count] == 0) return;
    //TODO
}
-(void)sendReceivedStatusToMessages:(NSArray *)message_ids
{
    if ([message_ids count] == 0) return;
    //TODO
}

#pragma mark - ChatUpdateProtocol
-(void)didSaveNewMsgToDatabase:(Message *)message
{
    if ([message.chat_id isEqual:self.chat.receiver_id])  {
        
        if ([self.delegate respondsToSelector:@selector(gatewayDidReceiveNewMessages:)])  {
            [self.delegate gatewayDidReceiveNewMessages:message];
        }
        else
        {
            [self raiseLocalNitofication:message];
        }
    }
    else
    {
        [self raiseLocalNitofication:message];
    }
}

-(void)raiseLocalNitofication:(Message*)message
{
    //    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //    notification.fireDate = [NSDate date];
    //    notification.alertBody = @"24 hours passed since last visit :(";
    //    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    _receivedMessage = message;
    
    NSString *alertTitle = message.senderName;
    NSString *messageReceived = message.text;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertTitle message:messageReceived delegate:self cancelButtonTitle:@"Reply" otherButtonTitles:@"OK" , nil];
    [alert show];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setAlertAction:message.chat_id];
    [notification setAlertBody:message.text];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];    
}

-(void)postStartMeeting
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate postAcceptMeeting:@"StartMeeting" meetingId:self.chat.receiver_id];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ChatOperations *operations = [[ChatOperations alloc]init];
        [operations openMessageControllerForMessage:_receivedMessage];
    }
}
@end
