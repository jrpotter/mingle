//
//  MGIconButton.h
//
//  The icon button has both an icon and text with it. This is
//  used to wrap the two together and maintain text properties
//  on both during events.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGIconButton : UIButton
@property (strong, nonatomic) id identifier;
@property (strong, nonatomic) UILabel *icon;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) UIFont *iconFont;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@end
