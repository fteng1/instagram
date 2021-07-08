//
//  PostHeaderView.h
//  Instagram
//
//  Created by Felianne Teng on 7/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UIImageView *profileImage;
@property (assign, nonatomic) NSInteger section;
@end

NS_ASSUME_NONNULL_END
