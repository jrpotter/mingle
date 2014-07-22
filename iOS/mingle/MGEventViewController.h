//
//  MGEventViewController.h
//  mingle
//
//  Contains the actual data regarding the event (for example, the image,
//  name, date, etc.)
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGEventViewController : UIViewController
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *datetime;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *max_size;
- (id)initWithData:(NSDictionary *)event;
@end
