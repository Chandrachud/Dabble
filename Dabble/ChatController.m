//
//  ChatListController.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/24/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "ChatController.h"
#import "MessageController.h"
#import "ChatCell.h"
#import "Chat.h"
#import "LocalStorage.h"
#import <Realm/Realm.h>
#import "Dabble-Swift.h"

@interface ChatController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) RLMResults *chatResults;

@end


@implementation ChatController


- (IBAction)showMenu:(id)sender
{
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    [mainVC openLeftMenu];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
//     [self setTest];
//     [self setTest1];
    //    self.navigationController.navigationBarHidden = YES;m
    //    self.title = @"Chats";
    [self fetchAllModels];
    
    UIBarButtonItem *rightAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = rightAddButton;
}

- (void)rightButtonClicked:(id)sender
{
    NSLog(@"rightButtonClicked");
    [self performSegueWithIdentifier:@"addNewChat" sender:self];
    NSLog(@"rightButtonClicked");    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)setTableView
{
    self.tableData = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.backgroundColor = [UIColor clearColor];
}

-(void)setTest
{
    Chat *chat = [[Chat alloc] init];
    chat.sender_name = @"Chandrachud";
    chat.receiver_id = @"12345";
    chat.sender_id = @"54321";
    
    NSArray *texts = @[@"Hello!",
                       @"This project try to implement a chat UI similar to Whatsapp app.",
                       @"Is it close enough?"];
    
    Message *last_message = nil;
    for (NSString *text in texts)
    {
        Message *message = [[Message alloc] init];
        message.text = text;
        message.sender = MessageSenderSomeone;
        message.status = MessageStatusSent;
        message.chat_id = chat.identifier;
        
        [[LocalStorage sharedInstance] storeMessage:message];
        last_message = message;
    }
    
    chat.numberOfUnreadMessages = texts.count;
    chat.last_message = last_message;
    
    [self.tableData addObject:chat];
    
    //    // Persist your data easily
    //    let realm = RLMRealm.defaultRealm()
    //    realm.transactionWithBlock(){Void in
    //        realm.addObject(profile)
    //    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm transactionWithBlock:^{
        [realm beginWriteTransaction];
        [realm addObject:chat];
        [realm commitWriteTransaction];
        
//    }];
}

-(void)fetchAllModels
{
    RLMResults *models = [Chat allObjects];
    self.chatResults = models;
}

-(void)setTest1
{
    Chat *chat = [[Chat alloc] init];
    chat.sender_name = @"Chandrachud";
    chat.receiver_id = @"abcd";
    chat.sender_id = @"pqrs";
    
    NSArray *texts = @[@"Hello!",
                       @"This project try to implement a chat UI similar to Whatsapp app.",
                       @"Is it close enough?"];
    
    Message *last_message = nil;
    for (NSString *text in texts)
    {
        Message *message = [[Message alloc] init];
        message.text = text;
        message.sender = MessageSenderSomeone;
        message.status = MessageStatusSent;
        message.chat_id = chat.identifier;
        
        [[LocalStorage sharedInstance] storeMessage:message];
        last_message = message;
    }
    
    chat.numberOfUnreadMessages = texts.count;
    chat.last_message = last_message;
    
    [self.tableData addObject:chat];
    
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    //    [realm transactionWithBlock:^{
    //        [realm addObject:chat];
    //    }];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chatResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChatListCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.chat = [self.chatResults objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
    controller.chat = [self.chatResults objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return  YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

#pragma mark - AddNewChatControllerDelegate Method
-(void)didSelectToCreateNewChat:(NSArray *)toContactsArray
{
    NSString *identifier = [toContactsArray objectAtIndex:0];
    ChatOperations *chatOp = [[ChatOperations alloc]init];
    Chat *chat = [chatOp fetchChatWithIdentifier:identifier isGroupedChat:NO groupChatId:@""];
    MessageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
    controller.chat = chat;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
