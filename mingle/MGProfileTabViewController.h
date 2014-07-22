//
//  MGProfileTabViewController.h
//  mingle
//
//  Created by UNC ResNET on 7/21/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGNavigationViewController.h"

@interface MGProfileTabViewController : MGNavigationViewController <UITabBarControllerDelegate>
- (id)initWithUserData:(NSDictionary *)userData personal:(BOOL)personal;
@end
