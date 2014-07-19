//
//  MGPageViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGPageViewController.h"

@interface MGPageViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
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
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
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


#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Scroll View Methods

// When the animation ends, we determine our position of the scroll to
// find out the direction we went. We then realign the controllers accordingly
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = [scrollView contentOffset].x;
    CGFloat width = scrollView.contentSize.width;
    
    // Need to request another view controller if possible
    if([self count] >= 2) {
        
        // Slid to the left
        if(x <= 0.1) {
            
            if(self.delegate) {
                [self.delegate willSlideLeft];
            }
            
            if(self.right) {
                [self.right.view removeFromSuperview];
                [self.right removeFromParentViewController];
            }
            
            // Slide over controllers
            self.right = self.active;
            self.active = self.left;
            self.left = (self.dataSource) ? [self.dataSource beforePageViewController:self.active] : nil;
            
        // Slid to the right
        // If there are two child controllers, the right is offset in the middle
        // If there are three, the right is 2/3 of the way over. Therefore, in both
        // cases, if the offset is greater than or equal to half the width, we must
        // be in the right controller.
        } else if(fabsf(x - width / 2) <= 0.1 || x > width / 2) {
            
            if(self.delegate) {
                [self.delegate willSlideRight];
            }
            
            if(self.left) {
                [self.left.view removeFromSuperview];
                [self.left removeFromParentViewController];
            }
            
            // Slide over controllers
            self.left = self.active;
            self.active = self.right;
            self.right = (self.dataSource) ? [self.dataSource afterPageViewController:self.active] : nil;
            
        }
        
        [self layout];
    }
}


#pragma mark - View Controller Methods

// Returns the number of currently active view controllers
- (NSInteger)count
{
    NSInteger total = 0;
    for(UIViewController *controller in @[self.left, self.active, self.right]) {
        if(controller) {
            total += 1;
        }
    }
    
    return total;
}

// Laying out reorganizes all the constraints, and should be called whenever
// a change in the active controller is made. This function expects the left,
// active, and right controllers to be subviews, so other functions must
// componesate for this.
- (void)layout
{
    // Clear current constraints
    for(NSLayoutConstraint *constraint in self.scrollView.constraints) {
        [self.scrollView removeConstraint:constraint];
    }
    
    // Build Horizontal Layout
    NSString *visual_layout = @"H:|";
    NSMutableDictionary *views = [[NSMutableDictionary alloc] initWithCapacity:3];
    [views setObject:self.scrollView forKey:@"scroll"];
    
    NSInteger index = 0;
    for(UIViewController *controller in @[self.left, self.active, self.right]) {
        if(controller) {
            NSString *next = [NSString stringWithFormat:@"button_%d", index++];
            NSString *visual_next = [NSString stringWithFormat:@"-0-[%@(==scroll)]", next];
            [views setObject:controller.view forKey:next];
            visual_layout = [visual_layout stringByAppendingString:visual_next];
            [self.scrollView addConstraints:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V|-0-[view(==scroll)]-0-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                             views:@{@"view": controller.view, @"scroll": self.scrollView}]];
        }
    }
    
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
- (void)setViewController:(UIViewController *)controller
{
    // We first clear out cached controllers
    for(UIViewController *controller in @[self.left, self.active, self.right]) {
        if(controller) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
    }
    
    // Attempt to set the controllers
    self.active = controller;
    if(self.dataSource) {
        self.left = [self.dataSource beforePageViewController:self.active];
        self.right = [self.dataSource afterPageViewController:self.active];
    }
    
    // Finish
    for(UIViewController *controller in @[self.left, self.active, self.right]) {
        if(controller) {
            [self addChildViewController:controller];
            [self.view addSubview:controller.view];
        }
    }
    
    [self layout];
}


@end
