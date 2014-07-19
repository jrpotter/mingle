//
//  MGConnection.h
//
//  This class represents the communication made between the server and
//  client. All requests are made through this. Note the corresponding
//  "Open" function does not require credentials to be passed.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGConnection : NSObject
// String methods used to sanitize any input passed to URL
+ (NSString *)urlEncode:(NSString *)string;
+ (NSString *)truncate:(NSString *)string length:(NSInteger)length;

// The following sends out a request and returns an image with the results
+ (void)getImage:(NSString *)url complete:(void (^)(UIImage *image))complete;
+ (void)getOpenImage:(NSString *)url complete:(void (^)(UIImage *image))complete;

// The following sends out a form (POSTed) to the passed URL
+ (void)sendRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *response, NSError *error))complete;
+ (void)sendOpenRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *response, NSError *error))complete;
@end
