//
//  MGSpringboardViewControllerDelegate.h
//
//  Simply notifies delegates a branch switch has been made, and which
//  branch that was.
//
//  Created by UNC ResNET on 7/20/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGNavigationViewController.h"

typedef enum
{
    FEATURED_BRANCH,
    BROWSE_BRANCH,
    CREATE_BRANCH,
    SEARCH_BRANCH,
    SETTINGS_BRANCH,
    PROFILE_BRANCH,
    FRIENDS_BRANCH,
    INVITE_BRANCH,
    LOGOUT_BRANCH,
    ABOUT_BRANCH
}
BRANCH;

@protocol MGSpringboardViewControllerDelegate <NSObject>
- (void)selectedBranch:(BRANCH)branch;
@end
