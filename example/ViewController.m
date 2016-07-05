//
//  ViewController.m
//  HLAlertController
//
//  Created by String on 15/5/18.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import "ViewController.h"
#import "HLAlertController.h"
#import "UIView+HLExtension.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger idx = 0; idx < 2; ++idx) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        btn.tag = idx + 1;
        [btn addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:idx ? @"sheet" : @"alert" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        btn.HL_centerY = self.view.HL_centerY;
        if (idx) {
            btn.HL_left = 50;
        }
        else {
            btn.HL_right = self.view.HL_right - 50;
        }
    }
}

- (void)showAlertView:(UIButton *)sender {
    HLAlertControllerStyle style = sender.tag == 1 ? HLAlertControllerStyleAlert : HLAlertControllerStyleActionSheet;
    HLAlertController *alert = [HLAlertController alertControllerWithTitle:@"Discussion" message:@"The bottomLayoutGuide property comes into play when a view controller is frontmost onscreen." preferredStyle:style];
    [alert addAction:[HLAlertAction actionWithTitle:@"delete" style:HLAlertActionStyleDestructive handler:^(HLAlertAction *action) {
        NSLog(@"delete");
    }]];
    [alert addAction:[HLAlertAction actionWithTitle:@"cancel" style:HLAlertActionStyleCancel handler:^(HLAlertAction *action) {
        NSLog(@"cancel");
    }]];
    [alert addAction:[HLAlertAction actionWithTitle:@"confirm" style:HLAlertActionStyleDefault handler:^(HLAlertAction *action) {
        NSLog(@"confirm");
    }]];
    if (sender.tag == 1) {
        [alert addTextFieldWithConfigure:^(UITextField *textField) {
            textField.placeholder = @"input";
        }];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end
