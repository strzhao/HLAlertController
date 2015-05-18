//
//  ViewController.m
//  HLAlertController
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import "ViewController.h"
#import "HLAlertController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger idx = 0; idx < 2; ++idx) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = idx + 1;
        [btn addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:idx ? @"alert" : @"actionSheet" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            idx ? make.left.equalTo(self.view.left).offset(50) : make.right.equalTo(self.view.right).offset(-50);
        }];
    }
}

- (void)showAlertView:(UIButton *)sender {
    HLAlertControllerStyle style = sender.tag == 1 ? HLAlertControllerStyleAlert : HLAlertControllerStyleActionSheet;
    HLAlertController *alert = [HLAlertController alertControllerWithTitle:@"标题" message:@"副标题 允许换行, 允许换行, 允许换行, 允许换行, 允许换行, 允许换行, 允许换行, 允许换行" preferredStyle:style];
    
    [alert addAction:[HLAlertAction actionWithTitle:@"取消" style:HLAlertActionStyleCancel handler:^(HLAlertAction *action) {
        NSLog(@"button one");
    }]];
    [alert addAction:[HLAlertAction actionWithTitle:@"正常" style:HLAlertActionStyleDefault handler:^(HLAlertAction *action) {
        NSLog(@"button two");
    }]];
    [alert addAction:[HLAlertAction actionWithTitle:@"警告" style:HLAlertActionStyleDestructive handler:^(HLAlertAction *action) {
        NSLog(@"button three");
    }]];
    if (sender.tag == 1) {
        [alert addTextFieldWithConfigure:^(UITextField *textField) {
            textField.placeholder = @"输入账号";
        }];
        [alert addTextFieldWithConfigure:^(UITextField *textField) {
            textField.placeholder = @"输入密码";
        }];
    }
    
    [alert showWithViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


@end
