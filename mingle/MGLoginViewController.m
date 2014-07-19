//
//  MGLoginViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGLoginViewController.h"
#import "MGLoginFormViewController.h"
#import "MGLoginLinksViewController.h"
#import "MGLoginAlternativeViewController.h"

@interface MGLoginViewController ()

// The scroll view serves as the main view in order to prevent the keyboard
// (when clicking on a textfield) from covering the textfield in question.
// This shouldn't occur in portrait mode, but, if we ever decide to switch
// to a landscape version, this will need to be implemented.
@property (strong, nonatomic) UIScrollView *scrollView;

// Other Properties
@property (strong, nonatomic) UILabel *applicationTitle;
@property (strong, nonatomic) MGLoginFormViewController *form;
@property (strong, nonatomic) MGLoginLinksViewController *links;

// Allow the user to login with an account other than Mingle.
@property (strong, nonatomic) MGLoginAlternativeViewController *alternatives;

@end

@implementation MGLoginViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _applicationTitle = [[UILabel alloc] init];
        [_applicationTitle setText:@"mingle"];
        [_applicationTitle setTextColor:[UIColor whiteColor]];
        [_applicationTitle setFont:[MINGLE_FONT fontWithSize:60]];
        [_applicationTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _form = [[MGLoginFormViewController alloc] init];
        [_form.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _links = [[MGLoginLinksViewController alloc] init];
        [_links.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _alternatives = [[MGLoginAlternativeViewController alloc] init];
        [_alternatives.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // We ensure that anytime the user clicks outside of the textfields,
        // the keyboards are hidden away.
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(dismissKeyboard)]];
        
        // Background image from http://subtlepatterns.com/
        // We create a transparent overlay to maintain the desired color
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]]];
        [self.scrollView setBackgroundColor:[MINGLE_COLOR colorWithAlphaComponent:0.65]];
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Build Hiearchy
    [self addChildViewController:self.form];
    [self addChildViewController:self.links];
    [self addChildViewController:self.alternatives];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.applicationTitle];
    [self.scrollView addSubview:self.form.view];
    [self.scrollView addSubview:self.links.view];
    [self.scrollView addSubview:self.alternatives.view];
    
    // Add Constraints (Scroll View)
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[scroll(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"scroll": self.scrollView, @"view": self.view}]];
    
    // Add Constraints (Application Title)
    [self.scrollView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.applicationTitle
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.scrollView
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0]];
    
    // Add Constraints (Form)
    [self.scrollView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.form.view
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.scrollView
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:0.7
                                     constant:0]];
    
    // Add Constraints (Links)
    [self.scrollView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.links.view
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.form.view
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1.0
                                     constant:0]];
    
    // Add Constraints (Alternative)
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|-0-[alt(==scroll)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterY
                                     metrics:nil
                                     views:@{@"scroll": self.scrollView, @"alt": self.alternatives.view}]];
    
    // Layout Vertically
    [self.scrollView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-30-[title]-10-[form]-2-[links]-2-[alt(==60)]-0-|"
                                     options:NSLayoutFormatAlignAllCenterX
                                     metrics:nil
                                     views:@{
                                         @"title": self.applicationTitle,
                                         @"form": self.form.view,
                                         @"links": self.links.view,
                                         @"alt": self.alternatives.view,
                                     }]];
    
}


#pragma mark - Keyboard

- (void)dismissKeyboard
{
    [self.form.view endEditing:YES];
}


@end
