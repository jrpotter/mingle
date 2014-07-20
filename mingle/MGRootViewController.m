//
//  MGRootViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGRootViewController.h"
#import "MGNavigationViewController.h"
#import "MGSpringboardViewController.h"
#import "MGProfileViewController.h"

@interface MGRootViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *viewport;
@property (strong, nonatomic) MGNavigationViewController *handle;
@property (strong, nonatomic) MGSpringboardViewController *springboard;
@end

@implementation MGRootViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(self) {
        
        _handle = nil;
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setBounces:NO];
        [_scrollView setScrollEnabled:NO];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _viewport = [[UIViewController alloc] init];
        [_viewport.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _springboard = [[MGSpringboardViewController alloc] init];
        [_springboard setDelegate:self];
        [_springboard.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_springboard setDelegate:nil];
}


#pragma mark - View

// Whenever this controller's view is presented, we want to
// make sure it is centered.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToViewport:NO];
}

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
                               constraintsWithVisualFormat:@"V:|-20-[scroll]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
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
    
    // Setup Display
    [self replaceViewport:[[MGProfileViewController alloc] init]];
}


#pragma mark - Scrolling

- (void)enableViewport:(BOOL)enable
{
    if(enable) {
        [self.handle.viewport setAlpha:1.0];
        [self.handle.viewport setUserInteractionEnabled:YES];
        [self.handle.viewport setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self.handle.viewport setAlpha:0.3];
        [self.handle.viewport setUserInteractionEnabled:NO];
        [self.handle.viewport setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)scrollToSpringboard:(BOOL)animated
{
    [self enableViewport:NO];
    [self.scrollView setContentOffset:self.springboard.view.frame.origin animated:animated];
}

- (void)toggleToSpringboard
{
    if(fabsf(self.scrollView.contentOffset.x - self.springboard.view.frame.origin.x) < 0.1) {
        [self scrollToViewport:YES];
    } else {
        [self scrollToSpringboard:YES];
    }
}

- (void)scrollToViewport:(BOOL)animated
{
    [self enableViewport:YES];
    [self.scrollView setContentOffset:self.viewport.view.frame.origin animated:animated];
}


#pragma mark - Branches

- (void)replaceViewport:(MGNavigationViewController *)controller
{
    if(self.handle) {
        [self.handle.view removeFromSuperview];
        [self.handle removeFromParentViewController];
        [self.handle.left removeTarget:self action:@selector(toggleToSpringboard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Prepare
    self.handle = controller;
    [self.handle.left addTarget:self action:@selector(toggleToSpringboard) forControlEvents:UIControlEventTouchUpInside];
    
    // Build Hierarchy
    [self.viewport addChildViewController:self.handle];
    [self.viewport.view addSubview:self.handle.view];
    
    // Layout
    [self.viewport.view addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-0-[handle(==view)]-0-|"
                                        options:NSLayoutFormatAlignAllCenterY
                                        metrics:nil
                                        views:@{@"handle": self.handle.view, @"view": self.viewport.view}]];
    
    [self.viewport.view addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-0-[handle(==view)]-0-|"
                                        options:NSLayoutFormatAlignAllCenterX
                                        metrics:nil
                                        views:@{@"handle": self.handle.view, @"view": self.viewport.view}]];
    
    
}

- (void)selectedBranch:(BRANCH)branch
{
    switch(branch) {
        case FEATURED_BRANCH:
        case BROWSE_BRANCH:
        case CREATE_BRANCH:
        case SEARCH_BRANCH:
        case SETTINGS_BRANCH:
        case PROFILE_BRANCH:
        case FRIENDS_BRANCH:
        case INVITE_BRANCH:
        case LOGOUT_BRANCH:
        case ABOUT_BRANCH:
            break;
    }
    
    [self scrollToViewport:YES];
}


@end
