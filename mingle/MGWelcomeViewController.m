//
//  MGWelcomeViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGWelcomeViewController.h"
#import "MGAppDelegate.h"

// Maintain the total number of slides present
static NSInteger slideCount = 3;

@interface MGWelcomeViewController ()

// Here we maintain the slides (which may or may not be filled)
// for when the user is swiping. If a view controller exists in
// the desired index, we just return it. Otherwise we instantiate
// one and cache for later
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *slides;

// Depending on the image, it may be a bit difficult to see
// the page control and button, so we place them on a panel
// the is mostly opaque
@property (strong, nonatomic) UIView *panel;

// Other Properties
@property (strong, nonatomic) UIButton *finished;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) MGPageViewController *welcomeSlides;
@end

@implementation MGWelcomeViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _index = 0;
        _slides = [[NSMutableArray alloc] initWithCapacity:slideCount];
        
        _panel = [[UIView alloc] init];
        [_panel.layer setCornerRadius:5];
        [_panel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_panel setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
        
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setNumberOfPages:slideCount];
        [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setCurrentPageIndicatorTintColor:MINGLE_DARK_COLOR];
        
        _welcomeSlides = [[MGPageViewController alloc] init];
        [_welcomeSlides setDelegate:self];
        [_welcomeSlides setDataSource:self];
        [_welcomeSlides.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _finished = [[UIButton alloc] init];
        [_finished.layer setCornerRadius:5];
        [_finished.titleLabel setFont:MINGLE_FONT];
        [_finished setBackgroundColor:MINGLE_DARK_COLOR];
        [_finished setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_finished setTitle:@"Continue" forState:UIControlStateNormal];
        [_finished addTarget:self action:@selector(postLogin) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_welcomeSlides setDelegate:nil];
    [_welcomeSlides setDataSource:nil];
}

- (void)postLogin
{
    MGAppDelegate *appDelegate = (MGAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentPostLoginViewController];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.welcomeSlides];
    [self.view addSubview:self.welcomeSlides.view];
    [self.view addSubview:self.panel];
    [self.panel addSubview:self.pageControl];
    [self.panel addSubview:self.finished];
    
    // Add Constraints (Welcome Slides)
    // We allow this to take up the entirety of the page
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[welcome(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"welcome": self.welcomeSlides.view, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[welcome(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"welcome": self.welcomeSlides.view, @"view": self.view}]];
    
    // Add Constraints (Panel)
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.panel
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.75
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
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:-30]];
    
    // Add Constraints (Page Control)
    [self.panel addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[page_control(==panel)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                                views:@{@"page_control": self.pageControl, @"panel": self.panel}]];
    
    // Add Constraints (Finished)
    [self.panel addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.finished
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.panel
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.9
                              constant:0]];
    
    // Layout Vertically
    [self.panel addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-[page_control(==20)]-[finished(==60)]-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"page_control": self.pageControl, @"finished": self.finished}]];
    
    // Add first item to page display
    [self.welcomeSlides setActiveViewController:[self imageControllerWithIndex:self.index]];
}


#pragma mark - Page View Delegation

- (void)didSlideLeft:(MGPageViewController *)pageViewController
{
    self.index = MAX(0, self.index - 1);
    [self.pageControl setCurrentPage:self.index];
}

- (void)didSlideRight:(MGPageViewController *)pageViewController
{
    self.index = MIN(slideCount - 1, self.index + 1);
    [self.pageControl setCurrentPage:self.index];
}


#pragma mark - Page View Data Source

- (UIViewController *)imageControllerWithIndex:(NSInteger)index
{
    // Note the indices will always be called incrementally
    if(index < [self.slides count]) {
        return [self.slides objectAtIndex:index];
    }
    
    // Create Image
    NSString *name = [NSString stringWithFormat:@"welcome_slide_%d", (int)index];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    // Create controller
    UIViewController *controller = [[UIViewController alloc] init];
    [controller.view addSubview:imageView];
    
    // Add Constraints
    [controller.view addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|-0-[image(==view)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterY
                                     metrics:nil
                                     views:@{@"image": imageView, @"view": controller.view}]];
    
    [controller.view addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-0-[image(==view)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterX
                                     metrics:nil
                                     views:@{@"image": imageView, @"view": controller.view}]];
    
    // Cache for later
    [self.slides addObject:controller];
    
    return controller;
}

- (UIViewController *)beforePageViewController:(UIViewController *)viewController
{
    if(self.index == 0) {
        return nil;
    }
    
    return [self imageControllerWithIndex:self.index-1];
}

- (UIViewController *)afterPageViewController:(UIViewController *)viewController
{
    if(self.index == slideCount - 1) {
        return nil;
    }
    
    return [self imageControllerWithIndex:self.index+1];
}


@end
