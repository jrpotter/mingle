//
//  MGPageViewControllerDataSource.h
//
//  Used to feed view controllers to the MGPageViewController.
//  When the beforePageViewController call has been
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGPageViewControllerDataSource
- (UIViewController *)beforePageViewController:(UIViewController *)viewController;
- (UIViewController *)afterPageViewController:(UIViewController *)viewController;
@end
