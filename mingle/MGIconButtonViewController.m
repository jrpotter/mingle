//
//  MGIconButtonViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGIconButtonViewController.h"

@interface MGIconButtonViewController ()
@property (strong, nonatomic) UILabel *icon;
@property (strong, nonatomic) UILabel *text;
@end

@implementation MGIconButtonViewController

#pragma mark - Initialization

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    self = [super init];
    if(self) {
        
        _pressColor = MINGLE_COLOR;
        
        _icon = [[UILabel alloc] init];
        [_icon setText:icon];
        [_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_icon setFont:[BUTTON_FONT fontWithSize:25]];
        [_icon sizeToFit];
        
        _text = [[UILabel alloc] init];
        [_text setText:title];
        [_text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_text setFont:[MINGLE_FONT fontWithSize:25]];
        [_text sizeToFit];
        
        _button = [[UIButton alloc] init];
        [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchDragExit];
        [_button addTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)dealloc
{
    [_button removeTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchDown];
    [_button removeTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchDragExit];
    [_button removeTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self unchangeColor];
    
    // Build Hierarchy
    [self.view addSubview:self.button];
    [self.button addSubview:self.icon];
    [self.button addSubview:self.text];
    
    // Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[button(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"button": self.button, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[button(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"button": self.button, @"view": self.view}]];
    
    [self.button addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|-15-[icon]-15-[text]"
                                 options:NSLayoutFormatAlignAllCenterY
                                 metrics:nil
                                 views:@{@"icon": self.icon, @"text": self.text}]];
    
    for(UILabel *label in @[self.icon, self.text]) {
        [self.button addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-10-[label]-10-|"
                                     options:NSLayoutFormatAlignAllCenterY
                                     metrics:nil
                                     views:@{@"label": label}]];
    }
}

#pragma mark - Setters

- (void)setFont:(UIFont *)font
{
    [_text setFont:font];
}


#pragma mark - Events

- (void)changeColor
{
    [self.icon setTextColor:self.pressColor];
    [self.text setTextColor:self.pressColor];
}

- (void)unchangeColor
{
    [self.icon setTextColor:[UIColor whiteColor]];
    [self.text setTextColor:[UIColor whiteColor]];
}


@end
