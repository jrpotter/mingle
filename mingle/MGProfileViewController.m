//
//  MGProfileViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileViewController.h"
#import "MGProfileButtonsViewController.h"
#import "MGFriendsListViewController.h"
#import "MGConnection.h"
#import "UIView+ViewEffects.h"

@interface MGProfileViewController ()
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) MGProfileButtonsViewController *buttonController;
@end

@implementation MGProfileViewController

#pragma mark - Initialization

- (id)initWithUserData:(NSDictionary *)userData personal:(BOOL)personal;
{
    self = [super init];
    if (self) {
        
        // Should only ever be able to edit the user's own profile image
        if(personal) {
            _cameraButton = [[UIButton alloc] init];
            [_cameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        } else {
            _cameraButton = nil;
        }
        
        // These control external links for the user
        _buttonController = [[MGProfileButtonsViewController alloc] initWithMessages:(personal)];
        [_buttonController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Image Setup
        _imageURL = userData[@"profile_picture"];
        _image = [[UIImageView alloc] init];
        [_image setTranslatesAutoresizingMaskIntoConstraints:NO];
        if([_imageURL length] > 0) {
            UIView *overlay = [UIView addLoadingOverlay:_image];
            [MGConnection getOpenImage:[MINGLE_ROOT_URL stringByAppendingString:_imageURL] complete:^(UIImage *image) {
                [overlay removeFromSuperview];
                [_image setImage:((image == nil) ? EMPTY_PROFILE_IMAGE : image)];
            }];
        } else {
            [_image setImage:EMPTY_PROFILE_IMAGE];
        }
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.buttonController];
    [self.view addSubview:self.image];
    [self.view addSubview:self.buttonController.view];
    
    // Add Constraints (Image Controller)
    [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[image(==viewport)]-0-|"
                                   options:NSLayoutFormatAlignAllCenterY
                                   metrics:nil
                                   views:@{@"image": self.image, @"viewport": self.view}]];
    
    // Add Constraints (Buttons)
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.buttonController.view
                               attribute:NSLayoutAttributeLeft
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.image
                               attribute:NSLayoutAttributeLeft
                               multiplier:1.0
                               constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.buttonController.view
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.image
                               attribute:NSLayoutAttributeBottom
                               multiplier:1.0
                               constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.buttonController.view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                  constant:60]];
    
    // Layout Vertically
    [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0-[image(==250)]"
                                   options:NSLayoutFormatAlignAllCenterX
                                   metrics:nil
                                   views:@{@"image": self.image}]];
}


#pragma mark - Slide Display

- (void)showFriendsController
{

}

- (void)showEventsController
{
    
}

- (void)showImagesController
{

}


@end
