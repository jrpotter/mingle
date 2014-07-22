//
//  MGWelcomeViewController.h
//
//  The following will only be seen the first time the user logs in, as a means
//  of greetings, as well as a quick introduction on what mingle is.
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPageViewController.h"

@interface MGWelcomeViewController : UIViewController <MGPageViewControllerDelegate, MGPageViewControllerDataSource>

@end
