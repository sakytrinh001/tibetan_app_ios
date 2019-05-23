//
//  ChapterPickerTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/27/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@protocol ChapterPickerDelegate <NSObject>
@required
- (void)selectChapter: (NSIndexPath *)indexPath;
- (void)exitChapterPicking;
@end

@interface ChapterPickerTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *listChapterName;
@property (strong, nonatomic) NSMutableArray *listBookNameFull;
@property (strong, nonatomic) NSIndexPath *selectedRow;


@property (weak, nonatomic) id<ChapterPickerDelegate> delegate;
- (id)initWithStyle:(UITableViewStyle)style listBookName:(NSMutableArray *)bookNameArr listChapter:(NSMutableArray *)chapterName;

@end
