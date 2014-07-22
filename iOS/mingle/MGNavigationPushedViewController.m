//
//  MGNavigationPushedViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGNavigationPushedViewController.h"

@interface MGNavigationPushedViewController ()

@end

@implementation MGNavigationPushedViewController

#pragma mark - Initialization

- (id)initWithLabel:(NSString *)label
{
    self = [super initWithLabel:label];
    if (self) {
        
    }
    
    return self;
}

- (void)initializeLeftButton
{
    [super initializeLeftButton];
    [self.left setTitle:BACK_ICON forState:UIControlStateNormal];
}

- (void)initializeRightButton
{
    // Intentionally empty
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
