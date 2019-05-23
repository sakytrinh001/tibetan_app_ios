//
//  SettingViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/23/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditFontSizeTableViewController.h"
#import "EditFontTableViewController.h"
@protocol SettingViewControllerDelegate
- (void)changeBackground:(NSString *)backgroundColor;
- (void)changeJustifiedText:(BOOL)flag;
@end

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *whiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *orangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontSizeBtn;
@property (weak, nonatomic) IBOutlet UISwitch *justifiedText;
@property (weak, nonatomic) id <SettingViewControllerDelegate> delegate;
@property (strong, nonatomic) id viewController;
@property (strong, nonatomic) NSString *currentFontSize;
@property (strong, nonatomic) NSString *currentFont;

- (IBAction)close:(id)sender;
- (IBAction)selectBackgroundColor:(id)sender;
- (IBAction)selectJustifiedText:(id)sender;

@end
