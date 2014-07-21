//
//  MGNavigationViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGNavigationViewController.h"

@interface MGNavigationViewController ()

// Note the contentView holds the bar and viewport of the current view
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *contentView;

// The push view contains the current contentView and the "pushed" view
@property (nonatomic) BOOL popping;
@property (strong, nonatomic) UIScrollView *pushView;
@property (strong, nonatomic) MGNavigationViewController *pushed;

@end

@implementation MGNavigationViewController

#pragma mark - Initialization

- (id)initWithLabel:(NSString *)label
{
    self = [super init];
    if (self) {
        
        _pushed = nil;
        _popping = NO;
        
        _contentView = [[UIView alloc] init];
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
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
        
        _pushView = [[UIScrollView alloc] init];
        [_pushView setDelegate:self];
        [_pushView setBounces:NO];
        [_pushView setScrollEnabled:NO];
        [_pushView setMaximumZoomScale:1.0];
        [_pushView setMinimumZoomScale:1.0];
        [_pushView setShowsVerticalScrollIndicator:NO];
        [_pushView setShowsHorizontalScrollIndicator:NO];
        [_pushView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _viewport = [[UIScrollView alloc] init];
        [_viewport setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}

- (void)dealloc
{
    [_pushView setDelegate:nil];
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
    [self.contentView addSubview:self.bar];
    [self.contentView addSubview:self.viewport];
    [self.pushView addSubview:self.contentView];
    [self.view addSubview:self.pushView];
    
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
        [self.contentView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[subview(==view)]-0-|"
                                   options:NSLayoutFormatAlignAllCenterY
                                   metrics:nil
                                   views:@{@"subview": subview, @"view": self.contentView}]];
    }
    
    // Layout Vertically
    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[bar(==40)]-0-[viewport]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"bar": self.bar, @"viewport": self.viewport}]];
    
    // Add Constraints (Push View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[push(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"push": self.pushView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[push]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"push": self.pushView}]];
    
    // Lastly, layout the push view
    [self layoutStack];
}


#pragma mark - Navigation

// A navigation view controller can handle at most one other navigation view controller
// (though this one can handle one more, and so on). If one does exist, we make sure
// to add both to the display
- (void)layoutStack
{
    for(NSLayoutConstraint *constraint in self.pushView.constraints) {
        [self.pushView removeConstraint:constraint];
    }
    
    // In the case of just one view, the contentView will take up the entire space
    if(self.pushed == nil) {
        [self.pushView addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"H:|-0-[content(==push)]-0-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:nil
                                       views:@{@"push": self.pushView, @"content": self.contentView}]];
        
        [self.pushView addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|-0-[content(==push)]-0-|"
                                       options:NSLayoutFormatAlignAllCenterX
                                       metrics:nil
                                       views:@{@"push": self.pushView, @"content": self.contentView}]];
        
    // In the case of two, the pushed view will take up the entire space to the
    // right of the contentView
    } else {
        [self.pushView addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|-0-[content(==push)]-0-|"
                                       options:NSLayoutFormatAlignAllCenterX
                                       metrics:nil
                                       views:@{@"push": self.pushView, @"content": self.contentView}]];
        
        [self.pushView addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|-0-[pushed(==push)]-0-|"
                                       options:NSLayoutFormatAlignAllCenterX
                                       metrics:nil
                                       views:@{@"push": self.pushView, @"pushed": self.pushed.view}]];
        
        [self.pushView addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"H:|-0-[content(==push)]-0-[pushed(==push)]-0-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:nil
                                       views:@{@"push": self.pushView, @"pushed": self.pushed.view, @"content": self.contentView}]];
    }
}

- (void)pushController:(MGNavigationViewController *)controller
{
    self.popping = NO;
    
    // Add to current hierarchy
    self.pushed = controller;
    [self addChildViewController:self.pushed];
    [self.pushView addSubview:self.pushed.view];
    [self.pushed.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Setup so one can return back
    [self.pushed.left addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    
    // Animate once added
    [self layoutStack];
    [self.pushView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

- (void)popController
{
    self.popping = YES;
    [self.pushView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// We make sure to call this after the scrolling is complete so as not to jar the
// user's view of the quickly removed "pushed" controller
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.popping) {
        [self.pushed.view removeFromSuperview];
        [self.pushed removeFromParentViewController];
        self.pushed = nil;
        [self layoutStack];
    }
}


@end
