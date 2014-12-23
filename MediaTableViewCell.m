//
//  MediaTableViewCell.m
//  Blocstagram
//
//  Created by Matt Maher on 11/25/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "Media.h"
#import "Comment.h"
#import "User.h"
#import "DataSource.h"
#import "LikeButton.h"

@interface MediaTableViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *totalLikesLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *twoFingerTapGestureRecognizer;

@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;

@property (nonatomic, strong) LikeButton *likeButton;

@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation MediaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mediaImageView = [[UIImageView alloc] init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.twoFingerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTapFired:)];
        self.twoFingerTapGestureRecognizer.delegate = self;
        self.twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:self.twoFingerTapGestureRecognizer];
        
        self.usernameAndCaptionLabel = [[UILabel alloc] init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.usernameAndCaptionLabel.backgroundColor = usernameLabelGray;
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = commentLabelGray;
        
        self.totalLikesLabel = [[UILabel alloc] init];
        self.totalLikesLabel.numberOfLines = 0;
        self.totalLikesLabel.backgroundColor = usernameLabelGray;
        self.totalLikesLabel.textAlignment = NSTextAlignmentRight;
        
        self.likeButton = [[LikeButton alloc] init];
        [self.likeButton addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.backgroundColor = usernameLabelGray;
        
        for (UIView *view in @[self.mediaImageView, self.usernameAndCaptionLabel, self.commentLabel, self.totalLikesLabel, self.likeButton]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
            
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _totalLikesLabel, _likeButton);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel][_totalLikesLabel(==80)][_likeButton(==38)]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel]"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
        
        self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:CGRectGetWidth(self.contentView.bounds)];
        
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:100];
        
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:100];
        
        [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint]];
    }
    
    return self;
}

+ (void)load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    commentLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1]; /*#58506d*/
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
}

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width {
    // Make a cell
    MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    layoutCell.mediaItem = mediaItem;
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.commentLabel.frame);
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and add 20 to the height for some vertical padding.
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize usernameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
    CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
    
    self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height + 20;
    self.commentLabelHeightConstraint.constant = commentLabelSize.height + 20;
    self.imageHeightConstraint.constant = CGRectGetWidth(self.contentView.bounds);
    
    // Hide the line between cells
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
    
    // Configure the view for the selected state
}

- (void) setMediaItem:(Media *)mediaItem {
    _mediaItem = mediaItem;
    //self.mediaImageView.image = _mediaItem.image;
    
    if (!_mediaItem.image) {
        self.mediaImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    } else {
        self.mediaImageView.image = _mediaItem.image;
    }
    
    self.usernameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
    
    self.commentLabel.attributedText = [self commentString];
    self.likeButton.likeButtonState = mediaItem.likeState;
    
    NSMutableString *likesStringUpdated = [NSMutableString stringWithFormat:@"%li", (long)self.mediaItem.likes];
    self.totalLikesLabel.text = likesStringUpdated;
}

#pragma mark - Liking

- (void) likePressed:(UIButton *)sender {
    [self.delegate cellDidPressLikeButton:self];
    
    NSMutableString *likesStringUpdated = [NSMutableString stringWithFormat:@"%li", (long)self.mediaItem.likes];
    self.totalLikesLabel.text = likesStringUpdated;
}


#pragma mark - Attributed

- (NSAttributedString *) usernameAndCaptionString {
    CGFloat usernameFontSize = 15;
    
    // Make a string that says "username caption text"
    NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
    
    // Make an attributed string, with the "username" bold
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
    
    return mutableUsernameAndCaptionString;
}

- (NSAttributedString *) commentString {
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    
    for (Comment *comment in self.mediaItem.comments) {
        // Make a string that says "username comment text" followed by a line break
        NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName, comment.text];
        
        // Make an attributed string, with the "username" bold
        
        NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
        [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
        [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
        
        [commentString appendAttributedString:oneCommentString];
    }
    
    return commentString;
}

#pragma mark - Gesture Methods

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

- (void) longPressFired:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.delegate cell:self didLongPressImageView:self.mediaImageView];
    }
}

- (void) twoFingerTapFired:(UITapGestureRecognizer *)sender {
    [[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}

@end

