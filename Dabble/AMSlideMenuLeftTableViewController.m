//
//  AMSlideMenuLeftTableViewController.m
//  AMSlideMenu
//
// The MIT License (MIT)
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "AMSlideMenuLeftTableViewController.h"

#import "AMSlideMenuMainViewController.h"

#import "AMSlideMenuContentSegue.h"

#import <Foundation/Foundation.h>

@interface AMSlideMenuLeftTableViewController ()
@property (nonatomic, retain) NSArray *menuItems;
@property (strong, nonatomic) IBOutlet UITableView *menuListView;
@end

@implementation AMSlideMenuLeftTableViewController

/*----------------------------------------------------*/
#pragma mark - Lifecycle -
/*----------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _menuItems = [[NSArray alloc]initWithObjects:@"Home", @"Dashboard",@"My Profile", @"Payment & Subscription", @"Chat Conversations", @"FAQs", @"Logout", nil];
       _menuItems = [[NSArray alloc]initWithObjects:@"Home", @"Dashboard",@"My Profile", @"Chat Conversations", @"FAQs", @"Logout", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.menuListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                             animated:NO
                       scrollPosition:UITableViewScrollPositionTop];
}

- (void)openContentNavigationController:(UINavigationController *)nvc
{
#ifdef AMSlideMenuWithoutStoryboards
    AMSlideMenuContentSegue *contentSegue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"contentSegue" source:self destination:nvc];
    [contentSegue perform];
#else
    NSLog(@"This methos is only for NON storyboard use! You must define AMSlideMenuWithoutStoryboards \n (e.g. #define AMSlideMenuWithoutStoryboards)");
#endif
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        UIView *selectedView = [[UIView alloc]init];
//        selectedView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:238.0/255.0 blue:235.0/255.0 alpha:1.0];
//        cell.selectedBackgroundView =  selectedView;
    }

    cell.textLabel.textColor = [UIColor colorWithRed:82.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:238.0/255.0 blue:235.0/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Semibold" size:16.0f];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.textLabel.text = [_menuItems  objectAtIndex:indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:252.0/255.0 green:150.0/255.0 blue:87.0/255.0 alpha:1.0];
    return cell;
}

/*----------------------------------------------------*/
#pragma mark - TableView Delegate -
/*----------------------------------------------------*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mainVC respondsToSelector:@selector(navigationControllerForIndexPathInLeftMenu:)])
    {
        UINavigationController *navController = [self.mainVC navigationControllerForIndexPathInLeftMenu:indexPath];
        AMSlideMenuContentSegue *segue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"ContentSugue" source:self destination:navController];
        [segue perform];
    }
    else
    {
        NSString *segueIdentifier = [self.mainVC segueIdentifierForIndexPathInLeftMenu:indexPath];
        if (segueIdentifier && segueIdentifier.length > 0)
        {
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }
        else
        {
            printf("Logout Pressed");
            
            NSLog(@"%@ , %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBUserID"] ,
                  [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAuthCode"]);
        }
    }
}

@end

@interface UITableViewCell(Ext)

@end

@implementation UITableViewCell(Ext)

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.textLabel.textColor = [UIColor colorWithRed:252.0/255.0 green:150.0/255.0 blue:87.0/255.0 alpha:1.0];
    } else {
        self.textLabel.textColor = [UIColor colorWithRed:82.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    }
}

@end

