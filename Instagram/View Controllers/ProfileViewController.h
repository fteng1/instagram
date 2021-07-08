//
//  ProfileViewController.h
//  Instagram
//
//  Created by Felianne Teng on 7/7/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;
@property (assign, nonatomic) BOOL firstAccessedFromTab;

- (void)updateFields;
- (void)fetchPosts;

@end

NS_ASSUME_NONNULL_END
