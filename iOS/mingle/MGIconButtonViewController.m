//
//  MGIconButtonViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGIconButtonViewController.h"

@interface MGIconButtonViewController ()

@end

@implementation MGIconButtonViewController

#pragma mark - Initialization

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    self = [super init];
    if(self) {
        _button = [[MGIconButton alloc] init];
        [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchDragExit];
        [_button addTarget:self action:@selector(unchangeColor) forControlEvents:UIControlEventTouchUpInside];
        
        [_button.icon setText:icon];
        [_button.text setText:title];
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
}


#pragma mark - Events

- (void)changeColor
{
    [self.button setSelected:YES];
}

- (void)unchangeColor
{
    [self.button setSelected:NO];
}


@end
