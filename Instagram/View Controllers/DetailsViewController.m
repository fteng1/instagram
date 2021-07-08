//
//  DetailsViewController.m
//  Instagram
//
//  Created by Felianne Teng on 7/6/21.
//

#import "DetailsViewController.h"
#import <DateTools.h>
#import <Parse/Parse.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoView.image = [UIImage imageWithData:self.post.image.getData];
    self.captionLabel.text = self.post.caption;
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateSelected];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    
    // Format createdAt date string
    NSString *createdAtOriginalString = self.post.createdAt.description;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    // Put date in time ago format
    self.timestampLabel.text = date.shortTimeAgoSinceNow;
    
    // Set username and number of likes
    self.usernameLabel.text = self.post.username;
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    // set author profile picture
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.layer.masksToBounds = YES;
    PFUser *poster = self.post.author;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:poster.objectId];
    
    // get profile picture of each post's author
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
        if (user != nil) {
            self.profileImageView.image = [UIImage imageWithData:((PFFileObject *) ([((PFUser *) user[0]) valueForKey:@"profilePicture"])).getData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}

- (IBAction)onLikeTap:(id)sender {
    self.likeButton.selected = true;
    self.post.likeCount = [NSNumber numberWithInt:[self.post.likeCount intValue] + 1];
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    [self.post saveInBackground];
}

- (IBAction)onBackTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
