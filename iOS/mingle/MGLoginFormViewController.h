//
//  MGLoginFormViewController.h
//
//  Contains the actual means of logging in with a Mingle account.
//  It requires that the email and password fields are not empty
//  (nor blank) and will then send a request using the session singleton.
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLoginFormViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
- (void)submitForm;
@end
