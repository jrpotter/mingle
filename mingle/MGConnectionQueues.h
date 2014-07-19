//
//  MGConnectionQueues.h
//  mingle
//
//  The following singleton class is a simple abstraction on maintaining the number
//  of needed queues for each type of call. We maintain multiple queues for each
//  respective call type (currently image and request) so as not to throttle the calls,
//  and to also avoid dispatching to many threads.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGConnectionQueues : NSObject
+ (id)instance;
- (dispatch_queue_t)nextImageQueue;
- (NSOperationQueue *)nextRequestQueue;
@end
