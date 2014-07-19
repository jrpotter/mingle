//
//  MGSession.h
//
//  The session keeps track of the user's login (depending on the method
//  employed). It is a singleton used 
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSession : NSObject
+ (id)instance;
@end
