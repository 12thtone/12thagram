//
//  ImagesCollectionViewCell.m
//  Blocstagram
//
//  Created by Matt Maher on 12/30/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import "ImagesCollectionViewCell.h"

@implementation ImagesCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.filterImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.filterImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.filterImageView];
    
    return self;
}

@end
