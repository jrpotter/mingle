//
//  MGConnectionQueues.m
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGConnectionQueues.h"

static NSInteger queueCount = 6;

@interface MGConnectionQueues ()
@property (nonatomic) NSInteger imageIndex;
@property (nonatomic) NSInteger requestIndex;
@property (strong, nonatomic) NSMutableArray *imageQueues;
@property (strong, nonatomic) NSMutableArray *requestQueues;
@end

@implementation MGConnectionQueues

#pragma mark - Initialization

+ (id)instance
{
    static MGConnectionQueues *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super self];
    if(self) {
        
        _imageIndex = 0;
        _requestIndex = 0;
        _imageQueues = [[NSMutableArray alloc] init];
        _requestQueues = [[NSMutableArray alloc] init];
        
        // Note the queues created must be serial (otherwise, it kind of defeats the purpose
        // of this class)
        for(NSInteger i = 0; i < queueCount; i++) {
            [_imageQueues addObject:dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL)];
            [_requestQueues addObject:[[NSOperationQueue alloc] init]];
            [[_requestQueues objectAtIndex:[_requestQueues count]-1] setMaxConcurrentOperationCount:1];
        }
    }
    
    return self;
}

#pragma mark - Queue Getters

- (dispatch_queue_t)nextImageQueue
{
    self.imageIndex++;
    if(self.imageIndex == queueCount) {
        self.imageIndex = 0;
    }
    
    return [self.imageQueues objectAtIndex:self.imageIndex];
}

- (NSOperationQueue *)nextRequestQueue
{
    self.requestIndex++;
    if(self.requestIndex == queueCount) {
        self.requestIndex = 0;
    }
    
    return [self.requestQueues objectAtIndex:self.requestIndex];
}



@end
