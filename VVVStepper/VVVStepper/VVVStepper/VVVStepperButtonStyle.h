//
//  VVVStepperButtonStyle.h
//  VVVStepper
//
//  Created by duwen on 2020/3/20.
//  Copyright © 2020 peter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVVStepperButtonStyle : NSObject

/* Normal Image */
@property (nonatomic, copy) NSString *normalImage;

/* Highlight Image */
@property (nonatomic, copy) NSString *highlightImage;

/* Disable Image */
@property (nonatomic, copy) NSString *disableImage;

/* Font Size */
@property (nonatomic, assign) float fontSize;

@end

NS_ASSUME_NONNULL_END
