//
//  Post.h
//  Instagram
//
//  Created by Felianne Teng on 7/6/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSString *username;

+ (void) postUserImage: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (Post *) initPost: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption;

@end
