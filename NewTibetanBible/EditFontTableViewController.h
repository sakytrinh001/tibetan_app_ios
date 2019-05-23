//
//  EditFontTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/29/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@protocol EditFontTableViewControllerDelegate
- (void)editFont:(NSString *)fontName;
@end

@interface EditFontTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *listFontName;
@property (strong, nonatomic) NSIndexPath *currentRowChecked;
@property (strong, nonatomic) NSString *currentFontName;
@property (weak, nonatomic) id <EditFontTableViewControllerDelegate> delegate;
@end
