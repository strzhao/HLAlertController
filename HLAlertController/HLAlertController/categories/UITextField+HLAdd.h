//
//  UITextField+HLAdd.h
//  hoora
//
//  Created by String on 16/3/23.
//  Copyright © 2016年 Hoora.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HLAdd)

- (NSRange)HL_selectedRange;

- (void)HL_setSelectedRange:(NSRange)range;

@end
