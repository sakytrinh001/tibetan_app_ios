//
//  CrossIconTableViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/30/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@protocol CrossIconDelegate <NSObject>
@required
- (void)selectCrossItem: (NSInteger )row;
- (void)exitCrossSettingView;
@end

@interface CrossIconTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *itemArray;
@property (weak, nonatomic) id<CrossIconDelegate> delegate;
-(id)initWithStyle:(UITableViewStyle)style;

@end
