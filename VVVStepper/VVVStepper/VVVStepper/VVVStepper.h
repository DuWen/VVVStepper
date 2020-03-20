//
//  VVVStepper.h
//  VVVStepper
//
//  Created by duwen on 2020/3/20.
//  Copyright © 2020 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVVStepperButtonStyle.h"
#import "VVVStepperTextFieldStyle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VVVStepperDelegate;
typedef NS_ENUM(NSUInteger, VVVStepperOpType) {
    VVVStepperOpType_Increase,
    VVVStepperOpType_Edit,
    VVVStepperOpType_Decrease,
};

typedef NS_ENUM(NSUInteger, VVVStepperWarning) {
    // First input is 0
    VVVStepperWarning_Zero,
    // illegal char
    VVVStepperWarning_Illegal,
    // out of maxValue
    VVVStepperWarning_Overflow,
};

@interface VVVStepper : UIView

/* Enable Edited */
@property (nonatomic, assign) BOOL enableEdited;

/* Current Value */
@property (nonatomic, assign) NSInteger currentValue;

/* Step Size */
@property (nonatomic, assign) NSInteger stepSize;

/* Min Value */
@property (nonatomic, assign) NSInteger minValue;

/* Max Value */
@property (nonatomic, assign) NSInteger maxValue;

/* Decrease Style */
@property (nonatomic, strong) VVVStepperButtonStyle *decreaseStyle;

/* Edit TestField Style */
@property (nonatomic, strong) VVVStepperTextFieldStyle *textFieldStyle;

/* Increase Style */
@property (nonatomic, strong) VVVStepperButtonStyle *increaseStyle;

/* VVVStepperDelegate */
@property (nonatomic, weak, nullable) id<VVVStepperDelegate> delegate;

@end


@protocol VVVStepperDelegate <NSObject>

@required

/// Description
/// @param stepper VVVStepper
/// @param changedValue changedValue
/// @param opType VVVStepperOpType
- (void)stepper:(VVVStepper *)stepper changedValue:(NSInteger)changedValue opType:(VVVStepperOpType)opType;

@optional

/// Description
/// @param stepper VVVStepper
/// @param warning VVVStepperWarning
- (void)stepper:(VVVStepper *)stepper warning:(VVVStepperWarning)warning;

@end
NS_ASSUME_NONNULL_END
