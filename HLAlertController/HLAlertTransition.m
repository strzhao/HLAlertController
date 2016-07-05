//
//  HLAlertTransition.m
//  WangYIPhotoDemo
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import "HLAlertTransition.h"

@interface HLAlertTransition ()
@property (strong, nonatomic) UIView *vFade;
@end
@implementation HLAlertTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.isDismiss ? [self dismissAnimateTransition:transitionContext] : [self presentAnimateTransition:transitionContext];
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext  {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (self.style == HLAlertControllerStyleActionSheet) {
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _vFade.alpha = 0;
                             fromVC.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromVC.view.bounds));
                         } completion:^(BOOL finished) {
                             [self.vFade removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:.1
                              delay:.0
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             fromVC.view.transform = CGAffineTransformMakeScale(.9, .9);
                             fromVC.view.alpha = .8;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.vFade.alpha = 0;
                                                  fromVC.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                                  fromVC.view.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [self.vFade removeFromSuperview];
                                                  [transitionContext completeTransition:YES];
                                              }];
                             
                         }];
    }
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext  {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fadeView = [[UIView alloc] initWithFrame:toVC.view.bounds];
    fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    fadeView.alpha = 0;
    self.vFade = fadeView;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fadeView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (self.style == HLAlertControllerStyleActionSheet) {
        
        toVC.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        toVC.view.layer.shadowOffset = CGSizeMake(0, -2);
        toVC.view.layer.shadowOpacity = .75;
        toVC.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toVC.view.bounds));
        
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:.85
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fadeView.alpha = 1;
                             toVC.view.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [containerView addSubview:toVC.view];
        
        CGAffineTransform transform  = CGAffineTransformMakeRotation(M_PI /5.6f);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(0, 0);
        CGAffineTransform transform3 = CGAffineTransformConcat(transform, transform2);
        toVC.view.transform = transform3;

        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:.65
              initialSpringVelocity:.8
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fadeView.alpha = 1;
                             toVC.view.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];

    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.isDismiss ? .4 : .5;
}

@end
