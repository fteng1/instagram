//
//  Post.m
//  Instagram
//
//  Created by Felianne Teng on 7/6/21.
//

//  Post.m
#import "Post.h"
@implementation Post
    
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (Post *) initPost: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption {
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    return newPost;
}

+ (void) postUserImage: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [post saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
