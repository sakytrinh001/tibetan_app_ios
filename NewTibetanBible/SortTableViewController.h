//
//  SortTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/28/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortTableViewDelegate <NSObject>
@required
- (void)sorted: (NSInteger )row;
@end

@interface SortTableViewController : UITableViewController
@property (strong, nonatomic) NSIndexPath *checkedIndexPath;
@property (weak, nonatomic) id<SortTableViewDelegate> delegate;
@end
