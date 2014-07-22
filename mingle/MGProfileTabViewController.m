//
//  MGProfileTabViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/21/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileTabViewController.h"
#import "MGProfileViewController.h"
#import "MGFriendsListViewController.h"
#import "MGGroupsListViewController.h"

@interface MGProfileTabViewController ()
@property (strong, nonatomic) MGProfileViewController *profileController;
@property (strong, nonatomic) MGFriendsListViewController *friendsController;
@property (strong, nonatomic) MGGroupsListViewController *groupsController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@end

@implementation MGProfileTabViewController

#pragma mark - Initialization

- (id)initWithUserData:(NSDictionary *)userData personal:(BOOL)personal
{
    self = [super initWithLabel:@"Profile"];
    if (self) {
        
        _profileController = [[MGProfileViewController alloc] initWithUserData:userData personal:personal];
        _friendsController = [[MGFriendsListViewController alloc] init];
        _groupsController = [[MGGroupsListViewController alloc] init];
        
        _tabBarController = [[UITabBarController alloc] init];
        [_tabBarController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Build Hierarchy
    [self addChildViewController:self.tabBarController];
    [self.viewport addSubview:self.tabBarController.view];
    
    // Add Constraints (Tab Bar)
    [self.viewport addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[tab(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"tab": self.tabBarController.view, @"view": self.viewport}]];
    
    [self.viewport addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[tab(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"tab": self.tabBarController.view, @"view": self.viewport}]];
    
    // Build Tab Bar
    [self.tabBarController setViewControllers:@[self.profileController, self.friendsController, self.groupsController]];
    
    [self.profileController setTabBarItem:[[UITabBarItem alloc] initWithTitle:ME_ICON image:nil tag:0]];
    [self.profileController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -6)];
    [self.profileController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[BUTTON_FONT fontWithSize:30]} forState:UIControlStateNormal];
    
    [self.friendsController setTabBarItem:[[UITabBarItem alloc] initWithTitle:FRIENDS_ICON image:nil tag:0]];
    [self.friendsController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -6)];
    [self.friendsController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[BUTTON_FONT fontWithSize:30]} forState:UIControlStateNormal];
    
    [self.groupsController setTabBarItem:[[UITabBarItem alloc] initWithTitle:EVENT_ICON image:nil tag:0]];
    [self.groupsController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -6)];
    [self.groupsController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[BUTTON_FONT fontWithSize:30]} forState:UIControlStateNormal];
}


@end
