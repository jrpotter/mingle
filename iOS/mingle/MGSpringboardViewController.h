//
//  MGSpringboardViewController.h
//
//  The springboard is the main means of navigating throughout the application.
//  The current setup is as follows:
//    - Events: Browse, Create, Search, Settings
//    - Account: Profile, Invite, Logout
//    - About: About
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSpringboardViewControllerDelegate.h"

@interface MGSpringboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) NSObject<MGSpringboardViewControllerDelegate> *delegate;
@end
