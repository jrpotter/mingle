//
//  MGSpringboardHeaderViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGSpringboardHeaderViewController.h"
#import "MGConnection.h"
#import "MGSession.h"
#import "UIColor+Hex.h"

@interface MGSpringboardHeaderViewController ()
@property UILabel *userName;
@property UIImageView *profileImage;
@end

@implementation MGSpringboardHeaderViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        NSDictionary *userData = [[MGSession instance] userData];
        
        _userName = [[UILabel alloc] init];
        [_userName setFont:MINGLE_FONT];
        [_userName setTextColor:[UIColor whiteColor]];
        [_userName setTranslatesAutoresizingMaskIntoConstraints:NO];
        if([userData[@"name"] length] > 0) {
            [_userName setText:userData[@"name"]];
        } else {
            [_userName setText:@"Anonymous"];
        }
        
        _profileImage = [[UIImageView alloc] init];
        [_profileImage setClipsToBounds:YES];
        [_profileImage.layer setCornerRadius:(45/2)];
        [_profileImage setContentMode:UIViewContentModeScaleAspectFill];
        [_profileImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        if([userData[@"profile_picture"] length] > 0) {
            NSString *path = [MINGLE_ROOT_URL stringByAppendingString:userData[@"profile_picture"]];
            [MGConnection getOpenImage:path complete:^(UIImage *image) {
                [_profileImage setImage:((image == nil) ? EMPTY_PROFILE_IMAGE : image)];
            }];
        } else {
            [_profileImage setImage:EMPTY_PROFILE_IMAGE];
        }
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidAppear:(BOOL)animated
{
    // Add a top border to the table with different colors
    int colors[] = {0xdc322f, 0xb58900, 0x859900, 0x2aa198, 0x268bd2};
    int count = sizeof(colors) / sizeof(int);
    
    CGFloat borderHeight = 6;
    CGFloat width = self.view.frame.size.width / count;
    CGFloat height = self.view.frame.size.height;
    for(NSUInteger i = 0; i < count; i++) {
        
        CGFloat x = i * width;
        CALayer *topBorder = [CALayer layer];
        UIColor *current = [UIColor colorWithHex:colors[i]];
        
        [topBorder setFrame:CGRectMake(x, height, width, borderHeight)];
        [topBorder setBackgroundColor:current.CGColor];
        [self.view.layer addSublayer:topBorder];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.profileImage];
    [self.view addSubview:self.userName];
    
    // Add Constraints (Profile)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-15-[profile(==45)]-15-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"profile": self.profileImage}]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.profileImage
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.profileImage
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:0]];
    
    // Add Constraints (Name)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-15-[name]-15-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"name": self.userName}]];
    
    // Layout Horizontally
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-15-[profile]-25-[name]"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"profile": self.profileImage, @"name": self.userName}]];
}


@end
