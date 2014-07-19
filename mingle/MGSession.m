//
//  MGSession.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGSession.h"

@implementation MGSession

#pragma mark - Initialization

+ (id)instance
{
    static MGSession *instance = nil;
    dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
