//
//  FavoritesTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/25/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortTableViewController.h"
@protocol FavoritesTableViewControllerDelegate <NSObject>
- (void)scrollToFavorite:(NSString *)verseId;
@end
#import "ViewController.h"
@interface FavoritesTableViewController : UITableViewController <SortTableViewDelegate>
@property (nonatomic, weak) id <FavoritesTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *listFavorites;
@property (nonatomic, strong) NSArray *listBookName;
@end
