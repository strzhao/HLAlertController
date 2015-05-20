//
//  HLAlertController.m
//  JGActionSheet Tests
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 Jonas Gessner. All rights reserved.
//

#import "HLAlertController.h"
#import "HLAlertTransitionController.h"

static const CGFloat kHLAlertControllerWidthFactor = 0.853f;

@interface HLAlertController ()
@property (nonatomic, readwrite) NSString *titleAlert;
@property (nonatomic, readwrite) NSString *message;
@property (nonatomic, readwrite) HLAlertControllerStyle preferredStyle;

@property (strong, nonatomic) NSMutableArray *actionArray;
@property (strong, nonatomic) NSMutableArray *textFieldArray;
@property (strong, nonatomic) UIView *vBack;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbMessage;
@end

@implementation HLAlertController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutSideCard:)]];
    self.view.backgroundColor = [UIColor clearColor];
    
    _vBack = [UIView new];
    _vBack.backgroundColor = [UIColor colorWithWhite:0.975 alpha:1];
    if (self.preferredStyle == HLAlertControllerStyleAlert) {
        _vBack.layer.masksToBounds = YES;
        _vBack.layer.cornerRadius = 5;
    }
    [self.view addSubview:_vBack];
    

    UIInterpolatingMotionEffect *effectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectHorizontal.minimumRelativeValue = @(-40);
    effectHorizontal.maximumRelativeValue = @(40);
    [_vBack addMotionEffect:effectHorizontal];
    
    UIInterpolatingMotionEffect *effectVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectVertical.minimumRelativeValue = @(-40);
    effectVertical.maximumRelativeValue = @(40);
    [_vBack addMotionEffect:effectVertical];
    
    CGFloat factor = self.preferredStyle == HLAlertControllerStyleAlert ? kHLAlertControllerWidthFactor : 1;
    [_vBack makeConstraints:^(MASConstraintMaker *make) {
        self.preferredStyle == HLAlertControllerStyleAlert ?  make.centerY.equalTo(self.view) : make.bottom.equalTo(self.view.bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.width).multipliedBy(factor);
    }];
    
    if (_titleAlert && ![_titleAlert isEqualToString:@""]) {
        _lbTitle = [UILabel new];
        _lbTitle.text = _titleAlert;
        _lbTitle.font = [UIFont systemFontOfSize:16];
        _lbTitle.textColor = [UIColor blackColor];
        _lbTitle.numberOfLines = 0;
        [_vBack addSubview:_lbTitle];

        [_lbTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.width.lessThanOrEqualTo(_vBack.width).offset(-60);
            make.centerX.equalTo(_vBack);
        }];
    }
    if (_message && ![_message isEqualToString:@""]) {
        _lbMessage = [UILabel new];
        _lbMessage.text = _message;
        _lbMessage.font = [UIFont systemFontOfSize:14];
        _lbMessage.textColor = [UIColor darkTextColor];
        _lbMessage.numberOfLines = 0;
        _lbMessage.textAlignment = NSTextAlignmentCenter;
        [_vBack addSubview:_lbMessage];

        [_lbMessage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vBack.left).offset(25);
            make.right.equalTo(_vBack.right).offset(-25);
            _lbTitle ? make.top.equalTo(_lbTitle.bottom).offset(10) : make.top.equalTo(_vBack.top).offset(10);
        }];
    }
    
    __block UIView *vLast;
    MASViewAttribute *previousAttribute = _vBack.top;
    CGFloat topOffset = 0;
    if (_lbTitle) {
        previousAttribute = _lbTitle.bottom;
        topOffset = 25;
    }
    if (_lbMessage) {
        previousAttribute = _lbMessage.bottom;
        topOffset = 25;
    }
    [_textFieldArray enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
        [_vBack addSubview:obj];
        
        [obj makeConstraints:^(MASConstraintMaker *make) {
            vLast ? make.top.equalTo(vLast.bottom) : make.top.equalTo(previousAttribute).offset(topOffset);
            make.height.equalTo(50);
            make.left.equalTo(_vBack.left).offset(16);
            make.right.equalTo(_vBack.right).offset(-16);
        }];
        vLast = obj;
    }];
    if (vLast) {
        previousAttribute = vLast.bottom;
        topOffset = 0;
    }
    
    [_actionArray enumerateObjectsUsingBlock:^(HLAlertAction *action, NSUInteger idx, BOOL *stop) {
        [_vBack addSubview:action];
        
        [action makeConstraints:^(MASConstraintMaker *make) {
            vLast ? make.top.equalTo(vLast.bottom) : make.top.equalTo(previousAttribute).offset(topOffset);
            make.height.equalTo(action.style == HLAlertActionStyleCancel ? 54 : 50);
            make.width.equalTo(_vBack);
            make.centerX.equalTo(_vBack);
        }];
        vLast = action;
    }];
    [vLast makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_vBack.bottom);
    }];
}

