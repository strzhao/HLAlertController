//
//  HLAlertTransitionController.m
//  WangYIPhotoDemo
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import "HLAlertTransitionController.h"
#import "HLAlertTransition.h"

@interface HLAlertTransitionController()
@property (weak,nonatomic) UIViewController *presentingVC;
@property (strong, nonatomic) HLAlertTransition *transition;
@property (assign, nonatomic) HLAlertControllerStyle style;
@end
@implementation HLAlertTransitionController

- (id)initWithPresentingViewController:(UIViewController *)presentingVC
{
    self = [super init];
    if (self) {
        self.presentingVC = presentingVC;
        self.transition = [[HLAlertTransition alloc] init];
    }
    return self;
}

- (void)presentViewController:(UIViewController *)viewController style:(HLAlertControllerStyle)style {
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    self.style = style;
    
    [self.presentingVC presentViewController:viewController animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _transition.style = _style;
    _transition.isDismiss = NO;
    return _transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _transition.style = _style;
    _transition.isDismiss = YES;
    return _transition;
}


@end
