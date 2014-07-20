//
//  UIColor+Hex.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex
{
    float r = ((float)((hex & 0xFF0000) >> 16))/255.0;
    float g = ((float)((hex & 0x00FF00) >>  8))/255.0;
    float b = ((float)((hex & 0x0000FF) >>  0))/255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
