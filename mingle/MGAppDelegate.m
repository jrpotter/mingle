//
//  MGAppDelegate.m
//  mingle
//
//  Created by UNC ResNET on 7/18/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGRootViewController.h"
#import "MGLoginViewController.h"
#import "MGWelcomeViewController.h"
#import "MGConnection.h"
#import "MGSession.h"
#import "UIView+ViewEffects.h"

@implementation MGAppDelegate

#pragma mark - System Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self presentLoginViewController:NO];
    
    // We attempt to login if possible, in order to save user data that we need
    if([[MGSession instance] getLoginStatus]) {
        UIView *overlay = [UIView addLoadingOverlay];
        [[MGSession instance] login:[[MGSession instance] credentials] complete:^(NSDictionary *response, NSError *error) {
            [overlay removeFromSuperview];
            if([MGConnection responseErrorString:response error:error] == nil) {
                [self presentPostLoginViewController:YES];
            } else {
                [[MGSession instance] logout];
            }
        }];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types
    // of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the
    // application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
    // Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application
    // state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of
    // applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the
    // application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Custom Methods

- (void)presentLoginViewController:(BOOL)animated
{
    MGLoginViewController *login = [[MGLoginViewController alloc] init];
    if(animated) {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [self.window setRootViewController:login]; }
                        completion:nil];
    } else {
        [self.window setRootViewController:login];
    }
    
}

- (void)presentPostLoginViewController:(BOOL)animated
{
    UIViewController *next = nil;
    NSString *welcome = @"shownWelcome";
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:welcome]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:welcome];
        next = [[MGWelcomeViewController alloc] init];
    } else {
        next = [[MGRootViewController alloc] init];
    }
    
    if(animated) {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [self.window setRootViewController:next]; }
                        completion:nil];
    } else {
        [self.window setRootViewController:next];
    }
}


@end
