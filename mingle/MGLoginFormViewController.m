//
//  MGLoginFormViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGLoginFormViewController.h"
#import "MGSession.h"

@interface MGLoginFormViewController ()

// The table view is used to group in the inputs together
// and created a rounded appearence
@property (strong, nonatomic) UITableView *tableView;

// Submission will ensure the required fields (email/password)
// are not empty before sending a request to the server
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation MGLoginFormViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor grayColor]};
        
        _emailField = [[UITextField alloc] init];
        [_emailField setPlaceholder:@"Email"];
        [_emailField setReturnKeyType:UIReturnKeyNext];
        [_emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_emailField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Email" attributes:attributes]];
        
        _passwordField = [[UITextField alloc] init];
        [_passwordField setSecureTextEntry:YES];
        [_passwordField setReturnKeyType:UIReturnKeyDone];
        [_passwordField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Password" attributes:attributes]];
        
        for(UITextField *field in @[_emailField, _passwordField]) {
            [field setDelegate:self];
            [field setAdjustsFontSizeToFitWidth:YES];
            [field setTextAlignment:NSTextAlignmentLeft];
            [field setLeftViewMode:UITextFieldViewModeAlways];
            [field setClearButtonMode:UITextFieldViewModeNever];
            [field setTranslatesAutoresizingMaskIntoConstraints:NO];
            [field setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field.layer setBackgroundColor:[UIColor whiteColor].CGColor];
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [field setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
            [field setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setScrollEnabled:NO];
        [_tableView setAlwaysBounceVertical:NO];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setSeparatorColor:[UIColor grayColor]];
        [_tableView setContentInset:UIEdgeInsetsMake(-35, 0, 0, 0)];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView.layer setBorderWidth:1];
        [_tableView.layer setCornerRadius:10];
        
        _submitButton = [[UIButton alloc] init];
        [_submitButton.layer setCornerRadius:5];
        [_submitButton.titleLabel setFont:MINGLE_FONT];
        [_submitButton setBackgroundColor:MINGLE_DARK_COLOR];
        [_submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_submitButton setTitle:@"Log in" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)dealloc
{
    [_tableView setDataSource:nil];
    [_emailField setDelegate:nil];
    [_passwordField setDelegate:nil];
    [_submitButton removeTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build Hierarchy
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    
    // Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[table(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"table": self.tableView, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[button(==view)]-0-|"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"button": self.submitButton, @"view": self.view}]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[table(==88)]-5-[button]-0-|"
                               options:NSLayoutFormatAlignAllCenterX
                               metrics:nil
                               views:@{@"table": self.tableView, @"button": self.submitButton}]];
}


#pragma mark - Table Setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell_id"];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    
    // Setup
    UITextField *field = ([indexPath row] == 0) ? self.emailField : self.passwordField;
    [cell.contentView addSubview:field];
    
    // Layout
    [cell.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-0-[field(==cell)]-0-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"field": field, @"cell": cell.contentView}]];
    
    [cell.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-0-[field(==cell)]-0-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"field": field, @"cell": cell.contentView}]];
    
    return cell;
}


#pragma mark - Form Submission

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [textField resignFirstResponder];
        [self submitForm];
    }
    
    return YES;
}

// Show that work is being done
// Add a spinner and overlay that will be removed once the login is complete
- (UIView *)addOverlay
{
    UIView *overlay = [[UIView alloc] init];
    [overlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    [overlay setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [spinner startAnimating];
    
    UIView *window = [[UIApplication sharedApplication] delegate].window;
    [window addSubview:overlay];
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
    [window addConstraints:[NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|-0-[overlay(==view)]-0-|"
                            options:NSLayoutFormatAlignAllCenterY
                            metrics:nil
                            views:@{@"overlay": overlay, @"view": window}]];
    
    [window addConstraints:[NSLayoutConstraint
                            constraintsWithVisualFormat:@"V:|-0-[overlay(==view)]-0-|"
                            options:NSLayoutFormatAlignAllCenterX
                            metrics:nil
                            views:@{@"overlay": overlay, @"view": window}]];
    
    return overlay;
}

- (void)submitForm
{
    // Check to see if the email looks ok
    NSString *error = @"Invalid Email Address";
    NSString *emailRegex = @".+@.+\\..+";
    if([self.emailField.text rangeOfString:emailRegex options:NSRegularExpressionSearch].location == NSNotFound) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:3];
        [data setObject:self.emailField.text forKey:@"email"];
        [data setObject:self.passwordField.text forKey:@"password"];
        [data setObject:[[MGSession instance] getLoginType:MINGLE_TYPE] forKey:@"type"];
        
        // Perform post login attempt logic
        UIView *overlay = [self addOverlay];
        [[MGSession instance] login:data complete:^(NSDictionary *response, NSError *error) {
            
            [overlay removeFromSuperview];
            
            NSString *errorMessage = nil;
            
            // Represents an error with connection
            if(error != nil) {
                errorMessage = error.description;
                
            // Could not get a valid response
            } else if([response objectForKey:@"code"] == nil) {
                errorMessage = @"Invalid Response";
                
            // Represents an internal error (e.g. invalid credentials)
            } else if([[response objectForKey:@"code"] intValue] != 0) {
                errorMessage = [response objectForKey:@"error"];
            }
            
            if(errorMessage != nil) {
                [[[UIAlertView alloc]
                  initWithTitle:@"Error"
                  message:errorMessage
                  delegate:nil
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil] show];
            }
            
        }];
        
    }
}


@end
