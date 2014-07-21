//
//  MGProfileActivityViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileActivityViewController.h"


@interface MGProfileActivityViewController ()
@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSMutableArray *counts;
@end

@implementation MGProfileActivityViewController

#pragma mark - Initialization

- (id)initWithUserData:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        
        // Buttons
        _friendsButton = [[UIButton alloc] init];
        _eventsButton = [[UIButton alloc] init];
        _imagesButton = [[UIButton alloc] init];
        
        for(UIButton *button in @[_friendsButton, _eventsButton, _imagesButton]) {
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        
        // Labeling
        _names = @[@"Friends", @"Events", @"Images"];
        _counts = [[NSMutableArray alloc] init];
        for(NSString *key in @[@"friend_count", @"event_count", @"image_count"]) {
            if(userData[key] == nil) {
                [_counts addObject:@"32"];
            } else {
                NSString *total = [NSString stringWithFormat:@"%@", userData[key]];
                [_counts addObject:total];
            }
        }
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidAppear:(BOOL)animated
{
    for(UIButton *button in @[self.friendsButton, self.eventsButton, self.imagesButton]) {
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Display
    NSArray *buttons = @[self.friendsButton, self.eventsButton, self.imagesButton];
    for(NSUInteger i = 0; i < [buttons count]; i++) {
        
        // Setup
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setText:self.names[i]];
        [nameLabel setFont:[UIFont fontWithName:@"Noteworthy" size:18]];
        
        UILabel *countLabel = [[UILabel alloc] init];
        [countLabel setTextColor:MINGLE_DARK_COLOR];
        [countLabel setFont:[NUMBER_FONT fontWithSize:25]];
        [countLabel setText:[self.counts objectAtIndex:i]];
        
        // Build Hierarchy
        [buttons[i] addSubview:nameLabel];
        [buttons[i] addSubview:countLabel];
        
        // Add Constraints (Labels)
        for(UILabel *label in [buttons[i] subviews]) {
            [label setTranslatesAutoresizingMaskIntoConstraints:NO];
            [buttons[i] addConstraint:[NSLayoutConstraint
                                       constraintWithItem:label
                                       attribute:NSLayoutAttributeCenterX
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:buttons[i]
                                       attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0
                                       constant:0]];
        }
        
        // Layout Vertically
        [buttons[i] addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-10-[count]-(>=6)-[name]-10-|"
                                    options:NSLayoutFormatAlignAllCenterX
                                    metrics:nil
                                    views:@{@"count": countLabel, @"name": nameLabel}]];
    }
    
    // Build Hierarchy
    [self.view addSubview:self.friendsButton];
    [self.view addSubview:self.eventsButton];
    [self.view addSubview:self.imagesButton];
    
    // Add Constraints (Buttons)
    for(UIButton *button in self.view.subviews) {
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0-[button]-0-|"
                                   options:NSLayoutFormatAlignAllCenterX
                                   metrics:nil
                                   views:@{@"button": button}]];
    }
    
    // Layout Horizontally
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[friends(==events)]-0-[events(==images)]-0-[images]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"friends": self.friendsButton, @"events": self.eventsButton, @"images": self.imagesButton}]];
}


@end
