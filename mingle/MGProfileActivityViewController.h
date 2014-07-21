//
//  MGProfileActivityViewController.h
//
//  The following contains the display of activity in the Mingle
//  community (i.e. friends, events, and uploaded images). It contains
//  buttons with this information which allow the user to see more info
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGProfileActivityViewController : UIViewController
@property (strong, nonatomic) UIButton *friendsButton;
@property (strong, nonatomic) UIButton *eventsButton;
@property (strong, nonatomic) UIButton *imagesButton;
- (id)initWithUserData:(NSDictionary *)userData;
@end
