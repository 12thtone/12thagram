//
//  CircleSpinnerView.h
//  Blocstagram
//
//  Created by Matt Maher on 12/14/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleSpinnerView : UIView

@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *strokeColor;

@end