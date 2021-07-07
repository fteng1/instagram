//
//  DetailsViewController.m
//  Instagram
//
//  Created by Felianne Teng on 7/6/21.
//

#import "DetailsViewController.h"
#import <DateTools.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoView.image = [UIImage imageWithData:self.post.image.getData];
    self.captionLabel.text = self.post.caption;
    
    // Format createdAt date string
    NSString *createdAtOriginalString = self.post.createdAt.description;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    // Put date in time ago format
    self.timestampLabel.text = date.shortTimeAgoSinceNow;
    
    self.usernameLabel.text = self.post.username;
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
