//
//  PostHeaderView.m
//  Instagram
//
//  Created by Felianne Teng on 7/7/21.
//

#import "PostHeaderView.h"

@implementation PostHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timestampLabel.textColor = [UIColor darkGrayColor];
    self.timestampLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timestampLabel];
    
    // Add constraints to the timestamp label
    self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    // Places timestamp in right side of header
    NSLayoutConstraint *timestampTrailingConstraint = [NSLayoutConstraint
      constraintWithItem:self.timestampLabel attribute:NSLayoutAttributeTrailing
      relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
      NSLayoutAttributeTrailing multiplier:1.0 constant:-10];
    // Centers timestamp vertically in header
    NSLayoutConstraint *timestampVerticalConstraint = [NSLayoutConstraint
      constraintWithItem:self.timestampLabel attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
      NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.contentView addConstraints:@[timestampTrailingConstraint,
       timestampVerticalConstraint]];
    
}

@end
