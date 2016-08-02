//
//  HLAlertTransition.h
//  WangYIPhotoDemo
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAlertController.h"

@interface HLAlertTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) HLAlertControllerStyle style;
@property (assign, nonatomic) BOOL isDismiss;

@end
