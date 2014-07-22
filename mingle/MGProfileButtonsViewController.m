//
//  MGProfileButtonsViewController.m
//  mingle
//
//  Created by UNC ResNET on 7/21/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGProfileButtonsViewController.h"

@interface MGProfileButtonsViewController ()
@property (nonatomic) CGFloat buttonDimension;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *constraints;
@end

@implementation MGProfileButtonsViewController

- (id)initWithMessages:(BOOL)withMessages
{
    self = [super init];
    if (self) {
        
        
        _eventsButton = [[UIButton alloc] init];
        [_eventsButton setTitle:EVENT_ICON forState:UIControlStateNormal];
        
        _friendsButton = [[UIButton alloc] init];
        [_friendsButton setTitle:FRIENDS_ICON forState:UIControlStateNormal];
        
        // These constraints are set during the viewDidLoad
        _buttonDimension = 35;
        _constraints = [[NSMutableArray alloc] init];
        _buttons = [[NSMutableArray alloc] initWithArray:@[_eventsButton, _friendsButton]];
        
        // Add Messages
        if(withMessages) {
            _messagesButton = [[UIButton alloc] init];
            [_messagesButton setTitle:MESSAGES_ICON forState:UIControlStateNormal];
            [_buttons addObject:_messagesButton];
        } else {
            _messagesButton = nil;
        }
        
        // Setup Buttons
        for(UIButton *button in _buttons) {
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            [button.titleLabel setFont:BUTTON_FONT];
            [button addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(contract:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(contract:) forControlEvents:UIControlEventTouchUpOutside];
        }
    }
    
    return self;
}


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *visual = @"H:|";
    NSMutableDictionary *views = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.view, @"view", nil];
    
    for(NSUInteger i = 0; i < [self.buttons count]; i++) {
        UIButton *button = self.buttons[i];
        
        // Build Hierarchy
        [self.view addSubview:button];
        
        // Build Constraints
        [self.constraints addObject:[NSLayoutConstraint
                                     constraintWithItem:button
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                     constant:self.buttonDimension]];
        
        // Ensure the button is always equally dimensional
        [self.view addConstraint:self.constraints[i]];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:button
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:button
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1.0
                                  constant:0]];
        
        // Vertically Fit Buttons
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:button
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                  constant:0]];
        
        // Build Horizontal Layout
        NSString *key = [NSString stringWithFormat:@"button_%d", (int)i];
        NSString *layout = [NSString stringWithFormat:@"-10-[%@]", key];
        
        [views setObject:button forKey:key];
        visual = [visual stringByAppendingString:layout];
        
        // At this point, it is safe to finish setting up the button
        [self contract:button];
    }
    
    // Horizontally Layout
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:[NSString stringWithFormat:@"%@-10-|", visual]
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:views]];
}


#pragma mark - Events

- (void)expand:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUInteger index = [self.buttons indexOfObject:button];
    NSLayoutConstraint *constraint = [self.constraints objectAtIndex:index];
    
    // Expand and color accordingly
    constraint.constant = self.buttonDimension;
    [button setBackgroundColor:MINGLE_DARK_COLOR];
    [button.layer setCornerRadius:(constraint.constant / 2)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)contract:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUInteger index = [self.buttons indexOfObject:button];
    NSLayoutConstraint *constraint = [self.constraints objectAtIndex:index];
    
    // Shrink down and color accordingly
    constraint.constant = self.buttonDimension;
    [button.layer setCornerRadius:(constraint.constant / 2)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
}


@end
