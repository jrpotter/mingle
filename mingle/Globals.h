//
//  Globals.h
//  This file has been appended to mingle-Prefix.pch for accessibility in all files.
//
//  Created by UNC ResNET on 7/1/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#ifndef mingle_Header_h
#define mingle_Header_h

// Colors
#define MINGLE_COLOR                        [UIColor colorWithRed:92/255.0 green:160/255.0 blue:211/255.0 alpha:0.7]
#define MINGLE_DARK_COLOR                   [UIColor colorWithRed:41/255.0 green:109/255.0 blue:160/255.0 alpha:0.7]
#define MINGLE_LIGHT_COLOR                  [UIColor colorWithRed:169/255.0 green:237/255.0  blue:255/255.0 alpha:0.7]
#define SPRINGBOARD_COLOR                   [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.7]
#define MESSAGES_COLOR                      [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.7]
#define TWITTER_COLOR                       [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:0.7]

// Fonts
#define MINGLE_FONT                         [UIFont fontWithName:@"Bauhaus 93" size:20]
#define BUTTON_FONT                         [UIFont fontWithName:@"icomoon" size:20]
#define NUMBER_FONT                         [UIFont fontWithName:@"Walkway Black" size:20]

// Images
#define BACKGROUND_IMAGE                    [UIImage imageNamed:@"mingle_background.png"]
#define EMPTY_PROFILE_IMAGE                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_profile" ofType:@"png"]]

// URLS
#define MINGLE_ROOT_URL                     @"https://mingle-fuzzykayak.rhcloud.com/"
#define MINGLE_STATIC_URL                   @"https://mingle-fuzzykayak.rhcloud.com/static/"
#define MINGLE_ALIAS_CREATE_URL             @"https://mingle-fuzzykayak.rhcloud.com/alias/create/"
#define MINGLE_ALIAS_FORGOT_PASSWORD        @"https://mingle-fuzzykayak.rhcloud.com/alias/recover/"
#define MINGLE_LOGIN_URL                    @"https://mingle-fuzzykayak.rhcloud.com/alias/login/"
#define MINGLE_PROFILE_URL                  @"https://mingle-fuzzykayak.rhcloud.com/alias/profile/"
#define MINGLE_EVENT_QUERY_URL              @"https://mingle-fuzzykayak.rhcloud.com/event/query/"
#define MINGLE_EVENT_CREATE_URL             @"https://mingle-fuzzykayak.rhcloud.com/event/create/"
#define MINGLE_STREET_VIEW_URL              @"https://mingle-fuzzykayak.rhcloud.com/event/street/"
#define MINGLE_STATIC_STREET_VIEW_URL       @"https://maps.googleapis.com/maps/api/streetview"

// Icons
#define ABOUT_ICON                          @"\ue6f7"
#define BACK_ICON                           @"\ue666"
#define BROWSE_ICON                         @"\ue6c2"
#define CAMERA_ICON                         @"\ue60f"
#define CHECKMARK_ICON                      @"\ue6fe"
#define CHEVRON_LEFT_ICON                   @"\ue918"
#define CHEVRON_RIGHT_ICON                  @"\ue91b"
#define CREATE_ICON                         @"\ue702"
#define CLOSE_ICON                          @"\ue6fa"
#define CONFIRM_ICON                        @"\ue6fb"
#define CROP_ICON                           @"\ue73d"
#define EDIT_ICON                           @"\ue605"
#define EVENT_ICON                          @"\ue642"
#define FRIENDS_ICON                        @"\ue63e"
#define INVITE_ICON                         @"\ue75e"
#define LOGOUT_ION                          @"\ue704"
#define MAP_ICON                            @"\ue642"
#define MESSAGES_ICON                       @"\ue66f"
#define NEW_ICON                            @"\ue702"
#define PROFILE_ICON                        @"\ue674"
#define SEARCH_ICON                         @"\ue67f"
#define SETTINGS_ICON                       @"\ue68f"
#define SPRINGBOARD_ICON                    @"\ue6b8"
#define STREET_ICON                         @"\ue6c2"
#define TWITTER_ICON                        @"\ue76d"

#endif
