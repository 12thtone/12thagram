//
//  MediaTableViewCell.h
//  Blocstagram
//
//  Created by Matt Maher on 11/25/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) Media *mediaItem;
+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;

@end
