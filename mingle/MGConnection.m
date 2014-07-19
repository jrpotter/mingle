//
//  MGConnection.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGConnection.h"
#import "MGConnectionQueues.h"

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

+ (void)getImage:(NSString *)url complete:(void (^)(UIImage *))complete
{
    
}

+ (void)getOpenImage:(NSString *)url complete:(void (^)(UIImage *))complete
{
    NSURL *image_url = [NSURL URLWithString:url];
    dispatch_async([[MGConnectionQueues instance] nextImageQueue], ^{
        NSData *data = [NSData dataWithContentsOfURL:image_url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            complete(image);
        });
    });
}


#pragma mark - Requests

+ (void)sendRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *, NSError *))complete
{
    /*NSDictionary *credentials = [[MGSession instance] credentials];
    if(credentials == nil) {
        [[MGSession instance] logout];
        
        // Otherwise continue with the request
    } else {
        MGDataConnection *connection = [[MGDataConnection alloc] initWithURL:url];
        NSMutableDictionary *request = [[NSMutableDictionary alloc] initWithDictionary:data];
        for(id key in credentials) [request setObject:credentials[key] forKey:key];
        [connection sendData:request complete:complete];
    }*/
}

+ (void)sendOpenRequest:(NSString *)url data:(NSDictionary *)data complete:(void (^)(NSDictionary *response, NSError *error))complete;
{
    // Build up the parameter list
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    for(NSString *key in data) {
        NSString *k = [MGConnection urlEncode:key];
        NSString *v = [MGConnection urlEncode:data[key]];
        [entries addObject:[NSString stringWithFormat:@"%@=%@", k, v]];
    }
    
    // Build POST values
    NSString *post = [entries componentsJoinedByString:@"&"];
    NSData *post_data = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *post_length = [NSString stringWithFormat:@"%d",[post_data length]];

    // Build URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:post_data];
    [request setValue:post_length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Send the request
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[MGConnectionQueues instance] nextRequestQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^(void) {
             if(error) {
                 [[[UIAlertView alloc]
                   initWithTitle:@"Error"
                   message:error.localizedDescription
                   delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil] show];
             } else {
                 NSError *json_error;
                 NSDictionary *json_response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&json_error];
                 complete(json_response, error);
             }
         });
     }];
}



@end
