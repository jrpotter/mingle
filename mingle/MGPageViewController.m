//
//  MGPageViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGPageViewController.h"

@interface MGPageViewController ()
@property (nonatomic) BOOL scrolling;
@property (nonatomic) BOOL changedOffset;
@property (nonatomic) CGPoint offsetPosition;
@property (strong, nonatomic) UIScrollView *scrollView;

// The controllers (or nil if non-existant)
@property (strong, nonatomic) UIViewController *left;
@property (strong, nonatomic) UIViewController *right;
@property (strong, nonatomic) UIViewController *active;
@end

@implementation MGPageViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _left = nil;
        _right = nil;
        _active = nil;
        _delegate = nil;
        _dataSource = nil;
        _scrolling = NO;
        _changedOffset = YES;
        _offsetPosition = CGPointMake(0, 0);
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.scrollView];
    
    // Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
}


#pragma mark - Scroll View Methods

// Here we record the current offset position, so we can then determine
// whether or not we should proceed with a layout. Note that if we happen
// to be on the edge, there may have been another view controller made
// since we reached the said edge. Thus we query up again here.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.offsetPosition = scrollView.contentOffset;
    [self refreshLeft:(self.left == nil) refreshRight:(self.right == nil)];
    
}

// If it appears the scroll view will stay in the same position, then there is no need
// to relayout the pages. Thus this sets a flag that checks exactly that.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(fabsf(self.offsetPosition.x - targetContentOffset->x) <= 0.1) {
        self.changedOffset = NO;
    }
}

// When the animation ends, we determine our position of the scroll to
// find out the direction we went. We then realign the controllers accordingly
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.changedOffset) {
        
        CGFloat x = [scrollView contentOffset].x;
        CGFloat width = scrollView.contentSize.width;
        CGFloat f_width = scrollView.frame.size.width;
        
        // Total number of current view controllers
        NSInteger total = 0;
        for(id page in [self controllersToArray]) {
            if(page != [NSNull null]) {
                total += 1;
            }
        }
        
        // Need to request another view controller if possible
        if(total >= 2) {
            
            // Slid to the left
            if(x <= 0.1) {
                
                if(self.delegate) {
                    [self.delegate didSlideLeft:self];
                }
                
                if(self.right) {
                    [self.right.view removeFromSuperview];
                    [self.right removeFromParentViewController];
                }
                
                // Slide over controllers
                self.right = self.active;
                self.active = self.left;
                [self refreshLeft:YES refreshRight:NO];
                
                
            // Slid to the right
            // If there are two child controllers, the right is offset in the middle
            // If there are three, the right is 2/3 of the way over. Therefore, in both
            // cases, if the offset is greater than or equal to half the width, we must
            // be in the right controller.
            } else if(fabsf(x - width / 2) <= 0.1 || x > width / 2) {
                
                if(self.delegate) {
                    [self.delegate didSlideRight:self];
                }
                
                if(self.left) {
                    [self.left.view removeFromSuperview];
                    [self.left removeFromParentViewController];
                }
                
                // Slide over controllers
                self.left = self.active;
                self.active = self.right;
                [self refreshLeft:NO refreshRight:YES];
            }
        }
        
        // Center the scroll view
        // Returns the first available postion self.active is at
        // Note this should always be either 0 or 1 since active could either
        // be the first controller or the center one (of three controllers)
        NSInteger activePosition = (self.left == nil) ? 0 : 1;
        [self.scrollView setContentOffset:CGPointMake(f_width * activePosition, 0) animated:NO];
    }
    
    // Reset
    self.changedOffset = YES;
}


#pragma mark - Convenience Methods

// Returns the controllers to an array (replacing any nils with NSNulls)
- (NSArray *)controllersToArray
{
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:3];
    [controllers addObject:(self.left ? self.left : [NSNull null])];
    [controllers addObject:(self.active ? self.active : [NSNull null])];
    [controllers addObject:(self.right ? self.right : [NSNull null])];
    
    return controllers;
}

// This is a convenience function to perform a certain action on
// all non-Null pages
- (void)onControllers:(void (^)(UIViewController *))block
{
    for(id page in [self controllersToArray]) {
        if(page != [NSNull null]) {
            UIViewController *controller = (UIViewController *)page;
            block(controller);
        }
    }
}


#pragma mark - View Controller Methods

// Try to load the surrounding controllers
- (void)refreshLeft:(BOOL)refreshLeft refreshRight:(BOOL)refreshRight
{
    // We should only relayout the page if a change has occurred
    // Thus we cache the results and check for differences
    UIViewController *left = self.left;
    UIViewController *right = self.right;
    
    // A refresh should include wiping out the old values
    if(refreshLeft) self.left = nil;
    if(refreshRight) self.right = nil;
    
    if(self.dataSource) {
        
        if(refreshLeft) {
            self.left = [self.dataSource beforePageViewController:self.active];
            if(self.left) {
                [self addChildViewController:self.left];
                [self.scrollView addSubview:self.left.view];
            }
        }
        
        if(refreshRight) {
            self.right = [self.dataSource afterPageViewController:self.active];
            if(self.right) {
                [self addChildViewController:self.right];
                [self.scrollView addSubview:self.right.view];
            }
        }
    }
    
    if((refreshLeft && left != self.left) || (refreshRight && right != self.right)) {
        [self layout];
    }
}

// Laying out reorganizes all the constraints, and should be called whenever
// a change in the active controller is made. This function expects the left,
// active, and right controllers to be subviews, so other functions must
// componesate for this.
- (void)layout
{
    NSInteger __block index = 0;
    NSString __block *visual_layout = @"H:|";
    NSMutableDictionary __block *views = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.scrollView, @"scroll", nil];
    
    // Clear current constraints
    for(NSLayoutConstraint *constraint in self.scrollView.constraints) {
        [self.scrollView removeConstraint:constraint];
    }
    
    // Build Horizontal Layout
    [self onControllers:^(UIViewController *controller) {
        
        // Continue collecting views
        NSString *next = [NSString stringWithFormat:@"view_%d", (int)index++];
        [views setObject:controller.view forKey:next];
        
        // Continue building visual format string
        NSString *visual_next = [NSString stringWithFormat:@"-0-[%@(==scroll)]", next];
        visual_layout = [visual_layout stringByAppendingString:visual_next];
        
        // Layout vertically
        [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addConstraints:[NSLayoutConstraint
                                         constraintsWithVisualFormat:@"V:|-0-[view(==scroll)]-0-|"
                                         options:NSLayoutFormatAlignAllCenterX
                                         metrics:nil
                                         views:@{@"view": controller.view, @"scroll": self.scrollView}]];
    }];
    
    // Finish Laying out
    if(index > 0) {
        [self.scrollView addConstraints:[NSLayoutConstraint
                                         constraintsWithVisualFormat:[visual_layout stringByAppendingString:@"-0-|"]
                                         options:NSLayoutFormatAlignAllCenterY
                                         metrics:nil
                                         views:views]];
    }
}

// This sets the currently active view controller
- (void)setActiveViewController:(UIViewController *)controller
{
    // We first clear out cached controllers
    [self onControllers:^(UIViewController *controller) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }];
    
    // Attempt to set the controllers
    self.active = controller;
    if(self.dataSource) {
        self.left = [self.dataSource beforePageViewController:self.active];
        self.right = [self.dataSource afterPageViewController:self.active];
    }
    
    // Finish
    [self onControllers:^(UIViewController *controller) {
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
    }];
    
    [self layout];
}


@end
