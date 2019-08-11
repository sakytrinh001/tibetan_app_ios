//
//  EditFontSizeTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/26/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
extern NSString* const kExtraSmall;
extern NSString* const kSmall;
extern NSString* const kMedium;
extern NSString* const kLarge;
extern NSString* const kExtraLarge;
@protocol EditFontSizeTableViewControllerDelegate
- (void)editFontSize:(NSString *)fontSize;
@end

@interface EditFontSizeTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *listFontSize;
@property (strong, nonatomic) NSIndexPath *currentRowChecked;
@property (strong, nonatomic) NSString *currentFontSize;
@property (weak, nonatomic) id <EditFontSizeTableViewControllerDelegate> delegate;
@end
