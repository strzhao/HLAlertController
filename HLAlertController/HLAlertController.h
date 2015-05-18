//
//  HLAlertController.h
//  JGActionSheet Tests
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 Jonas Gessner. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 style for button
 */
typedef NS_ENUM(NSInteger, HLAlertActionStyle) {
    HLAlertActionStyleDefault = 0,
    HLAlertActionStyleCancel,
    HLAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, HLAlertControllerStyle) {
    HLAlertControllerStyleActionSheet,
    HLAlertControllerStyleAlert,
};

@interface HLAlertAction : UIView

+ (instancetype)actionWithTitle:(NSString *)title style:(HLAlertActionStyle)style handler:(void (^)(HLAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) HLAlertActionStyle style;

@end

@interface HLAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HLAlertControllerStyle)preferredStyle;

- (void)showWithViewController:(UIViewController *)viewController;

- (void)addAction:(HLAlertAction *)action;
@property (nonatomic, readonly) NSArray *actions;

- (void)addTextFieldWithConfigure:(void(^)(UITextField *textField))configure;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, readonly) NSString *titleAlert;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) HLAlertControllerStyle preferredStyle;

@end


@interface HLAlertControllerTransitionManager : NSObject

+ (void)presentAlertViewController:(UIViewController *)alertViewController presentViewController:(UIViewController *)viewController style:(HLAlertControllerStyle)style;

@end