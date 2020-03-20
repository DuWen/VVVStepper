//
//  VVVStepper.m
//  VVVStepper
//
//  Created by duwen on 2020/3/20.
//  Copyright © 2020 peter. All rights reserved.
//

#import "VVVStepper.h"

static const NSInteger kMinValue = 1;
static const NSInteger kMaxValue = 999;
static const NSInteger kStepSize = 1;

@interface VVVStepper()<UITextFieldDelegate>

/* Decrease Button */
@property (nonatomic, strong) UIButton *decreaseButton;

/* Edit TextField */
@property (nonatomic, strong) UITextField *editTextField;

/* Increase Button */
@property (nonatomic, strong) UIButton *increaseButton;

@end

@implementation VVVStepper

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews{
    [self addSubview:self.decreaseButton];
    [self addSubview:self.editTextField];
    [self addSubview:self.increaseButton];
    
    _minValue = kMinValue;
    _maxValue = kMaxValue;
    _stepSize = kStepSize;
}


#pragma mark - UpdateViews

- (void)updateViewByOpType:(VVVStepperOpType)opType{
    self.decreaseButton.enabled = YES;
    self.increaseButton.enabled = YES;
    if (_currentValue <= _minValue) {
        // Less than minValue
        self.decreaseButton.enabled = NO;
    }
    
    if (_currentValue >= _maxValue) {
        // more than maxValue
        self.increaseButton.enabled = NO;
    }
    
    self.editTextField.text = [NSString stringWithFormat:@"%ld",_currentValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stepper:changedValue:opType:)]) {
        [self.delegate stepper:self changedValue:_currentValue opType:opType];
    }
}


#pragma mark - Action

- (void)decrease:(UIButton *)sender{
    NSInteger tempValue = _currentValue - _stepSize;
    if (tempValue >= _minValue) {
        _currentValue = tempValue;
    }
    [self updateViewByOpType:VVVStepperOpType_Decrease];
}

- (void)increase:(UIButton *)sender{
    NSInteger tempValue = _currentValue + _stepSize;
    if (tempValue <= _maxValue) {
        _currentValue = tempValue;
    }
    [self updateViewByOpType:VVVStepperOpType_Increase];
}

- (void)done:(UIBarButtonItem *)sender{
    [_editTextField endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // only allow 0~9
    NSCharacterSet *characterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        [self stepperByWarning:VVVStepperWarning_Illegal];
        return NO;
    }
    
    // First input not allow 0
    if (range.location == 0 &&
        range.length == 0 &&
        [string isEqualToString:@"0"]) {
        [self stepperByWarning:VVVStepperWarning_Zero];
        return NO;
    }
    
    // Less than or Equal to MaxValue
    NSMutableString *old = [NSMutableString stringWithString:textField.text];
    [old insertString:string atIndex:range.location];
    if ([old integerValue] > _maxValue) {
        [self stepperByWarning:VVVStepperWarning_Overflow];
        return NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tempValue = [textField.text integerValue];
    if (tempValue >= _minValue) {
        _currentValue = tempValue;
    }
    [self updateViewByOpType:VVVStepperOpType_Edit];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)stepperByWarning:(VVVStepperWarning)warning{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stepper:warning:)]) {
        [self.delegate stepper:self warning:warning];
    }
}

#pragma mark - Set

- (void)setEnableEdited:(BOOL)enableEdited{
    _enableEdited = enableEdited;
    self.editTextField.enabled = (_stepSize != 1 ? NO : _enableEdited);
}

- (void)setCurrentValue:(NSInteger)currentValue{
    _currentValue = currentValue;
    self.editTextField.text = [NSString stringWithFormat:@"%ld",_currentValue];
}

- (void)setStepSize:(NSInteger)stepSize{
    _stepSize = stepSize;
    if (_stepSize != 1) {
        self.enableEdited = NO;
    }
}

- (void)setMinValue:(NSInteger)minValue{
    _minValue = minValue;
}

- (void)setMaxValue:(NSInteger)maxValue{
    _maxValue = maxValue;
}

- (void)setDecreaseStyle:(VVVStepperButtonStyle *)decreaseStyle{
    _decreaseStyle = decreaseStyle;
}

- (void)setTextFieldStyle:(VVVStepperTextFieldStyle *)textFieldStyle{
    _textFieldStyle = textFieldStyle;
}

- (void)setIncreaseStyle:(VVVStepperButtonStyle *)increaseStyle{
    _increaseStyle = increaseStyle;
}


#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    CGFloat width = floorf(size.width / 3.0);
    
    self.decreaseButton.frame = CGRectMake(0, 0, width, size.height);
    self.editTextField.frame = CGRectMake(width, 0, width, size.height);
    self.increaseButton.frame = CGRectMake(2 * width, 0, size.width - 2 * width, size.height);
}

#pragma mark - LazyLoad

- (UIButton *)decreaseButton{
    if (!_decreaseButton) {
        _decreaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_decreaseButton setTitle:@"-" forState:UIControlStateNormal];
        [_decreaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_decreaseButton addTarget:self action:@selector(decrease:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseButton;
}

- (UITextField *)editTextField{
    if (!_editTextField) {
        _editTextField = [[UITextField alloc] init];
        _editTextField.font = [UIFont systemFontOfSize:15.f];
        _editTextField.textColor = [UIColor blackColor];
        _editTextField.tintColor = [UIColor blackColor];
        _editTextField.backgroundColor = [UIColor clearColor];
        _editTextField.textAlignment = NSTextAlignmentCenter;
        _editTextField.keyboardType = UIKeyboardTypeNumberPad;
        _editTextField.clearButtonMode = UITextFieldViewModeNever;
        _editTextField.returnKeyType = UIReturnKeyDefault;
        _editTextField.delegate = self;
        
        UIToolbar *numberToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)]];
        [numberToolbar sizeToFit];
        _editTextField.inputAccessoryView = numberToolbar;
    }
    return _editTextField;
}

- (UIButton *)increaseButton{
    if (!_increaseButton) {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_increaseButton setTitle:@"+" forState:UIControlStateNormal];
        [_increaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_increaseButton addTarget:self action:@selector(increase:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseButton;
}


@end
