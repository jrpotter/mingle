//
//  MGProfilePictureEditViewController.h
//
//  The following contains tools to edit the current profile image.
//  It also has an indicator to notify the user what the current
//  state of the image is.
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGProfilePictureEditViewController : UIViewController
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *cropButton;
@end
