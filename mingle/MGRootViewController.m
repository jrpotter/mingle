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
#import "MGEventBrowseViewController.h"
#import "MGProfileViewController.h"
#import "MGAppDelegate.h"
#import "MGSession.h"

@interface MGRootViewController ()
@property (strong, nonatomic) NSMutableArray *branches;
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
        [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:BACKGROUND_IMAGE]];
        
        _viewport = [[UIViewController alloc] init];
        [_viewport.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_viewport.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        
        _springboard = [[MGSpringboardViewController alloc] init];
        [_springboard setDelegate:self];
        [_springboard.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Attempt to cache the branches we open
        _branches = [[NSMutableArray alloc] initWithCapacity:BRANCH_COUNT-1];
        for(NSUInteger i = 0; i < BRANCH_COUNT; i++) {
            [_branches addObject:[NSNull null]];
        }
        
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
}


#pragma mark - Scrolling

- (void)scrollToSpringboard:(BOOL)animated
{
    [self.handle.viewport setUserInteractionEnabled:NO];
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
    [self.handle.viewport setUserInteractionEnabled:YES];
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
    
    // Return back
    [self scrollToViewport:YES];
}

- (void)selectedBranch:(BRANCH)branch
{
    if([self.branches objectAtIndex:branch] != [NSNull null]) {
        [self replaceViewport:[self.branches objectAtIndex:branch]];
        return;
    }
    
    MGNavigationViewController *controller = nil;
    MGAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    switch(branch) {
            
        case BROWSE_BRANCH:
            controller = [[MGEventBrowseViewController alloc] init];
            break;
            
        case CREATE_BRANCH:
            break;
            
        case SEARCH_BRANCH:
            break;
            
        case SETTINGS_BRANCH:
            break;
            
        case PROFILE_BRANCH:
            controller = [[MGProfileViewController alloc] initWithUserData:[[MGSession instance] userData]];
            break;
            
        case INVITE_BRANCH:
            break;
            
        case LOGOUT_BRANCH:
            [[MGSession instance] logout];
            [appDelegate presentLoginViewController:YES];
            break;
            
        case ABOUT_BRANCH:
            break;
            
        default:
            break;
    }
    
    if(controller != nil) {
        [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.branches setObject:controller atIndexedSubscript:branch];
        [self replaceViewport:controller];
    }
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    // Wipe out non active controllers
    for(NSUInteger i = 0; i < BRANCH_COUNT; i++) {
        MGNavigationViewController *controller = [self.branches objectAtIndex:i];
        if(controller != self.handle) {
            [self.branches setObject:[NSNull null] atIndexedSubscript:i];
        }
    }
}


@end
