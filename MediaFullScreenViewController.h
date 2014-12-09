//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Matt Maher on 12/6/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype) initWithMedia:(Media *)media;

- (void) centerScrollView;

@end
