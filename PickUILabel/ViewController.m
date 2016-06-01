//
//  ViewController.m
//  PickUILabel
//
//  Created by YiChe on 16/5/30.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "ViewController.h"
#import "PickerLabelView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet PickerLabelView *pickView;
@property (nonatomic, weak) IBOutlet UISwitch *switchView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickView.textColor = [UIColor orangeColor];    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClick:(id)sender {
    if (self.switchView.on) {
        self.pickView.animationType = AnimationOneByOne;
    }else{
        self.pickView.animationType = AnimationAll;
    }
    self.pickView.value = [self.textField.text integerValue];
    [self.pickView startAnimation];
}

- (IBAction)stopClick:(id)sender {
    [self.pickView stopAnimation];
}

- (IBAction)pauseClick:(id)sender {
    [self.pickView pauseAnimation];
}

- (IBAction)clearClick:(id)sender {
    [self.pickView clearNum];
}

- (IBAction)switchClicl:(UISwitch *)sender {
    if (sender.on) {
        self.pickView.animationType = AnimationOneByOne;
    }else{
        self.pickView.animationType = AnimationAll;
    }
}

@end
