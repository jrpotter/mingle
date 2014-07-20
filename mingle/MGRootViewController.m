//
//  MGRootViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGRootViewController.h"
#import "MGSpringboardViewController.h"

@interface MGRootViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MGSpringboardViewController *springboard;
@end

@implementation MGRootViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(self) {
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _springboard = [[MGSpringboardViewController alloc] init];
        [_springboard.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.springboard];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.springboard.view];
    
    // Add Constraints (Scroll View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    // Add Constraints (Springboard)
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-0-[board(==scroll)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterX
                                     metrics:nil
                                     views:@{@"board": self.springboard.view, @"scroll": self.scrollView}]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|-0-[board(==scroll)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterY
                                     metrics:nil
                                     views:@{@"board": self.springboard.view, @"scroll": self.scrollView}]];
}

@end
