//
//  MGConnection.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGConnection.h"
#import "MGConnectionQueues.h"
#import "MGSession.h"

@implementation MGConnection

#pragma mark - String Processing

+ (NSString *)urlEncode:(NSString *)string
{
    NSString *escape = @"!*'\"();:@&=+$,/?%#[]% ";
    CFStringEncoding e2e = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
    CFStringRef percent_escape = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)escape, e2e);
    
    return (NSString *)CFBridgingRelease(percent_escape);
}

+ (NSString *)truncate:(NSString *)string length:(NSInteger)length
{
    NSRange range = {0, MIN([string length], length)};
    return [string substringWithRange:[string rangeOfComposedCharacterSequencesForRange:range]];
}


#pragma mark - Images

// The following is similar to getOpenImage, but requires credentials to be
// passed. We simply URL encode a form and grab the results from the server
+ (void)getImage:(NSString *)url complete:(void (^)(UIImage *))complete
{
    NSDictionary *credentials = [[MGSession instance] credentials];
    if(credentials != nil) {
        dispatch_async([[MGConnectionQueues instance] nextImageQueue], ^{
            
            // Build up the parameter list
            NSMutableArray *entries = [[NSMutableArray alloc] init];
            for(NSString *key in credentials) {
                NSString *k = [MGConnection urlEncode:key];
                NSString *v = [MGConnection urlEncode:credentials[key]];
                [entries addObject:[NSString stringWithFormat:@"%@=%@", k, v]];
            }
            
            // Build POST values
            NSString *post = [entries componentsJoinedByString:@"&"];
            NSData *post_data = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *post_length = [NSString stringWithFormat:@"%lu",(unsigned long)[post_data length]];

            // Build URL
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:post_data];
            [request setURL:[[NSURL alloc] initWithString:url]];
            [request setValue:post_length forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            // Send the request
            NSError *error = nil;
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            // Return Image
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error) {
                    complete(nil);
                } else {
                    complete([UIImage imageWithData:data]);
                }
            });
        });
    }
}


// An open image simply means no credentials need to be passed to get the image
+ (void)getOpenImage:(NSString *)url complete:(void (^)(UIImage *))complete
{
    NSURL *image_url = [NSURL URLWithString:url];
    dispatch_async([[MGConnectionQueues instance] nextImageQueue], ^{
        NSData *data = [NSData dataWithContentsOfURL:image_url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([image CIImage] == nil && [image CGImage] == NULL) {
                complete(nil);
            } else {
                complete(image);
            }
        });
    });
}


#pragma mark - Requests

// The following passes credentials in with the request
+ (void)sendRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *, NSError *))complete
{
    NSDictionary *credentials = [[MGSession instance] credentials];
    if(credentials != nil) {
        NSMutableDictionary *request = [[NSMutableDictionary alloc] initWithDictionary:data];
        for(id key in credentials) [request setObject:credentials[key] forKey:key];
        [MGConnection sendOpenRequest:url data:request complete:^(NSDictionary *response, NSError *error) {
            complete(response, error);
        }];
    }
}

// The following can post both strings and images to the server for processing
+ (void)sendOpenRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *response, NSError *error))complete;
{
    // Build Request Object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // Generate random boundary
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *boundary = [NSMutableString stringWithCapacity:30];
    for (NSUInteger i = 0; i < 30; i++) {
        u_int32_t r = arc4random() % 62;
        unichar c = [alphabet characterAtIndex:r];
        [boundary appendFormat:@"%C", c];
    }
    
    // Build Content Type
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Build up body
    NSMutableData *body = [NSMutableData data];
    for(NSString *key in data) {
        if([data[key] isKindOfClass:[UIImage class]]) {
            NSString *contentDispositionFormat = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:contentDispositionFormat, key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:UIImageJPEGRepresentation(data[key], 1)];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
        // Must be a string
        } else {
            NSString *contentDispositionFormat = @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:contentDispositionFormat, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", data[key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // Close off
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPBody:body];
    
    // Send the request
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[MGConnectionQueues instance] nextRequestQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^(void) {
             if(error) {
                 complete(nil, error);
             } else {
                 NSError *json_error;
                 NSDictionary *json_response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&json_error];
                 complete(json_response, error);
             }
         });
     }];
}


#pragma mark - Error Handling
+ (NSString *)responseErrorString:(NSDictionary *)response error:(NSError *)error
{
    NSString *message = nil;
    
    // Represents an error with connection
    if(message != nil) {
        message = error.description;
        
    // Could not get a valid response
    } else if(response[@"code"] == nil) {
        message = @"Server timeout. Please try again in a few minutes.";
        
    // Represents an internal error (e.g. invalid credentials)
    } else if([response[@"code"] intValue] != 0) {
        message = response[@"error"];
    }
    
    return message;
}


@end
