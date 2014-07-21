//
//  MGProfilePictureEditViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfilePictureEditViewController.h"

@interface MGProfilePictureEditViewController ()
@property (strong, nonatomic) UIView *buttonPanel;
@property (strong, nonatomic) UILabel *indicator;
@end

@implementation MGProfilePictureEditViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _indicator = [[UILabel alloc] init];
        [_indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _buttonPanel = [[UIView alloc] init];
        [_buttonPanel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _editButton = [[UIButton alloc] init];
        [_editButton.titleLabel setText:EDIT_ICON];
        
        _cropButton = [[UIButton alloc] init];
        [_cropButton.titleLabel setText:CROP_ICON];
        
        for(UIButton *button in @[_editButton, _cropButton]) {
            [button.titleLabel setTextColor:[UIColor whiteColor]];
            [button.titleLabel setFont:[BUTTON_FONT fontWithSize:15]];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.indicator];
    [self.view addSubview:self.buttonPanel];
    [self.buttonPanel addSubview:self.editButton];
    [self.buttonPanel addSubview:self.cropButton];
    
    // Add Constraints (Buttons)
    [self.buttonPanel addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-0-[edit]-[crop]-10-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"edit": self.editButton, @"crop": self.cropButton}]];
    
    // Add Constraints (Panel)
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.buttonPanel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0]];
    
    // Add Constraints (Indicator)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[indicator(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"indicator": self.indicator, @"view": self.view}]];
    
    // Vertically Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[indicator(==25)]-(>=0)-[panel(==35)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"indicator": self.indicator, @"panel": self.buttonPanel}]];
}


@end
