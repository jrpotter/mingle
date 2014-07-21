//
//  MGEventBrowseViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGEventBrowseViewController.h"
#import "MGEventViewController.h"
#import "MGConnection.h"

@interface MGEventBrowseViewController ()

// The location manager is stopped after the first call for coordinates
// since its possible a user moves far enough away that the same event
// is shown again, which could be potentially confusing.
@property (nonatomic) BOOL updateLocation;
@property (nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) CLLocationManager *location_manager;

// View events
@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) MGPageViewController *eventSlides;

@end

@implementation MGEventBrowseViewController

#pragma mark - Initialization

- (id)init
{
    self = [super initWithLabel:@"Events"];
    if (self) {
        
        _updateLocation = YES;
        _location = CLLocationCoordinate2DMake(0, 0);
        _location_manager = [[CLLocationManager alloc] init];
        [_location_manager setDistanceFilter:kCLDistanceFilterNone];
        [_location_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        _start = 0; _index = 0; _count = 25;
        _events = [[NSMutableArray alloc] initWithCapacity:_count];
        
        _eventSlides = [[MGPageViewController alloc] init];
        [_eventSlides setDelegate:self];
        [_eventSlides setDataSource:self];
        [_eventSlides.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_eventSlides setDelegate:nil];
    [_eventSlides setDataSource:nil];
}


#pragma mark - View

// We start updating here, so any alert does not show up over a completely black screen
- (void)viewDidAppear:(BOOL)animated
{
    if(self.updateLocation) {
        [self.location_manager setDelegate:self];
        [self.location_manager startUpdatingLocation];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.eventSlides];
    [self.viewport addSubview:self.eventSlides.view];
    
    // Add Constraints (Slides)
    [self.viewport addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.eventSlides.view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.viewport
                                  attribute:NSLayoutAttributeHeight
                                  multiplier:0.95
                                  constant:0]];
    
    [self.viewport addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.eventSlides.view
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.viewport
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:0.95
                                  constant:0]];
    
    [self.viewport addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.eventSlides.view
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.viewport
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                  constant:0]];
    
    [self.viewport addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.eventSlides.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.viewport
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                  constant:0]];
}


#pragma mark - Loading

- (void)backlog
{
    NSString *count = [NSString stringWithFormat:@"%ld", (long)self.count];
    NSString *start = [NSString stringWithFormat:@"%ld", (long)self.start];
    
    NSString *timezone = [[NSTimeZone localTimeZone] name];
    NSString *latitude = [NSString stringWithFormat:@"%f", self.location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.location.longitude];
    
    // Query for events (based on settings)
    NSMutableDictionary *form = [[NSMutableDictionary alloc] init];
    [form setObject:count forKey:@"count"];
    [form setObject:start forKey:@"start"];
    [form setObject:timezone forKey:@"timezone"];
    [form setObject:latitude forKey:@"latitude"];
    [form setObject:longitude forKey:@"longitude"];
    
    [MGConnection sendRequest:MINGLE_EVENT_QUERY_URL data:form complete:^(NSDictionary *response, NSError *error) {
        NSString *message = [MGConnection responseErrorString:response error:error];
        if(message == nil) {
            
            NSInteger total = [response[@"events"] count];
            for(NSDictionary *event in response[@"events"]) {
                [self.events addObject:[[MGEventViewController alloc] initWithData:event]];
            }
            
            // Initialize the page controller
            if(self.start == 0 && total > 0) {
                [self.eventSlides setActiveViewController:[self.events objectAtIndex:0]];
            }
            
            // Used for paging results
            self.start += total;
        }
    }];
}


#pragma mark - Location Delegation

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // The first time this is called we are able to make requests for nearby events
    self.location = manager.location.coordinate;
    [manager stopUpdatingLocation];
    self.updateLocation = NO;
    [self backlog];
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
    self.index = MAX(0, self.index - 1);
}

- (void)didSlideRight:(MGPageViewController *)pageViewController
{
    self.index = MIN([self.events count], self.index + 1);
}


#pragma mark - Page View Delegation/Data Source

- (UIViewController *)beforePageViewController:(UIViewController *)viewController
{
    if(self.index == 0) {
        return nil;
    }
    
    return [self.events objectAtIndex:self.index-1];
}

- (UIViewController *)afterPageViewController:(UIViewController *)viewController
{
    if(self.index == [self.events count] - 1) {
        return nil;
    }
    
    return [self.events objectAtIndex:self.index+1];
}


@end
