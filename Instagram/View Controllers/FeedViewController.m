//
//  FeedViewController.m
//  Instagram
//
//  Created by Felianne Teng on 7/6/21.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "ComposeViewController.h"
#import "InfiniteScrollActivityView.h"
#import <DateTools.h>
#import "PostHeaderView.h"

@interface FeedViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (strong, nonatomic) NSString *HeaderViewIdentifier;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.HeaderViewIdentifier = @"PostHeaderView";
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    [self fetchPosts];
    [self.feedTableView reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:self.refreshControl atIndex:0];

    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.feedTableView.contentSize.height, self.feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.feedTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.feedTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.feedTableView.contentInset = insets;
    
//    [self.feedTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PostCell"];
    [self.feedTableView registerClass:[PostHeaderView class] forHeaderFooterViewReuseIdentifier:self.HeaderViewIdentifier];
}

- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.feedTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)onLogoutTap:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User logged out successfully");
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (void)didPost:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self.feedTableView reloadData];
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
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.feedTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.feedTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.feedTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.feedTableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.feedTableView.contentSize.height, self.feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
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
        if (header.timestampLabel == nil) {
            header.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
        }
        if (header.usernameLabel == nil) {
            header.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
        }
        if (header.profileImage == nil) {
            header.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        }
        
        // set poster username
        header.usernameLabel.text = post.username;
        
        // Convert the createdAt property into a string
        NSString *createdAtOriginalString = post.createdAt.description;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Put date in time ago format and set label
        header.timestampLabel.text = date.shortTimeAgoSinceNow;
        
        // set poster profile picture
        PFUser *poster = post.author;
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"objectId" equalTo:poster.objectId];
        
        // get profile picture of each post's author
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
            if (user != nil) {
                header.profileImage.image = [UIImage imageWithData:((PFFileObject *) ([((PFUser *) user[0]) valueForKey:@"profilePicture"])).getData];
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];

    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Bring up details view if post is tapped
    if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.feedTableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    // Bring up compose view if compose button is pressed
    if ([[segue identifier] isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}


@end
