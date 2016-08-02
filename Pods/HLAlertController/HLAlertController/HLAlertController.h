//
//  HLAlertController.h
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 String Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLAlertAction;

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






@interface HLAlertController : UIViewController

/**
 *  创建一个HLAlertController
 *
 *  @param title          标题
 *  @param message        详情
 *  @param preferredStyle 样式 值为HLAlertControllerStyle
 *
 *  @return HLAlertController对象
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HLAlertControllerStyle)preferredStyle;

- (void)showWithViewController:(UIViewController *)viewController;

#pragma mark - actions
/**
 *  添加一个显示选项
 *
 *  @param action HLAlertAction对象
 */
- (void)addAction:(HLAlertAction *)action;
@property (nonatomic, readonly) NSArray<HLAlertAction *> *actions;   ///< 已经添加的HLAlertActiond对象组


#pragma mark - textFields
/**
 *  添加一个UITextField 置顶显示
 *
 *  @param configure 设置UITextField的回调
 */
- (void)addTextFieldWithConfigure:(void(^)(UITextField *textField))configure;
@property (nonatomic, readonly) NSArray<UITextField *> *textFields;     ///< 已经添加的UITextField对象组


#pragma mark - property
@property (nonatomic, readonly, copy) NSString *titleAlert;         ///< 标题
@property (nonatomic, readonly, copy) NSString *message;            ///< 详情
@property (nonatomic, readonly, assign) HLAlertControllerStyle preferredStyle;  ///< 样式
@property (assign, nonatomic, readwrite) BOOL autoSelectTextFieldText;          ///< 是否自动选中文字 默认为NO

@end




@interface HLAlertAction : UIView

/**
 *  创建一个显示选项
 *
 *  @param title   选项标题
 *  @param style   选项的样式 值为HLAlertActionStyle
 *  @param handler 选项点击回调
 *
 *  @return HLAlertAction对象
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(HLAlertActionStyle)style handler:(void (^)(HLAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;    ///< 选项标题
@property (nonatomic, readonly) HLAlertActionStyle style;   ///< 选项样式
@property (copy, nonatomic, readonly) void (^handler)(HLAlertAction *);   ///< 选项点击回调

@end


