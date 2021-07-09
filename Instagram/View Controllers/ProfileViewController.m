//
//  ProfileViewController.m
//  Instagram
//
//  Created by Felianne Teng on 7/7/21.
//

#import "ProfileViewController.h"
#import "InfiniteScrollActivityView.h"
#import <Parse/Parse.h>
#import "PostHeaderView.h"
#import "PostCell.h"
#import "Post.h"
#import <DateTools.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (strong, nonatomic) NSString *HeaderViewIdentifier;

@end

@implementation ProfileViewController

// sets initial value for one of the properties
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.firstAccessedFromTab = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.HeaderViewIdentifier = @"PostHeaderView";
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    if (self.tabBarController.delegate == nil && self.firstAccessedFromTab) {
        self.tabBarController.delegate = self;
        self.user = [PFUser currentUser];

        [self fetchPosts];
        [self updateFields];
    }
    
    // change shape of profile picture to be a circle
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.userTableView insertSubview:self.refreshControl atIndex:0];

    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.userTableView.contentSize.height, self.userTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.userTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.userTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.userTableView.contentInset = insets;
    
    [self.userTableView registerClass:[PostHeaderView class] forHeaderFooterViewReuseIdentifier:self.HeaderViewIdentifier];
}

- (void)updateFields {
    // Set fields on page
    self.usernameLabel.text = self.user.username;
    self.postCountLabel.text = [NSString stringWithFormat:@"%@", [self.user valueForKey:@"numPosts"]];
    self.profileImageView.image = [UIImage imageWithData:((PFFileObject *)([self.user valueForKey:@"profilePicture"])).getData];
}

- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.userTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
    // update user information
    [self updateFields];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.section];
    cell.photoView.image = [UIImage imageWithData:post.image.getData];
    cell.captionLabel.text = post.caption;
    return cell;
}

// load more data once user scrolls to bottom of the page
-(void)loadMoreData{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    query.limit = [self.posts count] + 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // Update flag
            self.isMoreDataLoading = false;

            // Stop the loading indicator
            [self.loadingMoreView stopAnimating];

            // ... Use the new data to update the data source ...
            self.posts = posts;

            // Reload the tableView now that there is new data
            [self.userTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.userTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.userTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.userTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.userTableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.userTableView.contentSize.height, self.userTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}

- (IBAction)changeProfile:(id)sender {
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }

        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    editedImage = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    
    // Do something with the images (based on your use case)
    self.profileImageView.image = editedImage;
    [self.user setValue:[Post getPFFileFromImage:editedImage] forKey:@"profilePicture"];
    [self.user saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PostHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.HeaderViewIdentifier];
    if ([self.posts count] > 0) {
        // Set text labels for username and date posted
        Post *post = self.posts[section];
        if (header.timestampLabel == nil) {
            header.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
        }
        
        // Convert the createdAt property into a string
        NSString *createdAtOriginalString = post.createdAt.description;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Put date in time ago format and set label
        header.timestampLabel.text = date.shortTimeAgoSinceNow;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
        self.user = [PFUser currentUser];

        [self fetchPosts];
        [self updateFields];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

@end
