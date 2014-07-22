//
//  MGNavigationViewController.h
//
//  The following is the main viewport of the application. Most pages
//  are subclassed from this, as it housed the means of navigation and
//  viewing messages.
//
//  The following also allows arbitray "pushes" of more navigation view
//  controllers. Any pushed controllers will move the current one to the
//  left. At any one moment, there should always be one navigation controller
//  on the stack.
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNavigationViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *bar;
@property (strong, nonatomic) UIButton *left;
@property (strong, nonatomic) UIButton *right;
@property (strong, nonatomic) UIScrollView *viewport;

// Initialization
- (id)initWithLabel:(NSString *)label;
- (void)initializeLeftButton;
- (void)initializeRightButton;

// Maintains navigation stack
- (void)popController;
- (void)pushController:(MGNavigationViewController *)controller;

@end
