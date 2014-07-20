//
//  MGNavigationViewController.h
//
//  The following is the main viewport of the application. Most pages
//  are subclassed from this, as it housed the means of navigation and
//  viewing messages.
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNavigationViewController : UIViewController
@property (strong, nonatomic) UIView *bar;
@property (strong, nonatomic) UIButton *left;
@property (strong, nonatomic) UIButton *right;
@property (strong, nonatomic) UIView *viewport;
- (id)initWithLabel:(NSString *)label;
@end
