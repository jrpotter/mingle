//
//  MGSession.h
//
//  The session keeps track of the user's login (depending on the method
//  employed). It is a singleton used to keep track of the user's login
//  information.
//
//  Note, that while the following doesn't need to be a singleton currently,
//  I forsee this holding some Facebook/Twitter specific content.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MINGLE,
    FACEBOOK,
    TWITTER
} LOGIN_TYPE;

@interface MGSession : NSObject

+ (id)instance;

- (BOOL)getLoginStatus;
- (NSString *)getLoginType:(LOGIN_TYPE)type;

- (void)logout;
- (NSDictionary *)getCredentials;
- (void)login:(NSDictionary *)entries complete:(void (^)(NSDictionary *response, NSError *error))complete;

@end
