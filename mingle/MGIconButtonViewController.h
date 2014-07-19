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

@interface MGIconButtonViewController : UIViewController
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIColor *pressColor;
- (void)setFont:(UIFont *)font;
- (id)initWithTitle:(NSString *)title icon:(NSString *)icon;
@end
