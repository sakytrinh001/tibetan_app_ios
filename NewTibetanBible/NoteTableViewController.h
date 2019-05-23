//
//  NoteTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/18/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupButtonTableViewCell.h"
#import "FPPopoverController.h"
#import "SortTableViewController.h"
#import "EditNoteContentViewController.h"

@interface NoteTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *listNotes;
@property (strong, nonatomic) NSArray *listBookName;
@property (strong, nonatomic) id viewController;
@end