- (void)tapOutSideCard:(UITapGestureRecognizer *)tap {
    if (!CGRectContainsPoint(_vBack.frame, [tap locationInView:self.view])) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [_textFieldArray enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
            [obj resignFirstResponder];
        }];
    }
}


#pragma mark - public

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HLAlertControllerStyle)preferredStyle {
    
    HLAlertController *alertController = [HLAlertController new];
    alertController.actionArray = [NSMutableArray array];
    alertController.textFieldArray = [NSMutableArray array];
    alertController.titleAlert = title;
    alertController.message = message;
    alertController.preferredStyle = preferredStyle;

    return alertController;
}

- (void)showWithViewController:(UIViewController *)viewController {
    
    [HLAlertControllerTransitionManager presentAlertViewController:self presentViewController:viewController style:self.preferredStyle];
}

- (void)addAction:(HLAlertAction *)action {
    
    NSAssert(!(((HLAlertAction *)_actionArray.lastObject).style == HLAlertActionStyleCancel && action.style == HLAlertActionStyleCancel), @"cancel action must be one");
    
    if (_actionArray.count == 0 || action.style == HLAlertActionStyleCancel) {
        [_actionArray addObject:action];
    }
    else {
        [_actionArray insertObject:action atIndex:_actionArray.count - 1];
    }
    __weak typeof(self) weakSelf = self;
    [action setValue:^() {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } forKey:@"blockBtn"];
}

- (NSArray *)actions {
    return self.actionArray;
}

- (void)addTextFieldWithConfigure:(void (^)(UITextField *))configure {
    
    NSAssert(self.preferredStyle == HLAlertControllerStyleAlert, @"text field must only add to alert style");
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [UIColor darkTextColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    if (configure) {
        configure(textField);
    }
    [_textFieldArray addObject:textField];
}

- (NSArray *)textFields {
    return self.textFieldArray;
}

@end


@interface HLAlertAction ()
@property (strong, nonatomic) void (^blockBtn)();
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) HLAlertActionStyle style;
@property (strong, nonatomic) void (^handler)(HLAlertAction *);

@end
@implementation HLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(HLAlertActionStyle)style handler:(void (^)(HLAlertAction *))handler {
    HLAlertAction *vAlert = [HLAlertAction new];
    vAlert.style = style;
    vAlert.handler = [handler copy];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:vAlert action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[self colorForStyle:style] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [vAlert addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vAlert);
    }];
    
    UIView *vline = [UIView new];
    vline.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [vAlert addSubview:vline];
    
    CGFloat height = style == HLAlertActionStyleCancel ? 4 : .5;
    [vline makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vAlert.left);
        make.right.equalTo(vAlert.right);
        make.top.equalTo(vAlert.top);
        make.height.equalTo(height);
    }];
    
    return vAlert;
}

- (void)btnAction:(UIButton *)sender {
    if (_blockBtn) {
        _blockBtn();
    }
    if (_handler) {
        _handler(self);
    }
}

+ (UIColor *)colorForStyle:(HLAlertActionStyle)style {
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



@interface HLAlertControllerTransitionManager ()
@property (strong, nonatomic) HLAlertTransitionController *transition;
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

+(void)presentAlertViewController:(UIViewController *)alertViewController presentViewController:(UIViewController *)viewController style:(HLAlertControllerStyle)style {

    HLAlertControllerTransitionManager *manager = [self sharedAlertcontrollerTransitionManager];
    manager.transition = [[HLAlertTransitionController alloc] initWithPresentingViewController:viewController];
    [manager.transition presentViewController:alertViewController style:style];
}

@end
