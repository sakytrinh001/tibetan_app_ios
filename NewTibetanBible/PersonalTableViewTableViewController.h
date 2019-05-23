//
//  PersonalTableViewTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/7/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighLightTableViewController.h"
#import "NoteTableViewController.h"
#import "HistoryTableViewController.h"
@interface PersonalTableViewTableViewController : UITableViewController
    @property (strong, nonatomic) NSArray *elementArr;
    @property (strong, nonatomic) NSMutableDictionary *listHighLight;
    @property (strong, nonatomic) NSArray *listBookName;
    @property (strong, nonatomic) id viewController;
    @property (strong, nonatomic) NSMutableDictionary *listFavorite;
    @property (strong, nonatomic) NSMutableDictionary *listNote;
    @property (strong, nonatomic) NSMutableDictionary *listHistory;
- (IBAction)exit:(id)sender;
@end
