//
//  ViewController.m
//  VVVStepper
//
//  Created by Duwen on 2020/3/20.
//  Copyright © 2020 duwen. All rights reserved.
//

#import "ViewController.h"
#import "VVVStepper.h"

@interface ViewController ()<VVVStepperDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VVVStepper *stepper = [[VVVStepper alloc] initWithFrame:CGRectZero];
    [self.view addSubview:stepper];
    [stepper setFrame:CGRectMake(100, 300, 240, 80)];
    stepper.currentValue = 3;
    stepper.minValue = 3;
    stepper.maxValue = 10;
    stepper.delegate = self;
}

#pragma mark - VVVStepperDelegate

- (void)stepper:(VVVStepper *)stepper changedValue:(NSInteger)changedValue opType:(VVVStepperOpType)opType{
    NSLog(@"changedValue:  %ld",changedValue);
}

- (void)stepper:(VVVStepper *)stepper warning:(VVVStepperWarning)warning{
    NSLog(@"waring  :%lu",(unsigned long)warning);
}

@end
