//
//  HLAlertController.m
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 String Zhao. All rights reserved.
//

#import "HLAlertController.h"
#import "HLAlertTransitionController.h"
#import "HLKeyboardNotificationCenter.h"
#import <objc/runtime.h>

#import "UIImage+HLColor.h"
#import "UITextField+HLAdd.h"
#import "UIView+HLExtension.h"




/**
 *  用自定义transition的方式显示alertController的简便对象
 */
@interface HLAlertControllerTransitionManager : NSObject

+ (void)presentAlertViewController:(HLAlertController *)alertViewController presentViewController:(UIViewController *)viewController;

@end


@interface HLAlertControllerTransitionManager ()
@property (strong, nonatomic) HLAlertTransitionController *transition;      ///< 自定义transition对象
@end
@implementation HLAlertControllerTransitionManager

+ (instancetype)sharedAlertcontrollerTransitionManager {
    static HLAlertControllerTransitionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HLAlertControllerTransitionManager alloc] init];
    });
    return manager;
}

+ (void)presentAlertViewController:(HLAlertController *)alertViewController presentViewController:(UIViewController *)viewController {
    
    HLAlertControllerTransitionManager *manager = [self sharedAlertcontrollerTransitionManager];
    manager.transition = [[HLAlertTransitionController alloc] initWithPresentingViewController:viewController];
    [manager.transition presentViewController:alertViewController style:alertViewController.preferredStyle];
}

@end











@interface HLAlertAction ()
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) HLAlertActionStyle style;
@property (copy, nonatomic, readwrite) void (^handler)(HLAlertAction *);

@property (nonatomic, strong) UIButton *btnAction;
@property (nonatomic, strong) UIView *vLine;

@end
@implementation HLAlertAction

#pragma mark - life circle

+ (instancetype)actionWithTitle:(NSString *)title style:(HLAlertActionStyle)style handler:(void (^)(HLAlertAction *))handler {
    return [[HLAlertAction alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(HLAlertActionStyle)style handler:(void (^)(HLAlertAction *))handler {
    self = [super init];
    if (!self) return nil;
    
    _title = title;
    _style = style;
    _handler = [handler copy];
    
    _btnAction = [UIButton new];
    [_btnAction setTitleColor:[self colorForStyle:style] forState:UIControlStateNormal];
    [_btnAction setTitle:title forState:UIControlStateNormal];
    [_btnAction setBackgroundImage:[UIImage HL_imageWithColor:[UIColor colorWithWhite:.9 alpha:1]] forState:UIControlStateHighlighted];
    [self addSubview:_btnAction];
    
    _vLine = [UIView new];
    _vLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:_vLine];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _btnAction.frame = self.bounds;
    _vLine.frame = self.bounds;
    _vLine.HL_height = _style == HLAlertActionStyleCancel ? 4 : .5;
}

#pragma mark - help

- (UIColor *)colorForStyle:(HLAlertActionStyle)style {
    switch (style) {
        case HLAlertActionStyleDefault:
            return [UIColor darkTextColor];
        case HLAlertActionStyleCancel:
            return [UIColor blackColor];
        case HLAlertActionStyleDestructive:
            return [UIColor redColor];
    }
}

@end












static CGFloat const        kHLAlertControllerWidthFactor = 0.853f;
static NSString const *     kHLAlertControllerKeyboard    = @"kHLAlertControllerKeyboard";


@interface HLAlertController ()
@property (nonatomic, readwrite) NSString *titleAlert;
@property (nonatomic, readwrite) NSString *message;
@property (nonatomic, readwrite) HLAlertControllerStyle preferredStyle;

@property (strong, nonatomic) NSMutableArray *actions;
@property (strong, nonatomic) NSMutableArray<UITextField *> *textFields;

@property (strong, nonatomic) UIView *vBack;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbMessage;

@end

@implementation HLAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeProperty];
    [self initializeView];
    [self addMotionEffectIfNeeded];
    [self registKeyboardIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self textFieldBecomeFirstResponderOnce];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [HLKeyboardNotificationCenter removeForKey:kHLAlertControllerKeyboard];
}

#pragma mark - action

