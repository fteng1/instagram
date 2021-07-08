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
    
    if (self.profileImage != nil) {
        // Format and add constraints to profile image view
        [self.contentView addSubview:self.profileImage];
        self.profileImage.backgroundColor = [UIColor darkGrayColor];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *profileImageHeight = [NSLayoutConstraint
          constraintWithItem:self.profileImage attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationEqual toItem:nil attribute:
          NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        NSLayoutConstraint *profileImageWidth = [NSLayoutConstraint
          constraintWithItem:self.profileImage attribute:NSLayoutAttributeWidth
          relatedBy:NSLayoutRelationEqual toItem:nil attribute:
          NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        NSLayoutConstraint *profileImageLeadingConstraint = [NSLayoutConstraint
          constraintWithItem:self.profileImage attribute:NSLayoutAttributeLeading
          relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
          NSLayoutAttributeLeading multiplier:1.0 constant:8];
        NSLayoutConstraint *profileImageVerticalConstraint = [NSLayoutConstraint
          constraintWithItem:self.profileImage attribute:NSLayoutAttributeCenterY
          relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
          NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.contentView addConstraints:@[profileImageWidth, profileImageHeight, profileImageLeadingConstraint, profileImageVerticalConstraint]];
    }
    
    if (self.usernameLabel != nil) {
        // format username label
        self.usernameLabel.textColor = [UIColor darkGrayColor];
        self.usernameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.usernameLabel];
        
        // Add constraints to the username label
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        // Places username to right of profile image
        NSLayoutConstraint *usernameLeadingConstraint = [NSLayoutConstraint
          constraintWithItem:self.usernameLabel attribute:NSLayoutAttributeLeading
          relatedBy:NSLayoutRelationEqual toItem:self.profileImage attribute:
          NSLayoutAttributeTrailing multiplier:1.0 constant:8];
        // Centers username vertically in header
        NSLayoutConstraint *usernameVerticalConstraint = [NSLayoutConstraint
          constraintWithItem:self.usernameLabel attribute:NSLayoutAttributeCenterY
          relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
          NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.contentView addConstraints:@[usernameVerticalConstraint, usernameLeadingConstraint]];
    }
    
    // format timestamp label
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
    [self.contentView addConstraints:@[timestampTrailingConstraint, timestampVerticalConstraint]];
}

@end
