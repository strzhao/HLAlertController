//
//  HLKeyboardNotificationCenter.m
//  KeyboradNotificationCenterDemo
//
//  Created by String on 14-8-5.
//  Copyright (c) 2014年 alex. All rights reserved.
//

#import "HLKeyboardNotificationCenter.h"

@implementation HLKeyboardInfo

- (instancetype)initWithKeyboardDictionary:(NSDictionary *)keyboardDictionary{
    if (self = [super init]) {
        self.keyboardFrameBegin = [keyboardDictionary[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        self.keyboardFrameEnd = [keyboardDictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.keyboardAnimationDuration = [keyboardDictionary[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        self.keyboardAnimationCurve = [keyboardDictionary[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    return self;
}

@end


@implementation HLKeyboardBlocks

@end


@interface HLKeyboardNotificationCenter ()
@property (strong, nonatomic) NSMutableSet *observes;
@end

@implementation HLKeyboardNotificationCenter

+ (instancetype)sharedKeyboardNotificationCenter{
    static HLKeyboardNotificationCenter *keyboardNotificationCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardNotificationCenter = [[HLKeyboardNotificationCenter alloc] init];
    });
    return keyboardNotificationCenter;
}

- (instancetype)init{
    if (self = [super init]) {
        self.observes = [NSMutableSet set];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}


- (void)dealloc{
    
    self.observes = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)reset {
    
    [[HLKeyboardNotificationCenter sharedKeyboardNotificationCenter].observes removeAllObjects];
}

+ (void)keyboardWillAppear:(KeyboardWillAppearBlock)keyboardWillAppear willChangeFrame:(KeyboardWillChangeFrameBlock)keyboardWillChangeFrame willDisappear:(KeyboardWillDisappearBlock)keyboardWillDisappear key:(id)key{
    
    HLKeyboardBlocks *keyboardBlocks = [[HLKeyboardBlocks alloc] init];
    keyboardBlocks.keyboardWillAppearBlock = keyboardWillAppear;
    keyboardBlocks.keyboardWillChangeFrameBlock = keyboardWillChangeFrame;
    keyboardBlocks.keyboardWillDisappearBlock = keyboardWillDisappear;
    keyboardBlocks.key = key;
    
    [[HLKeyboardNotificationCenter sharedKeyboardNotificationCenter].observes addObject:keyboardBlocks];
}


+ (void)removeForKeyIfNeeded:(id)key {
    __block BOOL hasAdded = NO;
    [[HLKeyboardNotificationCenter sharedKeyboardNotificationCenter].observes enumerateObjectsUsingBlock:^(HLKeyboardBlocks *obj, BOOL *stop) {
        if ([obj.key isEqualToString:key]) {
            hasAdded = YES;
            *stop = YES;
        }
    }];
    if (hasAdded) {
        [HLKeyboardNotificationCenter removeForKey:key];
    }
}

+ (void)removeForKey:(id)key{
    
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (HLKeyboardBlocks *keyboardBlocks in [HLKeyboardNotificationCenter sharedKeyboardNotificationCenter].observes) {
        if ([keyboardBlocks.key isEqual:key]) {
            [deleteArray addObject:keyboardBlocks];
        }
    }
    for (HLKeyboardBlocks *keyboardBlock in deleteArray) {
        
        [[HLKeyboardNotificationCenter sharedKeyboardNotificationCenter].observes removeObject:keyboardBlock];
    }
}

#pragma mark - notification method

- (void)keyboardWillAppear:(NSNotification *)notification{
    for (HLKeyboardBlocks *keyboardBlocks in self.observes) {
        HLKeyboardInfo *keyboardInfo = [[HLKeyboardInfo alloc] initWithKeyboardDictionary:[notification userInfo]];
        if (keyboardBlocks.keyboardWillAppearBlock) {
            keyboardBlocks.keyboardWillAppearBlock(keyboardInfo);
        }
    }
}

- (void)keyboardWillDisappear:(NSNotification *)notification{
    for (HLKeyboardBlocks *keyboardBlocks in self.observes) {
        HLKeyboardInfo *keyboardInfo = [[HLKeyboardInfo alloc] initWithKeyboardDictionary:[notification userInfo]];
        if (keyboardBlocks.keyboardWillDisappearBlock) {
            keyboardBlocks.keyboardWillDisappearBlock(keyboardInfo);
        }
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    for (HLKeyboardBlocks *keyboardBlocks in self.observes) {
        HLKeyboardInfo *keyboardInfo = [[HLKeyboardInfo alloc] initWithKeyboardDictionary:[notification userInfo]];
        if (keyboardBlocks.keyboardWillChangeFrameBlock) {
            keyboardBlocks.keyboardWillChangeFrameBlock(keyboardInfo);
        }
    }
}

@end
