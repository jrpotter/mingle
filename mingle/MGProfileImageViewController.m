//
//  MGProfileImageViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileImageViewController.h"
#import "MGProfilePictureEditViewController.h"
#import "MGConnection.h"

@interface MGProfileImageViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MGProfilePictureEditViewController *editController;
@end

@implementation MGProfileImageViewController

#pragma mark - Initialization

- (id)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _editController = [[MGProfilePictureEditViewController alloc] init];
        [_editController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        if([url length] > 0) {
            [MGConnection getOpenImage:[MINGLE_ROOT_URL stringByAppendingString:url] complete:^(UIImage *image) {
                [_imageView setImage:((image == nil) ? EMPTY_PROFILE_IMAGE : image)];
            }];
        }
        
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self addChildViewController:self.editController];
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.editController.view];
    
    // Add Constraints (Image View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[image(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"image": self.imageView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[image(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"image": self.imageView, @"view": self.view}]];
    
    // Add Constraints (Edit Controller)
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:[editor(==75)]-0-|"
                                    options:NSLayoutFormatAlignAllCenterY
                                    metrics:nil
                                    views:@{@"editor": self.editController.view}]];
    
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-0-[editor(==view)]-0-|"
                                    options:NSLayoutFormatAlignAllCenterX
                                    metrics:nil
                                    views:@{@"editor": self.editController.view, @"view": self.imageView}]];
}


@end
