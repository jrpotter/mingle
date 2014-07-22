//
//  MGIconButton.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGIconButton.h"

@implementation MGIconButton

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _identifier = nil;
        _textColor = [UIColor whiteColor];
        _selectedTextColor = MINGLE_DARK_COLOR;
        
        _icon = [[UILabel alloc] init];
        [_icon setFont:BUTTON_FONT];
        [_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _text = [[UILabel alloc] init];
        [_text setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Build Hierarchy
        [self addSubview:_icon];
        [self addSubview:_text];
        
        // Add Constraints
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-15-[icon]-15-[text]"
                              options:NSLayoutFormatAlignAllCenterY
                              metrics:nil
                              views:@{@"icon": _icon, @"text": _text}]];
        
        for(UILabel *label in @[_icon, _text]) {
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|-10-[label]-10-|"
                                  options:NSLayoutFormatAlignAllCenterY
                                  metrics:nil
                                  views:@{@"label": label}]];
        }
    }
    
    return self;
}


#pragma mark - Setters

- (void)setIconFont:(UIFont *)iconFont
{
    _iconFont = iconFont;
    [_icon setFont:iconFont];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [_text setFont:textFont];
}


#pragma mark - Text Attributes

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if(selected) {
        [self.icon setTextColor:self.selectedTextColor];
        [self.text setTextColor:self.selectedTextColor];
    } else {
        [self.icon setTextColor:self.textColor];
        [self.text setTextColor:self.textColor];
    }
}

@end
