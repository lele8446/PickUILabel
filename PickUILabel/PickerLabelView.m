//
//  PickerLabel.m
//  PickUILabel
//
//  Created by YiChe on 16/5/30.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "PickerLabelView.h"

#define ViewAutoresizingFlexibleAll UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin

@interface PickerLabelView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray *pickList;
@property (nonatomic, strong) NSMutableDictionary *valueDic;
@property (nonatomic, assign) NSInteger digitNumber;//显示的数值有多少位，默认1

@property (nonatomic, assign) NSInteger times;//AnimationOneByOne动画时，累计执行动画次数
@property (nonatomic, strong) NSTimer *timer;//AnimationOneByOne动画时的定时器

@end


@implementation PickerLabelView
#pragma mark - life cycle
- (void)setValue:(NSUInteger)value {
    _value = value;
    [self reverseValue:value];
    [self.pickView reloadAllComponents];
}

- (void)setAnimationType:(PickerLabelAnimationType)animationType {
    [self clearNum];
    _animationType = animationType;
}

- (UIColor *)getTextColor {
    if (_textColor) {
        return _textColor;
    }else{
        self.textColor = [UIColor blackColor];
        return [UIColor blackColor];
    }
}

- (UIFont *)getTextFont {
    if (_textFont) {
        return _textFont;
    }else{
        self.textFont = [UIFont boldSystemFontOfSize:15];
        return [UIFont boldSystemFontOfSize:15];
    }
}

- (NSInteger )getComponentsNumber {
    if (_componentsNumber && _componentsNumber >= self.digitNumber) {
        return _componentsNumber;
    }else{
        _componentsNumber = self.digitNumber;
        return _componentsNumber;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

#pragma mark - public method
- (void)startAnimation {
    [self customTimer];
    [self.timer fire];
    [self.timer setFireDate:[NSDate date]];
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)pauseAnimation {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)clearNum {
    [self stopAnimation];
    self.value = 0;
    self.digitNumber = 1;
    self.times = 0;
    for (NSInteger i = 1; i <= self.componentsNumber; i++) {
        [self.pickView selectRow:0 inComponent:(self.componentsNumber-i) animated:YES];
    }
}

#pragma mark - privte method
- (void)commonInit {
    self.pickList = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    self.valueDic = [NSMutableDictionary dictionary];
    self.digitNumber = 1;
    self.times = 0;
    self.value = 0;
    self.value = 0;
    self.animationType = AnimationAll;
    
    self.pickView = [[UIPickerView alloc]initWithFrame:self.bounds];
    self.pickView.autoresizingMask = ViewAutoresizingFlexibleAll;
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    self.pickView.showsSelectionIndicator = YES;
    self.pickView.backgroundColor = [UIColor clearColor];
    self.pickView.userInteractionEnabled = NO;
    [self addSubview:self.pickView];
}

- (NSTimer *)customTimer {
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(increaseNum) userInfo:nil repeats:YES];
        self.timer = timer;
    }
    return self.timer;
}

- (void)increaseNum {
    if (self.animationType == AnimationOneByOne) {
        if (self.times > self.value) {
            [self stopAnimation];
            return;
        }
        //个位
        [self.pickView selectRow:self.times inComponent:self.componentsNumber-1 animated:YES];
        
        for (NSInteger i = self.componentsNumber; i > 1; i--) {
            NSInteger v = [self powlNum:i];
            if (self.times%v == 0 && (self.times/v !=0)) {
                NSDictionary *tempDic = self.valueDic[[NSString stringWithFormat:@"%@",@(i)]];
                NSInteger curTimes = [tempDic[@"curTimes"] integerValue];
                curTimes = curTimes + 1;
                [self.pickView selectRow:curTimes inComponent:(self.componentsNumber-i) animated:YES];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [dic setObject:@(curTimes) forKey:@"curTimes"];
                [self.valueDic setObject:dic forKey:[NSString stringWithFormat:@"%@",@(i)]];
            }
        }
        self.times ++;
    }else if (self.animationType == AnimationAll){
        BOOL stop = YES;
        for(NSString *compKey in self.valueDic) {
            if (![self.valueDic[compKey][@"stop"]boolValue]) {
                stop = NO;
            }
        }
        if (stop) {
            [self stopAnimation];
            return;
        }
        for (NSInteger i = 1; i <= self.digitNumber; i++) {
            NSString *key = [NSString stringWithFormat:@"%@",@(i)];
            NSDictionary *tempDic = self.valueDic[key];
            if ([tempDic[@"curTimes"] integerValue] < [tempDic[@"value"] integerValue]) {
                NSInteger curTimes = [tempDic[@"curTimes"] integerValue];
                curTimes = curTimes + 1;
                [self.pickView selectRow:curTimes inComponent:(self.componentsNumber-i) animated:YES];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [dic setObject:@(curTimes) forKey:@"curTimes"];
                [self.valueDic setObject:dic forKey:[NSString stringWithFormat:@"%@",@(i)]];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [dic setObject:@(YES) forKey:@"stop"];
                [self.valueDic setObject:dic forKey:[NSString stringWithFormat:@"%@",@(i)]];
            }
        }
    }
}

- (NSInteger)powlNum:(NSInteger)num {
    long double value =  powl(10, num-1);
    return value;
}

- (void)reverseValue:(NSUInteger)value {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSUInteger i = value; i > 0; i = i/10) {
        [tempDic setObject:[NSNumber numberWithInteger:i%10] forKey:[NSString stringWithFormat:@"%@",@(self.digitNumber)]];
        self.digitNumber ++;
    }
    if (value != 0) {
        self.digitNumber = self.digitNumber - 1;
    }
    
    
    NSString *key;
    NSEnumerator *enumerator = [tempDic keyEnumerator];
    while (key = [enumerator nextObject]) {
        NSDictionary *dic = @{@"key":key,
                              @"curTimes":@(0),//AnimationOneByOne 动画时，已跳动的次数
                              @"value":[tempDic objectForKey:key],//AnimationAll 动画时，需要跳动的次数
                              @"stop":@(NO),//AnimationAll 动画时，该位数的动画是否已停止
                              };
        [self.valueDic setObject:dic forKey:key];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.componentsNumber;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //数值设为足够大，以实现循环滚动效果
    return [self.pickList count]*10000;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    //4 是列与列之间的间距
    return (self.bounds.size.width-(self.componentsNumber-1)*4)/self.componentsNumber;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickList[row % self.pickList.count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.bounds.size.height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 2;
        pickerLabel.textColor = self.textColor;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:self.textFont];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
