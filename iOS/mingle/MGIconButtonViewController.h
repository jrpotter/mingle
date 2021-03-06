//
//  MGIconButtonViewController.h
//
//  The following allows for a user to specify both an icon and
//  a font in a button, synchronizing touch actions with both.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGIconButton.h"

@interface MGIconButtonViewController : UIViewController
@property (strong, nonatomic) MGIconButton *button;
- (id)initWithTitle:(NSString *)title icon:(NSString *)icon;
@end
