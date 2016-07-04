//
//  HLKeyboardNotificationCenter.h
//  KeyboradNotificationCenterDemo
//
//  Created by String on 14-8-5.
//  Copyright (c) 2014年 alex. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    保存keyboard的信息的类
 p:
    keyboard开始的frame
    keyboard结束时的frame
    动画时间
    动画曲线
 */

@interface HLKeyboardInfo : NSObject
@property (assign, nonatomic) CGRect keyboardFrameBegin;
@property (assign, nonatomic) CGRect keyboardFrameEnd;
@property (assign, nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (assign, nonatomic) UIViewAnimationCurve keyboardAnimationCurve;

- (instancetype)initWithKeyboardDictionary:(NSDictionary *)keyboardDictionary;
@end



typedef void(^KeyboardWillAppearBlock)(HLKeyboardInfo *keyboardInfo);
typedef void(^KeyboardWillDisappearBlock)(HLKeyboardInfo *keyboardInfo);
typedef void(^KeyboardWillChangeFrameBlock)(HLKeyboardInfo *keyboardInfo);

/*
    一个小的操作单元 可能有许多对象都监听键盘事件 把这边要处理的动作封装成不同的block 然后
    不同的block组成一个操作单元 放到操作池中                       (为了释放的方便)
 p:
    key: 用来区别每一个操作单元的键 释放的时候用
 */

@interface HLKeyboardBlocks : NSObject
@property (copy, nonatomic) id key;
@property (strong, nonatomic) KeyboardWillAppearBlock keyboardWillAppearBlock;
@property (strong, nonatomic) KeyboardWillDisappearBlock keyboardWillDisappearBlock;
@property (strong, nonatomic) KeyboardWillChangeFrameBlock keyboardWillChangeFrameBlock;
@end



/*
    通知中心 把要监听键盘的对象的动作封装进来 放到操作池中
 */
@interface HLKeyboardNotificationCenter : NSObject

+ (void)keyboardWillAppear:(KeyboardWillAppearBlock)keyboardWillAppear
           willChangeFrame:(KeyboardWillChangeFrameBlock)keyboardWillChangeFrame
     willDisappear:(KeyboardWillDisappearBlock)keyboardWillDisappear
               key:(id)key;

+ (void)removeForKey:(id)key;
+ (void)reset;

@end
