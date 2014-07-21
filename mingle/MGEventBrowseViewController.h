//
//  MGEventBrowseViewController.h
//
//  The following contains a slideshow of the events in the surrounding area.
//  If an event is tapped, one can drill further into information about it
//  as well as join the event.
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MGNavigationViewController.h"
#import "MGPageViewController.h"

@interface MGEventBrowseViewController : MGNavigationViewController
           <MGPageViewControllerDelegate, MGPageViewControllerDataSource, CLLocationManagerDelegate>

@end
