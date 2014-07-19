//
//  MGPageViewController.h
//
//  I've been pretty frustrated with the UIPageViewController, as I've found
//  it to be pretty buggy for even simple tasks (especially with a scroll
//  transition style).
//
//  Here I write an alternative that uses autolayout to size the page view controllers
//  and a scroll view (paged) to always have at most three sub view controllers.
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPageViewControllerDelegate.h"
#import "MGPageViewControllerDataSource.h"

@interface MGPageViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) NSObject<MGPageViewControllerDelegate> *delegate;
@property (weak, nonatomic) NSObject<MGPageViewControllerDataSource> *dataSource;
- (void)setViewController:(UIViewController *)controller;
@end
