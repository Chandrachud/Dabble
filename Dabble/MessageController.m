//
//  MessageController.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "TableArray.h"
#import "MessageGateway.h"
#import <UIKit/UIKit.h>
#import "Inputbar.h"
#import "DAKeyboardControl.h"
#import <Realm/Realm.h>

#import "Dabble-Swift.h"

@interface MessageController() <InputbarDelegate, MessageGatewayDelegate,
                                    UITableViewDataSource, UITableViewDelegate, DBLServicesResponsesDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet Inputbar *inputbar;
@property (strong, nonatomic) TableArray *tableArray;
@property (strong, nonatomic) MessageGateway *gateway;
@property (nonatomic, strong) DBLServices *Server;
@property (nonatomic, retain) IQKeyboardReturnKeyHandler *returnKeyHandler;

@end




@implementation MessageController
- (IBAction)moveBackToList:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//----------

- (void)previousAction:(id)sender
{
    
}

- (void)nextAction:(id)sender
{
    
}

- (void)doneAction:(id)sender
{

}

- (void)registerForKeyboardHandler
{
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.returnKeyHandler.delegate = self;
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarByPosition;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self registerForKeyboardHandler];
    self.titleOfReceiver.text = self.chat.sender_name;
    self.Server = [[DBLServices alloc] init];
    self.Server.delegate = self;
    [self setInputbar];
    [self setTableView];
    [self setGateway];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak Inputbar *inputbar = _inputbar;
    __weak UITableView *tableView = _tableView;
    __weak MessageController *controller = self;
    
    self.view.keyboardTriggerOffset = inputbar.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = inputbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        inputbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y - 64;
        tableView.frame = tableViewFrame;
        [controller tableViewScrollToBottomAnimated:NO];
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
//    [self.view removeKeyboardControl];
    [self.gateway dismiss];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.tableArray.lastObject != nil )
    {
        NSLog(@"Last message is : %@",self.tableArray.lastObject);
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        self.chat.last_message = [self.tableArray lastObject];
        [realm commitWriteTransaction];
    }
}

#pragma mark -

-(void)setInputbar
{
    self.inputbar.placeholder = nil;
    self.inputbar.delegate = self;
    self.inputbar.leftButtonImage = [UIImage imageNamed:@"share"];
    self.inputbar.rightButtonText = @"Send";
    self.inputbar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];
}
-(void)setTableView
{
    self.tableArray = [[TableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
}

-(void)setGateway
{
    self.gateway = [MessageGateway sharedInstance];
    self.gateway.delegate = self;
    self.gateway.chat = self.chat;
    [self.gateway loadOldMessages];
}

-(void)setChat:(Chat *)chat
{
    _chat = chat;
    self.title = chat.sender_name;
}

#pragma mark - Actions

- (IBAction)userDidTapScreen:(id)sender
{
    [_inputbar resignFirstResponder];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableArray numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray numberOfMessagesInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.message = [self.tableArray objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.tableArray objectAtIndexPath:indexPath];
    return message.heigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableArray titleForSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    return view;
}
- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfSections = [self.tableArray numberOfSections];
    NSInteger numberOfRows = [self.tableArray numberOfMessagesInSection:numberOfSections-1];
    if (numberOfRows)
    {
        [_tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                                         atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - InputbarDelegate

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    if (![Utils isNetworkReachable])
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showToastMessage:@"" message:@"Please check your internet connectivity and try again."];
        return;
    }
    if (inputbar.text.length == 0)
    {
        return;
    }
    
    Message *message = [[Message alloc] init];
    message.text = inputbar.text;
    message.date = [NSDate date];
    message.chat_id = self.chat.receiver_id;
    NSLog(@"%@",self.chat.identifier);
    //Store Message in memory
    [self.tableArray addObject:message];
    
    //Insert Message in UI
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    [self.tableView beginUpdates];
    if ([self.tableArray numberOfMessagesInSection:indexPath.section] == 1)
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    
    //Send message to server
//    [self writeMessageToRealm:message];
//    self.gateway.meetingId = self.meetingId;
    
    [self.gateway sendMessage:message isGroupChat:NO groupChatId:@""];
}

-(void)writeMessageToRealm:(Message *)message
{
    RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:message];
        [realm commitWriteTransaction];
    
    //    realm.transactionWithBlock({ () -> Void in
    //        realm.addObject(message)
    //    })
    
  NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.chat.receiver_id], @"recipient", message.text, @"message", nil];
    NSLog(@"%@",postParams);
    [self.Server  processSendChat:postParams];
}

- (void)sendTextSuccess:(id)responseDict
{
    NSLog(@"Message Sent");
}

- (void)sendTextFailure:(NSError *)error
{
    NSLog(@"Sending Message Failed");
}

-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Left Button Pressed"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)inputbarDidChangeHeight:(CGFloat)new_height
{
    //Update DAKeyboardControl
    self.view.keyboardTriggerOffset = new_height;
}

#pragma mark - MessageGatewayDelegate

-(void)gatewayDidUpdateStatusForMessage:(Message *)message
{
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    MessageCell *cell = (MessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateMessageStatus];
}

-(void)gatewayDidReceiveMessages:(NSArray *)array
{
    [self.tableArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

-(void)gatewayDidReceiveNewMessages:(Message *)message
{
    [self.tableArray addObject:message];
    [self.tableView reloadData];
    
    [self tableViewScrollToBottomAnimated:YES];

}
@end
