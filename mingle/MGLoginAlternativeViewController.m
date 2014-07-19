//
//  MGLoginAlternativeViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGLoginAlternativeViewController.h"
#import "MGLoginAlternativeView.h"

@interface MGLoginAlternativeViewController ()
@property (strong, nonatomic) MGLoginAlternativeView *alternativeView;
@end

@implementation MGLoginAlternativeViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _alternativeView = [[MGLoginAlternativeView alloc] init];
        [_alternativeView setBackgroundColor:[UIColor blueColor]];
        [_alternativeView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Build Hierarchy
    [self.view addSubview:self.alternativeView];
    
    // Add Constraints (Alternative View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[alt(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"alt": self.alternativeView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[alt(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"alt": self.alternativeView, @"view": self.view}]];
}


@end
