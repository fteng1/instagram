//
//  InfiniteScrollActivityView.h
//  Instagram
//
//  Created by Felianne Teng on 7/7/21.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end
