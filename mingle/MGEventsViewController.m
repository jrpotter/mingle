//
//  MGEventsViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGEventsViewController.h"

@interface MGEventsViewController ()

// The location manager is stopped after the first call for coordinates
// since its possible a user moves far enough away that the same event
// is shown again, which could be potentially confusing.
@property (nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) CLLocationManager *location_manager;

// Just visual indicators on whether a user can move to the left or right
@property (strong, nonatomic) UILabel *leftIndicator;
@property (strong, nonatomic) UILabel *rightIndicator;

// View events
@property (strong, nonatomic) MGPageViewController *eventSlides;

@end

@implementation MGEventsViewController

#pragma mark - Initialization

- (id)init
{
    self = [super initWithLabel:@"Events"];
    if (self) {
        
        _location = CLLocationCoordinate2DMake(0, 0);
        _location_manager = [[CLLocationManager alloc] init];
        [_location_manager setDistanceFilter:kCLDistanceFilterNone];
        [_location_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        _leftIndicator = [[UILabel alloc] init];
        //[_leftIndicator setText:LEFT_CHEVRON_ICON];
        
        _rightIndicator = [[UILabel alloc] init];
        //[_rightIndicator setText:RIGHT_CHEVRON_ICON];
        
        for(UILabel *label in @[_leftIndicator, _rightIndicator]) {
            [label setFont:BUTTON_FONT];
            [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        
        _eventSlides = [[MGPageViewController alloc] init];
        [_eventSlides.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.eventSlides];
    [self.viewport addSubview:self.leftIndicator];
    [self.viewport addSubview:self.rightIndicator];
    [self.viewport addSubview:self.eventSlides.view];
    
    // Add Constraints (Slides)
}


#pragma mark - Loading

- (void)backlog
{
    
}


#pragma mark - Location Delegation

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // The first time this is called we are able to make requests for nearby events
    [manager stopUpdatingLocation];
    self.location = manager.location.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@", error);
    if ([error code] == kCLErrorDenied) {
        NSLog(@"Denied");
    }
    
    [manager stopUpdatingLocation];
}


#pragma mark - Page View Delegation

- (void)didSlideLeft:(MGPageViewController *)pageViewController
{

}

- (void)didSlideRight:(MGPageViewController *)pageViewController
{

}


#pragma mark - Page View Delegation/Data Source

- (UIViewController *)beforePageViewController:(UIViewController *)viewController
{
    
    return nil;
}

- (UIViewController *)afterPageViewController:(UIViewController *)viewController
{
    
    return nil;
}


@end
