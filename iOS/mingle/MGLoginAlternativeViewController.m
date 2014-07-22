//
//  MGLoginAlternativeViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "MGLoginAlternativeViewController.h"
#import "MGIconButtonViewController.h"

@interface MGLoginAlternativeViewController ()
@property (strong, nonatomic) UIView *panel;
@property (strong, nonatomic) FBLoginView *facebookLogin;
@property (strong, nonatomic) MGIconButtonViewController *twitterLogin;
@end

@implementation MGLoginAlternativeViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _panel = [[UIView alloc] init];
        [_panel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _facebookLogin = [[FBLoginView alloc] init];
        [_facebookLogin setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _twitterLogin = [[MGIconButtonViewController alloc] initWithTitle:@"Login With Twitter" icon:TWITTER_ICON];
        [_twitterLogin.button setTextFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [_twitterLogin.button setSelectedTextColor:[UIColor whiteColor]];
        [_twitterLogin.view.layer setCornerRadius:5];
        [_twitterLogin.view setBackgroundColor:TWITTER_COLOR];
        [_twitterLogin.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return self;
}


#pragma mark - View

// Here we create a spiked pattern on the top of the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // Used to calculate waveform
    NSInteger triangleCount = 10;
    CGRect bounds = self.view.bounds;
    CGFloat delta = bounds.size.width / triangleCount;
    CGFloat triangleHeight = (2.0 / 3 * delta);
    
    // Here we mask the view for a triangular waveform pattern on the top
    CGFloat x = CGRectGetMinX(bounds);
    CGFloat y = CGRectGetMinY(bounds);
    [path moveToPoint:CGPointMake(x, y)];
    for(NSInteger i = 0; i < triangleCount; i++) {
        x += delta / 2;
        [path addLineToPoint:CGPointMake(x, y + triangleHeight)];
        x += delta / 2;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    // Finish off the rest of the sides
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds))];
    
    // Draw Path
    [mask setPath:path.CGPath];
    [self.view.layer setMask:mask];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build View Hierarchy
    [self addChildViewController:self.twitterLogin];
    [self.view addSubview:self.panel];
    [self.panel addSubview:self.facebookLogin];
    [self.panel addSubview:self.twitterLogin.view];
    
    // Add Constraints (Panel)
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.panel
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.7
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.panel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.panel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0]];
    
    // Add Constraints (Facebook)
    [self.panel addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-0-[facebook(==panel)]-0-|"
                                options:NSLayoutFormatAlignAllCenterY
                                metrics:nil
                                views:@{@"facebook": self.facebookLogin, @"panel": self.panel}]];
    
    // Add Constraints (Twitter)
    [self.panel addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-0-[twitter(==facebook)]-0-|"
                                options:NSLayoutFormatAlignAllCenterY
                                metrics:nil
                                views:@{@"twitter": self.twitterLogin.view, @"facebook": self.facebookLogin}]];
    
    // Vertically Align
    [self.panel addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[facebook]-[twitter(==facebook)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"facebook": self.facebookLogin, @"twitter": self.twitterLogin.view}]];
}


@end
