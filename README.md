# HLAlertController
alert to replace system alert.

easy to use

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
    
    [alert showWithViewController:self];
    
![alt text](https://github.com/JustString/HLAlertController/blob/master/snap1.PNG, "alert")

![alt text](https://github.com/JustString/HLAlertController/blob/master/snap2.PNG, "actionSheet")
