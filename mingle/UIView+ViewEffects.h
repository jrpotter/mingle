//
//  UIView+UIView_ImageEffects.h
//  mingle
//
//  Created by UNC ResNET on 7/19/14.
//  Copyright (c) 2014 FuzzyKayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewEffects)
-(UIImage *)convertViewToImage;
+ (UIView *)addLoadingOverlay;
+ (UIView *)addLoadingOverlay:(UIView *)targetView;
@end
