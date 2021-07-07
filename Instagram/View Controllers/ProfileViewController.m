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

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.HeaderViewIdentifier = @"PostHeaderView";
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self fetchPosts];
    [self.userTableView reloadData];
    
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

- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
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
}

//- (IBAction)onLogoutTap:(id)sender {
//    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
//        // PFUser.current() will now be nil
//        if (error != nil) {
//            NSLog(@"User log out failed: %@", error.localizedDescription);
//        }
//        else {
//            NSLog(@"User logged out successfully");
//            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
//
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            sceneDelegate.window.rootViewController = loginViewController;
//        }
//    }];
//}

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
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row + 1 == [self.posts count]){
//        [self loadMoreData];
//    }
//}

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PostHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.HeaderViewIdentifier];
    if ([self.posts count] > 0) {
        // Set text labels for username and date posted
        Post *post = self.posts[section];
        header.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
        
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

@end
