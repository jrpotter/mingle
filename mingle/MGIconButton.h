//
//  MGIconButton.h
//
//  The icon button simply adds on an identifier, for more flexible usage
//  than just the tag property available in a UIButton.
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGIconButton : UIButton
@property (strong, nonatomic) id identifier;
@end
