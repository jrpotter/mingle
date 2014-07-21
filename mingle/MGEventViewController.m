//
//  MGEventViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGEventViewController.h"
#import "MGConnection.h"
#import "UIView+ViewEffects.h"

@interface MGEventViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation MGEventViewController

#pragma mark - Initialization

- (id)initWithData:(NSDictionary *)event
{
    self = [super init];
    if (self) {
        
        _name = event[@"title"];
        _datetime = event[@"datetime"];
        _identifier = event[@"id"];
        _latitude = event[@"latitude"];
        _longitude = event[@"longitude"];
        _max_size = event[@"max_size"];
        _imageURL = [self imageViewURL:event];
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.imageView];
    
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
    
    // Load Image
    UIView *overlay = [UIView addLoadingOverlay:self.imageView];
    [MGConnection getImage:self.imageURL complete:^(UIImage *image) {
        [overlay removeFromSuperview];
        if(image) {
            [self.imageView setImage:image];
            [self.imageView setContentMode:UIViewContentModeScaleToFill];
        }
    }];
}


#pragma mark - Event Detail

- (NSString *)imageViewURL:(NSDictionary *)event
{
    if([event objectForKey:@"zoom"] != nil) {
        int zoom = [[event objectForKey:@"zoom"] intValue];
        if(zoom > 0) {
            NSString *fov = [NSString stringWithFormat:@"%f", (float)45 / zoom];
            NSString *pitch = [NSString stringWithFormat:@"%@", [event objectForKey:@"pitch"]];
            NSString *heading = [NSString stringWithFormat:@"%@", [event objectForKey:@"heading"]];
            NSString *latitude = [NSString stringWithFormat:@"%@", [event objectForKey:@"latitude"]];
            NSString *longitude = [NSString stringWithFormat:@"%@", [event objectForKey:@"longitude"]];
            
            NSString *pov = [NSString stringWithFormat:@"fov=%@&pitch=%@&heading=%@", fov, pitch, heading];
            NSString *get_query = [NSString stringWithFormat:@"?size=640x640&location=%@,%@&%@", latitude, longitude, pov];
            return [MINGLE_STATIC_STREET_VIEW_URL stringByAppendingString:get_query];
        }
    }
    
    NSString *picture_url = [event objectForKey:@"picture"];
    return ([picture_url length] > 0) ? [MINGLE_STATIC_URL stringByAppendingString:picture_url] : @"";
}


@end