- (void)tapOutSideCard:(UITapGestureRecognizer *)tap {
    if (!CGRectContainsPoint(_vBack.frame, [tap locationInView:self.view])) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [_textFields enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
            [obj resignFirstResponder];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldOnReturn:(UITextField *)textField {
    NSInteger idx = [_textFields indexOfObject:textField];
    if (idx == NSNotFound) return;
    if (idx >= _textFields.count - 1) {
        [textField resignFirstResponder];
        return;
    }
    [_textFields[idx + 1] becomeFirstResponder];
}

#pragma mark - public

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HLAlertControllerStyle)preferredStyle {
    
    HLAlertController *alertController = [HLAlertController new];
    alertController.actions = @[].mutableCopy;
    alertController.textFields = @[].mutableCopy;
    alertController.titleAlert = title;
    alertController.message = message;
    alertController.preferredStyle = preferredStyle;
    
    return alertController;
}

- (void)showWithViewController:(UIViewController *)viewController {
    
    [HLAlertControllerTransitionManager presentAlertViewController:self presentViewController:viewController];
}

- (void)addAction:(HLAlertAction *)action {
    
    if (!action) return;
    NSAssert(!(((HLAlertAction *)_actions.lastObject).style == HLAlertActionStyleCancel && action.style == HLAlertActionStyleCancel), @"cancel action must be one");
    [action.btnAction addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (action.style == HLAlertActionStyleCancel) {
        [_actions addObject:action];
        objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    else {
        NSUInteger index = _actions.count;
        if (objc_getAssociatedObject(self, _cmd)) index--;
        [_actions insertObject:action atIndex:index];
    }
}

- (void)addTextFieldWithConfigure:(void (^)(UITextField *))configure {
    
    NSAssert(self.preferredStyle == HLAlertControllerStyleAlert, @"text field must only add to alert style");
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [UIColor darkTextColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.returnKeyType = UIReturnKeyDone;
    [textField addTarget:self action:@selector(textFieldOnReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    !configure ?: configure(textField);
    if (_textFields.lastObject) _textFields.lastObject.returnKeyType = UIReturnKeyNext;

    [_textFields addObject:textField];
}

#pragma mark - action

- (void)actionButtonClicked:(UIButton *)sender {
    
    __weak typeof(self) wSelf = self;
    void (^completion)() = ^ {
      
        if (!wSelf) return;
        __strong typeof(wSelf) sSelf = wSelf;
        for (HLAlertAction *action in sSelf.actions) {
            if (![action.btnAction isEqual:sender]) continue;
            !action.handler ?: action.handler(action);
            return;
        }
    };
    [self dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - initialize

- (void)initializeProperty {
    
}

- (void)initializeView {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutSideCard:)]];
    self.view.backgroundColor = [UIColor clearColor];
    
    _vBack = [UIView new];
    _vBack.backgroundColor = [UIColor colorWithWhite:0.975 alpha:1];
    if (self.preferredStyle == HLAlertControllerStyleAlert) {
        _vBack.layer.masksToBounds = YES;
        _vBack.layer.cornerRadius = 5;
    }
    [self.view addSubview:_vBack];
    
    if (_titleAlert.length) {
        _lbTitle = [UILabel new];
        _lbTitle.text = _titleAlert;
        _lbTitle.font = [UIFont systemFontOfSize:18];
        _lbTitle.textColor = [UIColor blackColor];
        _lbTitle.numberOfLines = 0;
        _lbTitle.preferredMaxLayoutWidth = _vBack.HL_width - 60;
        [_vBack addSubview:_lbTitle];
    }
    if (_message.length) {
        _lbMessage = [UILabel new];
        _lbMessage.text = _message;
        _lbMessage.font = [UIFont systemFontOfSize:14];
        _lbMessage.textColor = [UIColor darkTextColor];
        _lbMessage.numberOfLines = 0;
        _lbMessage.textAlignment = NSTextAlignmentCenter;
        _lbMessage.preferredMaxLayoutWidth = _vBack.HL_width - 50;
        [_vBack addSubview:_lbMessage];
    }
    
    [_textFields enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
        [_vBack addSubview:obj];
    }];
    [_actions enumerateObjectsUsingBlock:^(HLAlertAction *action, NSUInteger idx, BOOL *stop) {
        [_vBack addSubview:action];
    }];
    
    [self layoutViews];
}

- (void)addMotionEffectIfNeeded {
    if (self.preferredStyle != HLAlertControllerStyleAlert) {
        return;
    }
    UIInterpolatingMotionEffect *effectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectHorizontal.minimumRelativeValue = @(-20);
    effectHorizontal.maximumRelativeValue = @(20);
    [_vBack addMotionEffect:effectHorizontal];
    
    UIInterpolatingMotionEffect *effectVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectVertical.minimumRelativeValue = @(-20);
    effectVertical.maximumRelativeValue = @(20);
    [_vBack addMotionEffect:effectVertical];
}

- (void)registKeyboardIfNeeded {
    if (self.preferredStyle == HLAlertControllerStyleActionSheet) {
        return;
    }
    if (!_textFields || _textFields.count == 0) {
        return;
    }
    
    __weak typeof(self) wSelf = self;
    [HLKeyboardNotificationCenter keyboardWillAppear:nil willChangeFrame:^(HLKeyboardInfo *keyboardInfo) {
        
        if (!wSelf) return;
        __strong typeof(wSelf) sSelf = wSelf;
        
        CGFloat limitMaxY = sSelf.view.HL_height - keyboardInfo.keyboardFrameEnd.size.height;
        CGFloat offsetY = sSelf.vBack.HL_bottom - limitMaxY;
        if (offsetY <= 0) {
            return;
        }
        [UIView animateWithDuration:keyboardInfo.keyboardAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sSelf.vBack.HL_centerY = sSelf.view.HL_centerY - 8 - offsetY;
        } completion:nil];
    } willDisappear:^(HLKeyboardInfo *keyboardInfo) {
        
        if (!wSelf) return;
        __strong typeof(wSelf) sSelf = wSelf;
        [UIView animateWithDuration:keyboardInfo.keyboardAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sSelf.vBack.HL_centerY = sSelf.view.HL_centerY;
        } completion:nil];
    } key:kHLAlertControllerKeyboard];
}

- (void)textFieldBecomeFirstResponderOnce {
    if (_textFields.count == 0 || objc_getAssociatedObject(self, _cmd)) return;
    objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [_textFields.firstObject becomeFirstResponder];
    [self selectTextFieldTextIfNeeded];
}

- (void)selectTextFieldTextIfNeeded {
    if (!_textFields || _textFields.count == 0 || !_autoSelectTextFieldText) return;
    [_textFields.firstObject HL_setSelectedRange:NSMakeRange(0, _textFields.firstObject.text.length)];
}

#pragma mark - layout

- (void)layoutViews {
    
    CGFloat factor = self.preferredStyle == HLAlertControllerStyleAlert ? kHLAlertControllerWidthFactor : 1;
    __block CGFloat backHeight = 20;
    _vBack.HL_width = self.view.HL_width * factor;
    _vBack.HL_centerX = self.view.HL_centerX;
    
    if (_titleAlert.length) {
        _lbTitle.HL_top = backHeight;
        _lbTitle.HL_size = [_lbTitle sizeThatFits:CGSizeMake(_vBack.HL_width - 60, CGFLOAT_MAX)];
        _lbTitle.HL_centerX = _vBack.HL_width / 2.;
        backHeight += _lbTitle.HL_height;
    }
    if (_message.length) {
        backHeight += 10;
        _lbMessage.HL_size = [_lbMessage sizeThatFits:CGSizeMake(_vBack.HL_width - 50, CGFLOAT_MAX)];
        _lbMessage.HL_centerX = _vBack.HL_width / 2.;
        _lbMessage.HL_top = backHeight;
        backHeight += _lbMessage.HL_height;
    }
    if (_lbTitle || _lbMessage) backHeight += 25;
    
    for (UITextField *textField in _textFields) {
        
        textField.HL_top = backHeight;
        textField.HL_height = 50;
        textField.HL_left = 16;
        textField.HL_width = _vBack.HL_width - 32;
        backHeight += 50;
    }
    if (_textFields.count) backHeight += 8;
    
    for (HLAlertAction *action in _actions) {
        action.HL_top = backHeight;
        action.HL_height = action.style == HLAlertActionStyleCancel ? 54 : 50;
        action.HL_width = _vBack.HL_width;
        action.HL_left = 0;
        backHeight += action.HL_height;
    }
    
    _vBack.HL_height = backHeight;
    if (_preferredStyle == HLAlertControllerStyleAlert) {
        _vBack.HL_centerY = self.view.HL_centerY;
    }
    else {
        _vBack.HL_bottom = self.view.HL_bottom;
    }
}

@end







@interface UIViewController (HLAlertController)
@end

@implementation UIViewController (HLAlertController)

+ (void)load {
    swizzleMethod(self, @selector(presentViewController:animated:completion:), @selector(swizzle_presentViewController:animated:completion:));
}

- (void)swizzle_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[HLAlertController class]] && !objc_getAssociatedObject(viewControllerToPresent, _cmd)) {
        objc_setAssociatedObject(viewControllerToPresent, _cmd, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
        [HLAlertControllerTransitionManager presentAlertViewController:(HLAlertController *)viewControllerToPresent presentViewController:self];
        return;
    }
    [self swizzle_presentViewController:viewControllerToPresent animated:YES completion:completion];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL isAdded = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (isAdded) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@end

