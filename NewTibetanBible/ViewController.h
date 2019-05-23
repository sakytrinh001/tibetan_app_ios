//
//  ViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChapterPickerTableViewController.h"
#import "ChapterPickerCollectionView.h"
#import "CrossIconTableViewController.h"
#import "WebViewAdditions.h"
#import "PersonalTableViewTableViewController.h"
#import "HighLightTableViewController.h"
#import "FavoritesTableViewController.h"
#import "SearchTableViewController.h"
#import "NoteViewController.h"
#import "EditNoteContentViewController.h"
#import "SettingViewController.h"
#import "EditFontSizeTableViewController.h"
#import "HistoryTableViewController.h"
#import "EditFontTableViewController.h"
#import "UIWebBrowserView+Additions.h"

@interface ViewController : UIViewController <ChapterPickerDelegate, HighLightTableViewControllerDelegate, SearchViewControllerDelegate, FavoritesTableViewControllerDelegate,UIWebViewDelegate, EditNoteContentViewControllerDelegate, UIPopoverPresentationControllerDelegate, CrossIconDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, NoteViewControllerDelegate, SettingViewControllerDelegate, EditFontSizeTableViewControllerDelegate, HistoryTableViewControllerDelegate, EditFontTableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *dataSize;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *chapterPickerButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *crossIconButton;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *changeBookView;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *viewForScroll;
@property (weak,nonatomic) IBOutlet UILabel *lbNameChapterScroll;

@property (strong, nonatomic) ChapterPickerTableViewController *chapterPickerTableViewController;
@property (strong, nonatomic) ChapterPickerCollectionView *chapterPickerViewController;
@property (strong, nonatomic) CrossIconTableViewController *crossIconTableViewController;
@property (strong, nonatomic) SearchTableViewController *searchTableViewController;
@property (strong, nonatomic) NSMutableArray *listBookObject;
@property (strong, nonatomic) NSMutableArray *listBookName;
@property (strong, nonatomic) NSMutableArray *listBookNameTitle;
@property (strong, nonatomic) NSMutableArray *listBookChapter;
@property (strong, nonatomic) NSMutableArray *listBookChapterLabel;
@property (strong, nonatomic) NSMutableDictionary *listHighLight;
@property (strong, nonatomic) NSMutableDictionary *listHighLightCheck;
@property (strong, nonatomic) NSMutableDictionary *listFavorite;
@property (strong, nonatomic) NSMutableDictionary *listCopy;

@property (strong, nonatomic) NSMutableDictionary *listNotes;
@property (strong, nonatomic) NSMutableDictionary *listHistory;
@property (strong, nonatomic) NSMutableArray *currentYPositionOfAllChapter;

+ (NSString *)encodeToNonLossyAscii:(NSString *)original;
- (IBAction)chapterPickerTapped:(id)sender;
- (IBAction)crossIconTapped:(id)sender;
- (IBAction)changeBook:(id)sender;
//- (void)makeYChapterPosition;

- (void)HideHeaderAndFooter;
- (void)configUIMenu;
@end

