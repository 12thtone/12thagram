//
//  CropImageViewController.h
//  Blocstagram
//
//  Created by Matt Maher on 12/29/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaFullScreenViewController.h"

@class CropImageViewController;

@protocol CropImageViewControllerDelegate <NSObject>

- (void) cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end

@interface CropImageViewController : MediaFullScreenViewController

- (instancetype) initWithImage:(UIImage *)sourceImage;

@property (nonatomic, weak) NSObject <CropImageViewControllerDelegate> *delegate;

@end
