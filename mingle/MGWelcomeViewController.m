//
//  MGWelcomeViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGWelcomeViewController.h"

@interface MGWelcomeViewController ()

// Here we maintain the slides (which may or may not be filled)
// for when the user is swiping. If a view controller exists in
// the desired index, we just return it. Otherwise we instantiate
// one and cache for later
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *slides;

// Other Properties
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) MGPageViewController *welcomeSlides;
@end

// Maintain the total number of slides present
static NSInteger slideCount = 3;

@implementation MGWelcomeViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _index = 0;
        _slides = [[NSMutableArray alloc] initWithCapacity:slideCount];
        
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _welcomeSlides = [[MGPageViewController alloc] init];
        [_welcomeSlides setDelegate:self];
        [_welcomeSlides setDataSource:self];
        [_welcomeSlides.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_welcomeSlides setDelegate:nil];
    [_welcomeSlides setDataSource:nil];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.welcomeSlides];
    [self.view addSubview:self.welcomeSlides.view];
    
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
    
    // Add first item to page display
    [self.welcomeSlides setActiveViewController:[self imageControllerWithIndex:self.index]];
}


#pragma mark - Page View Delegation

- (void)didSlideLeft:(MGPageViewController *)pageViewController
{
    self.index = MAX(0, self.index - 1);
}

- (void)didSlideRight:(MGPageViewController *)pageViewController
{
    self.index = MIN(slideCount - 1, self.index + 1);
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
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
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
