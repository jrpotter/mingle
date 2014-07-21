//
//  MGProfileViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileViewController.h"
#import "MGProfileImageViewController.h"
#import "MGProfileActivityViewController.h"
#import "MGFriendsListViewController.h"
#import "MGImagesListViewController.h"
#import "UIView+ViewEffects.h"

@interface MGProfileViewController ()
@property (strong, nonatomic) UIView *userInfoPanel;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *userSignUpDate;
@property (strong, nonatomic) MGProfileImageViewController *imageController;
@property (strong, nonatomic) MGProfileActivityViewController *activityController;
@end

@implementation MGProfileViewController

#pragma mark - Initialization

- (id)initWithUserData:(NSDictionary *)userData;
{
    self = [super initWithLabel:@"Profile"];
    if (self) {
        _imageController = [[MGProfileImageViewController alloc] initWithURL:userData[@"profile_picture"]];
        [_imageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _activityController = [[MGProfileActivityViewController alloc] initWithUserData:userData];
        [_activityController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Events
        [_activityController.friendsButton addTarget:self action:@selector(showFriendsController) forControlEvents:UIControlEventTouchUpInside];
        [_activityController.eventsButton addTarget:self action:@selector(showEventsController) forControlEvents:UIControlEventTouchUpInside];
        [_activityController.imagesButton addTarget:self action:@selector(showImagesController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.imageController];
    [self.viewport addSubview:self.imageController.view];
    [self.viewport addSubview:self.activityController.view];
    
    // Add Constraints (Image Controller)
    [self.viewport addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[image(==viewport)]-0-|"
                                   options:NSLayoutFormatAlignAllCenterY
                                   metrics:nil
                                   views:@{@"image": self.imageController.view, @"viewport": self.viewport}]];
    
    // Add Constraints (Activity Controller)
    [self.viewport addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[activity(==viewport)]-0-|"
                                   options:NSLayoutFormatAlignAllCenterY
                                   metrics:nil
                                   views:@{@"activity": self.activityController.view, @"viewport": self.viewport}]];
    
    // Layout Vertically
    [self.viewport addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0-[image(==250)]-0-[activity]"
                                   options:NSLayoutFormatAlignAllCenterX
                                   metrics:nil
                                   views:@{@"image": self.imageController.view, @"activity": self.activityController.view}]];
}


#pragma mark - Slide Display

- (void)showFriendsController
{
    MGNavigationViewController *friends = [[MGFriendsListViewController alloc] init];
    [self pushController:friends];
}

- (void)showEventsController
{
    
}

- (void)showImagesController
{
    MGNavigationViewController *images = [[MGImagesListViewController alloc] init];
    [self pushController:images];
}


@end
