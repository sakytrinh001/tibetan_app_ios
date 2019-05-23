//
//  HistoryTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/19/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupButtonTableViewCell.h"
#import "FPPopoverController.h"
#import "SortTableViewController.h"

@protocol HistoryTableViewControllerDelegate <NSObject>
- (void)scrollToHistory:(NSString *)verseId;
@end
@interface HistoryTableViewController : UITableViewController<SortTableViewDelegate>
@property (weak, nonatomic) id <HistoryTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *listHistory;
@property (strong, nonatomic) NSArray *listBookName;
@end
