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
@property (strong, nonatomic) UIViewController *viewport;
@property (strong, nonatomic) MGSpringboardViewController *springboard;
@end

@implementation MGRootViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(self) {
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setBounces:NO];
        //[_scrollView setScrollEnabled:NO];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        //[_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _viewport = [[UIViewController alloc] init];
        [_viewport.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
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
    [self addChildViewController:self.viewport];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.springboard.view];
    [self.scrollView addSubview:self.viewport.view];
    
    // Add Constraints (Scroll View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-20-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.scrollView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:-20]];
    
    // Add Constraints (Viewport)
    [self.scrollView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:[viewport(==scroll)]"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"scroll": self.scrollView, @"viewport": self.viewport.view}]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[viewport(==scroll)]"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"scroll": self.scrollView, @"viewport": self.viewport.view}]];
    
    
    // Add Constraints (Springboard)
    [self.scrollView addConstraint:[NSLayoutConstraint
                                    constraintWithItem:self.springboard.view
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.viewport.view
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:1.0
                                    constant:-50]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-0-[board(==scroll)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterX
                                     metrics:nil
                                     views:@{@"board": self.springboard.view, @"scroll": self.scrollView}]];
    
    // Layout (Horizontal)
    NSDictionary *views = @{@"springboard": self.springboard.view, @"viewport": self.viewport.view};
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|-0-[springboard]-0-[viewport]-0-|"
                                     options:NSLayoutFormatAlignAllCenterY
                                     metrics:nil
                                     views:views]];
}

@end
