//
//  HLAlertTransitionController.h
//  WangYIPhotoDemo
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAlertController.h"

@interface HLAlertTransitionController : NSObject<UIViewControllerTransitioningDelegate>

- (id)initWithPresentingViewController:(UIViewController*)presentingVC;

- (void)presentViewController:(UIViewController*)viewController style:(HLAlertControllerStyle)style;

@end
