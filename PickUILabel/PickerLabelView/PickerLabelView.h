//
//  PickerLabel.h
//  PickUILabel
//
//  Created by YiChe on 16/5/30.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画类型
 */
typedef enum : NSUInteger {
    AnimationOneByOne = 0,//从个位开始逐个累加动画
    AnimationAll,         //各位数数字同时递增动画
} PickerLabelAnimationType;

@interface PickerLabelView : UIView

/**
 *  default [UIColor blackColor]
 */
@property (nonatomic, strong, getter=getTextColor) UIColor *textColor;

/**
 *  default [UIFont boldSystemFontOfSize:15]
 */
@property (nonatomic, strong, getter=getTextFont) UIFont *textFont;

/**
 *  显示多少位数字，default：1
 *  赋值时需注意self.frame.size.width值，如果componentsNumber数值太大，而self.frame.size.width太小，可能会数值显示不完全
 */
@property (nonatomic, assign, getter=getComponentsNumber) NSInteger componentsNumber;

/**
 *  显示的数值
 */
@property (nonatomic, assign, setter=setValue:) NSUInteger value;

/**
 *  动画类型，default：AnimationAll
 */
@property (nonatomic, assign) PickerLabelAnimationType animationType;


/**
 *  开始动画
 */
- (void)startAnimation;
/**
 *  结束动画
 */
- (void)stopAnimation;
/**
 *  暂停动画
 */
- (void)pauseAnimation;
/**
 *  清除数字
 */
- (void)clearNum;

- (void)initializeStatus;
@end
