//
//  HighLightTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/21/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupButtonTableViewCell.h"
#import "FPPopoverController.h"
#import "SortTableViewController.h"

@protocol HighLightTableViewControllerDelegate <NSObject>
    - (void)scrollToHighLight:(NSString *)verseId;
    - (void)removeHighLight:(NSString *)verseId;
@end
#import "ViewController.h"
@interface HighLightTableViewController : UITableViewController <SortTableViewDelegate>
    @property (nonatomic, weak) id <HighLightTableViewControllerDelegate> delegate;
    @property (nonatomic, strong) NSMutableDictionary *listHighLight;
    @property (nonatomic, strong) NSArray *listBookName;
@end
