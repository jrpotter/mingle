//
//  UIView+UIView_ImageEffects.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "UIView+ViewEffects.h"

@implementation UIView (ViewEffects)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// Adds an overlay with a spinner on the window
+ (UIView *)addLoadingOverlay
{
    return [self addLoadingOverlay:[[UIApplication sharedApplication] delegate].window];
}

// Adds an overlay with a spinner on the specified view
+ (UIView *)addLoadingOverlay:(UIView *)targetView
{
    UIView *overlay = [[UIView alloc] init];
    [overlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    [overlay setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [spinner startAnimating];
    
    [targetView addSubview:overlay];
    [overlay addSubview:spinner];
    
    // Add Constraints (Spinner)
    [overlay addConstraint:[NSLayoutConstraint
                            constraintWithItem:spinner
                            attribute:NSLayoutAttributeCenterX
                            relatedBy:NSLayoutRelationEqual
                            toItem:overlay
                            attribute:NSLayoutAttributeCenterX
                            multiplier:1.0
                            constant:0]];
    
    [overlay addConstraint:[NSLayoutConstraint
                            constraintWithItem:spinner
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                            toItem:overlay
                            attribute:NSLayoutAttributeCenterY
                            multiplier:1.0
                            constant:0]];
    
    // Add Constraints (Overlay)
    [targetView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-0-[overlay(==view)]-0-|"
                                options:NSLayoutFormatAlignAllCenterY
                                metrics:nil
                                views:@{@"overlay": overlay, @"view": targetView}]];
    
    [targetView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|-0-[overlay(==view)]-0-|"
                                options:NSLayoutFormatAlignAllCenterX
                                metrics:nil
                                views:@{@"overlay": overlay, @"view": targetView}]];
    
    // Ensure the overlay is always on top
    [overlay.layer setZPosition:MAXFLOAT];
    
    return overlay;
}

@end
