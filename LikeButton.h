//
//  LikeButton.h
//  Blocstagram
//
//  Created by Matt Maher on 12/14/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LikeState) {
    LikeStateNotLiked             = 0,
    LikeStateLiking               = 1,
    LikeStateLiked                = 2,
    LikeStateUnliking             = 3
};

@interface LikeButton : UIButton

/**
 The current state of the like button. Setting to BLCLikeButtonNotLiked or BLCLikeButtonLiked will display an empty heart or a heart, respectively. Setting to BLCLikeButtonLiking or BLCLikeButtonUnliking will display an activity indicator and disable button taps until the button is set to BLCLikeButtonNotLiked or BLCLikeButtonLiked.
 */

@property (nonatomic, assign) LikeState likeButtonState;

@end
