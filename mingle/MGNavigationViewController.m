//
//  MGNavigationViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGNavigationViewController.h"

@interface MGNavigationViewController ()
@property (strong, nonatomic) UILabel *label;
@end

@implementation MGNavigationViewController

#pragma mark - Initialization

- (id)initWithLabel:(NSString *)label
{
    self = [super init];
    if (self) {
        
        _bar = [[UIView alloc] init];
        [_bar setBackgroundColor:MINGLE_COLOR];
        [_bar setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _label = [[UILabel alloc] init];
        [_label setText:label];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setFont:[MINGLE_FONT fontWithSize:25]];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label sizeToFit];
        
        _left = [[UIButton alloc] init];
        [_left setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _right = [[UIButton alloc] init];
        [_right setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _viewport = [[UIView alloc] init];
        [_viewport setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}

- (void)initializeLeftButton
{
    [self.left.titleLabel setFont:BUTTON_FONT];
    [self.left setTitle:SPRINGBOARD_ICON forState:UIControlStateNormal];
    [self.left setTitleColor:SPRINGBOARD_COLOR forState:UIControlStateSelected];
    [self.left setTitleColor:SPRINGBOARD_COLOR forState:UIControlStateHighlighted];
    
    // Add Constraints (Left Button)
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.left
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                             multiplier:1.0
                             constant:30]];
    
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.left
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.left
                             attribute:NSLayoutAttributeWidth
                             multiplier:1.0
                             constant:0]];
    
}

- (void)initializeRightButton
{
    [self.right.titleLabel setFont:BUTTON_FONT];
    [self.right setTitle:MESSAGES_ICON forState:UIControlStateNormal];
    [self.right setTitleColor:MESSAGES_COLOR forState:UIControlStateSelected];
    [self.right setTitleColor:MESSAGES_COLOR forState:UIControlStateHighlighted];
    
    // Add Constraints (Right Button)
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.right
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.left
                             attribute:NSLayoutAttributeWidth
                             multiplier:1.0
                             constant:0]];
    
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.right
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.left
                             attribute:NSLayoutAttributeHeight
                             multiplier:1.0
                             constant:0]];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.bar addSubview:self.left];
    [self.bar addSubview:self.right];
    [self.bar addSubview:self.label];
    [self.view addSubview:self.bar];
    [self.view addSubview:self.viewport];
    
    // Initialize Buttons (do after building hierarchy, since
    // constraints should be defined in those functions
    [self initializeLeftButton];
    [self initializeRightButton];
    
    // Add Constraints (Label)
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.label
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.bar
                             attribute:NSLayoutAttributeCenterX
                             multiplier:1.0
                             constant:0]];
    
    [self.bar addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.label
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.bar
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0
                             constant:0]];
    
    // Layout Horizontally
    [self.bar addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-10-[left]-(>=0)-[label]-(>=0)-[right]-10-|"
                              options:NSLayoutFormatAlignAllCenterY
                              metrics:nil
                              views:@{@"left": self.left, @"label": self.label, @"right": self.right}]];
    
    // Add Constraints (Bar/Viewport)
    for(UIView *subview in @[self.bar, self.viewport]) {
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[subview(==view)]-0-|"
                                   options:NSLayoutFormatAlignAllCenterY
                                   metrics:nil
                                   views:@{@"subview": subview, @"view": self.view}]];
    }
    
    // Layout Vertically
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[bar(==40)]-0-[viewport]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"bar": self.bar, @"viewport": self.viewport}]];
}


@end
