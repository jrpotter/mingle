//
//  MGLoginLinksViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/5/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGLoginLinksViewController.h"

static NSString *forgot_title = @"Recover";
static NSString *sign_up_title = @"Sign Up";

@interface MGLoginLinksViewController ()
@property (strong, nonatomic) UIButton *forgotButton;
@property (strong, nonatomic) UIButton *signUpButton;
@end

@implementation MGLoginLinksViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(self) {
        
        _forgotButton = [[UIButton alloc] init];
        [_forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
        [_forgotButton addTarget:self action:@selector(openForgotLink) forControlEvents:UIControlEventTouchUpInside];
        
        _signUpButton = [[UIButton alloc] init];
        [_signUpButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
        [_signUpButton addTarget:self action:@selector(openSignUpLink) forControlEvents:UIControlEventTouchUpInside];
        
        for(UIButton *button in @[_signUpButton, _forgotButton]) {
            [button.titleLabel setFont:[MINGLE_FONT fontWithSize:14]];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            [button sizeToFit];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [_forgotButton removeTarget:self action:@selector(openForgotLink) forControlEvents:UIControlEventTouchUpInside];
    [_signUpButton removeTarget:self action:@selector(openSignUpLink) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.forgotButton];
    [self.view addSubview:self.signUpButton];
    
    // Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[forgot]-(>=0)-[sign_up]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"forgot": self.forgotButton, @"sign_up": self.signUpButton}]];
    
    for(UIButton *button in @[self.forgotButton, self.signUpButton]) {
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0-[button]-0-|"
                                   options:NSLayoutFormatAlignAllCenterX
                                   metrics:nil
                                   views:@{@"button": button}]];
    }
}


#pragma mark - Link Events

- (void)openSignUpLink
{
    [[[UIActionSheet alloc]
      initWithTitle:@"Launch"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:sign_up_title
      otherButtonTitles:nil] showInView:self.view.superview];
}

- (void)openForgotLink
{
    [[[UIActionSheet alloc]
      initWithTitle:@"Launch"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:forgot_title
      otherButtonTitles:nil] showInView:self.view.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:sign_up_title]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MINGLE_ALIAS_CREATE_URL]];
    } else if([title isEqualToString:forgot_title]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MINGLE_ALIAS_FORGOT_PASSWORD]];
    }
    
    [actionSheet setDelegate:nil];
}


@end
