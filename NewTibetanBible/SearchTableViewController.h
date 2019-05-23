//
//  SearchTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/1/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchViewControllerDelegate <NSObject>
- (void)scrollToSearch:(NSString *)verseId;
@end

#import "BookModel.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SearchTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *searchResult;
@property (strong, nonatomic) NSMutableDictionary *dataForDisplay;
@property (nonatomic, weak) id <SearchViewControllerDelegate> delegate;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *listBookObject;
@property (strong, nonatomic) NSMutableArray *listBookName;

@end
