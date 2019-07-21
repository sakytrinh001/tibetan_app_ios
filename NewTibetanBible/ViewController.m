//
//  ViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>

// Declare const
NSString *const kHighlightKey = @"Highlight";
NSString *const kCopyKey = @"Copy";
NSString *const kFavoriteKey = @"FavoriteKey";
NSString *const kListNoteKey = @"NoteKey";
NSString *const kListHistory = @"HistoryKey";
NSString *const kHtmlHead = @"HtmlHead";
NSString *const kHtmlHeadBackgroundColor = @"HeadBackgroundColor";
NSString *const kHtmlHeadFont = @"HeadFont";
NSString *const kHtmlHeadFontSize = @"HeadFontSize";
NSString *const kHtmlHeadJustifiedText = @"HeadJustifiedText";

NSString *const kHtmlContentBook1 = @"41MAT_NTB";
NSString *const kHtmlContentBook2 = @"42MRK_NTB";
NSString *const kHtmlContentBook3 = @"43LUK_NTB";
NSString *const kHtmlContentBook4 = @"44JHN_NTB";
NSString *const kHtmlContentBook5 = @"45ACT_NTB";
NSString *const kHtmlContentBook6 = @"46ROM_NTB";
NSString *const kHtmlContentBook7 = @"471CO_NTB";
NSString *const kHtmlContentBook8 = @"482CO_NTB";
NSString *const kHtmlContentBook9 = @"49GAL_NTB";
NSString *const kHtmlContentBook10 = @"50EPH_NTB";
NSString *const kHtmlContentBook11 = @"51PHP_NTB";
NSString *const kHtmlContentBook12 = @"52COL_NTB";
NSString *const kHtmlContentBook13 = @"531TH_NTB";
NSString *const kHtmlContentBook14 = @"542TH_NTB";
NSString *const kHtmlContentBook15 = @"551TI_NTB";
NSString *const kHtmlContentBook16 = @"562TI_NTB";
NSString *const kHtmlContentBook17 = @"57TIT_NTB";
NSString *const kHtmlContentBook18 = @"58PHM_NTB";
NSString *const kHtmlContentBook19 = @"59HEB_NTB";
NSString *const kHtmlContentBook20 = @"60JAS_NTB";
NSString *const kHtmlContentBook21 = @"611PE_NTB";
NSString *const kHtmlContentBook22 = @"622PE_NTB";
NSString *const kHtmlContentBook23 = @"631JN_NTB";
NSString *const kHtmlContentBook24 = @"642JN_NTB";
NSString *const kHtmlContentBook25 = @"653JN_NTB";
NSString *const kHtmlContentBook26 = @"66JUD_NTB";
NSString *const kHtmlContentBook27 = @"67REV_NTB";

NSString *const KCurrentBook = @"CurrentBook";
NSString *const kSelectedBookNumber = @"SelectedBookNumber";
NSString *const kSelectedChapterNumber = @"SelectedChapterNumber";
NSString *const kSelectedVerseNumber = @"SelectedVerseNumber";
NSString *const kCurrentChapterName = @"CurrentChapterName";

@interface ViewController () {
    BOOL longpress;
    BOOL settingScreenClick;
    FPPopoverController *popover;
    BOOL scrollClick;
    BOOL scrollToVerse;
    UIView *viewSelect;
    UIView *viewOpacitySelect;
    UIButton *btnHighlight;
    UIButton *btnFavorites;
    UIButton *btnNote;
    UIButton *btnCopy;
    UIButton *btnShare;
    NSString *copyPast;
    UIActivityIndicatorView *spinner;
    int checkHighlight;
    int checkFavourite;
    int checkNote;
    BOOL checkScroll;
    
    NSString *chapterCoppy;
    int checkRoman;
    UIAlertView *alert;
    
    NSString *checkLoadData;
    
    int a;
}
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imageSplash;
@property (weak, nonatomic) IBOutlet UIButton *btnFontSize;
- (IBAction)btnFontSize:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewContentTbSize;
@property (weak, nonatomic) IBOutlet UIView *viewContentOpacity;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chapterPickerButton.titleLabel.adjustsFontSizeToFitWidth = true;
    
    a = 1;
    [self scrollViewDidScroll:_webView.scrollView];
    [self showSpinner];
    longpress = NO;
    settingScreenClick = NO;
    scrollClick = NO;
    scrollToVerse = NO;
    // size screen
    viewOpacitySelect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    viewOpacitySelect.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    viewOpacitySelect.alpha = 0.5f;
    viewOpacitySelect.layer.cornerRadius = 6.0f;
    viewOpacitySelect.center = self.view.center;
    [_webView addSubview:viewOpacitySelect];
    viewOpacitySelect.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapOpacity:)];
    tap.delegate = self;
    [viewOpacitySelect addGestureRecognizer:tap];
    
    
    //view Select
    viewSelect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewSelect.backgroundColor = [UIColor whiteColor];
    viewSelect.layer.cornerRadius = 6.0f;
    viewSelect.center = self.view.center;
    [_webView addSubview:viewSelect];
    
    _lbNameChapterScroll.adjustsFontSizeToFitWidth = true;
    [_lbNameChapterScroll sizeToFit];
    
    
    btnHighlight = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, 100, 100)];
    [btnHighlight addTarget:self action:@selector(markHighlightedString:) forControlEvents:UIControlEventTouchUpInside];
    [viewSelect addSubview:btnHighlight];
    
    btnFavorites = [[UIButton alloc] initWithFrame:CGRectMake(180, 8, 100, 100)];
    [btnFavorites addTarget:self action:@selector(markFavorites:) forControlEvents:UIControlEventTouchUpInside];
    [viewSelect addSubview:btnFavorites];
    
    btnNote = [[UIButton alloc] initWithFrame:CGRectMake(20, 98, 100, 100)];
    [btnNote addTarget:self action:@selector(markNote:) forControlEvents:UIControlEventTouchUpInside];
    [viewSelect addSubview:btnNote];
    
    btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(180, 98, 100, 100)];
    [btnCopy addTarget:self action:@selector(markCopyString:) forControlEvents:UIControlEventTouchUpInside];
    [viewSelect addSubview:btnCopy];
    
    btnShare = [[UIButton alloc] initWithFrame:CGRectMake(100, 53, 100, 100)];
    [btnShare addTarget:self action:@selector(markShare:) forControlEvents:UIControlEventTouchUpInside];
    [viewSelect addSubview:btnShare];
    
    [self handleBtn];
    viewSelect.hidden = YES;
    
    //opacity
    _viewContentOpacity.hidden = YES;
    _viewContentOpacity.frame = self.view.bounds;
    _viewContentOpacity.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _viewContentOpacity.alpha = 0.5;
    
    
    //hide
    _viewContentTbSize.hidden = YES;
    _tbView.layer.cornerRadius = _viewContentTbSize.layer.cornerRadius = 6;
    
    dataSize = [NSArray arrayWithObjects:@"ལྷག་ཏུ་ཆུང་བ།",@"ཆུང་བ།",@"འབྲིང་ཙམ།",@"ཆེ་བ།",@"ལྷག་ཏུ་ཆེ་བ།", nil];
    
    self.listBookObject = [[NSMutableArray alloc] init];
    self.listBookName = [[NSMutableArray alloc] init];
    self.listBookNameTitle = [[NSMutableArray alloc] init];
    self.listBookChapter = [[NSMutableArray alloc] init];
    self.listBookChapterLabel = [[NSMutableArray alloc] init];
    self.listHighLight = [[NSMutableDictionary alloc] init];
    self.listHighLightCheck = [[NSMutableDictionary alloc] init];
    self.listFavorite = [[NSMutableDictionary alloc] init];
    self.listNotes = [[NSMutableDictionary alloc] init];
    self.listHistory = [[NSMutableDictionary alloc] init];
    self.currentYPositionOfAllChapter = [[NSMutableArray alloc] init];
    
    
    //Check load data
    checkLoadData = @"1";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"checkData"] isEqualToString:@"0"]) {
        checkLoadData = @"0";
    }
    
    if ([checkLoadData isEqualToString:@"1"]) {
        [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(loadContentData)
                                       userInfo:nil
                                        repeats:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"checkData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self loadContentData];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.0
                                     target:self
                                   selector:@selector(hideImageSplash)
                                   userInfo:nil
                                    repeats:NO];
    
    checkScroll = true;
}


-(void) loadContentData{
    // list book file name
    NSArray *listBookArr = [[NSArray alloc] initWithObjects:@"41MAT_NTB", @"42MRK_NTB", @"43LUK_NTB", @"44JHN_NTB",
                            @"45ACT_NTB", @"46ROM_NTB",@"471CO_NTB",@"482CO_NTB" ,@"49GAL_NTB", @"50EPH_NTB", @"51PHP_NTB", @"52COL_NTB", @"531TH_NTB", @"542TH_NTB", @"551TI_NTB", @"562TI_NTB", @"57TIT_NTB", @"58PHM_NTB", @"59HEB_NTB", @"60JAS_NTB", @"611PE_NTB", @"622PE_NTB", @"631JN_NTB", @"642JN_NTB", @"653JN_NTB", @"66JUD_NTB", @"67REV_NTB", nil];
    // 2 process usfmtag for each book object of 27 book
    NSString *htmlString = @"";
    NSString * tmp  =   nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.webView.scrollView.delegate = self;
    // 0 check data is saved
    NSArray *listBookObjFromSave = [self loadCustomObjectWithKey:@"ListBookObject"];
    
    if (!listBookObjFromSave) {
        for (int i = 0 ; i < [listBookArr count]; i++) {
            BookModel *bookModel = [[BookModel alloc] initWithUrlFile:[listBookArr objectAtIndex:i]];
            self.listBookObject[i] = bookModel;
        }
        
        for (int j = 0; j < [self.listBookObject count]; j++)
        {
            @autoreleasepool
            {
                BookModel *bookModelObj = ((BookModel*)[self.listBookObject objectAtIndex:j]);
                int chapterNumber = 1;
                for (int i=0; i < [bookModelObj.arrBookSeperateLine count]; i++) {
                    NSString *usfmTag = [LoadContent getUsfmTag:[bookModelObj.arrBookSeperateLine objectAtIndex:i]];
                    if ([[LoadContent getChapterNumber:usfmTag inString:[bookModelObj.arrBookSeperateLine objectAtIndex:i]] intValue] > 1) {
                        chapterNumber = [[LoadContent getChapterNumber:usfmTag inString:[bookModelObj.arrBookSeperateLine objectAtIndex:i]] intValue];
                    }
                    [bookModelObj progressUsfmTag:usfmTag atIndex:i withBookId:j inChapter:chapterNumber];
                    usfmTag = nil;
                }
                
                self.listBookName[j] = bookModelObj.name;
                self.listBookNameTitle[j] = bookModelObj.name;
                self.listBookChapter[j] = bookModelObj.chapter;
                self.listBookChapterLabel[j] = bookModelObj.chapterLabel;
                NSLog(@"list: %@", self.listBookNameTitle[j]);
                tmp = [LoadContent mergeArrToHtmlString: bookModelObj.arrBookSeperateLine];
                switch (j) {
                    case 0:
                        [defaults setObject:tmp forKey:kHtmlContentBook1];
                        break;
                    case 1:
                        [defaults setObject:tmp forKey:kHtmlContentBook2];
                        break;
                    case 2:
                        [defaults setObject:tmp forKey:kHtmlContentBook3];
                        break;
                    case 3:
                        [defaults setObject:tmp forKey:kHtmlContentBook4];
                        break;
                    case 4:
                        [defaults setObject:tmp forKey:kHtmlContentBook5];
                        break;
                    case 5:
                        [defaults setObject:tmp forKey:kHtmlContentBook6];
                        break;
                    case 6:
                        [defaults setObject:tmp forKey:kHtmlContentBook7];
                        break;
                    case 7:
                        [defaults setObject:tmp forKey:kHtmlContentBook8];
                        break;
                    case 8:
                        [defaults setObject:tmp forKey:kHtmlContentBook9];
                        break;
                    case 9:
                        [defaults setObject:tmp forKey:kHtmlContentBook10];
                        break;
                    case 10:
                        [defaults setObject:tmp forKey:kHtmlContentBook11];
                        break;
                    case 11:
                        [defaults setObject:tmp forKey:kHtmlContentBook12];
                        break;
                    case 12:
                        [defaults setObject:tmp forKey:kHtmlContentBook13];
                        break;
                    case 13:
                        [defaults setObject:tmp forKey:kHtmlContentBook14];
                        break;
                    case 14:
                        [defaults setObject:tmp forKey:kHtmlContentBook15];
                        break;
                    case 15:
                        [defaults setObject:tmp forKey:kHtmlContentBook16];
                        break;
                    case 16:
                        [defaults setObject:tmp forKey:kHtmlContentBook17];
                        break;
                    case 17:
                        [defaults setObject:tmp forKey:kHtmlContentBook18];
                        break;
                    case 18:
                        [defaults setObject:tmp forKey:kHtmlContentBook19];
                        break;
                    case 19:
                        [defaults setObject:tmp forKey:kHtmlContentBook20];
                        break;
                    case 20:
                        [defaults setObject:tmp forKey:kHtmlContentBook21];
                        break;
                    case 21:
                        [defaults setObject:tmp forKey:kHtmlContentBook22];
                        break;
                    case 22:
                        [defaults setObject:tmp forKey:kHtmlContentBook23];
                        break;
                    case 23:
                        [defaults setObject:tmp forKey:kHtmlContentBook24];
                        break;
                    case 24:
                        [defaults setObject:tmp forKey:kHtmlContentBook25];
                        break;
                    case 25:
                        [defaults setObject:tmp forKey:kHtmlContentBook26];
                        break;
                    case 26:
                        [defaults setObject:tmp forKey:kHtmlContentBook27];
                        break;
                    default:
                        break;
                }
                [defaults setObject:@"0" forKey:KCurrentBook];
                htmlString = [defaults objectForKey:kHtmlContentBook1];
                self.listBookObject[j] = bookModelObj;
                bookModelObj = nil;
            }
        }
        
        [self saveCustomObject:self.listBookObject key:@"ListBookObject"];
        [defaults setObject:self.listBookName forKey:@"ListBookName"];
        [defaults setObject:self.listBookNameTitle forKey:@"ListBookNameTitle"];
    } else {
        self.listBookObject = [listBookObjFromSave mutableCopy];
        self.listBookName = [defaults objectForKey:@"ListBookName"];
        self.listBookNameTitle = [defaults objectForKey:@"ListBookNameTitle"];
        NSString *currentBook = [defaults objectForKey:KCurrentBook];
        htmlString = [[self getHtmlString:currentBook] mutableCopy];
        for (int i=0; i < [self.listBookObject count]; i++) {
            self.listBookChapter[i] = [(BookModel *)self.listBookObject[i] chapter];
            self.listBookChapterLabel[i] = [(BookModel *)self.listBookObject[i] chapterLabel];
        }
        
        // assign highlight array
        NSMutableDictionary *highlightTmp = [[defaults objectForKey:kHighlightKey] mutableCopy];
        if (highlightTmp) {
            self.listHighLight = highlightTmp;
        }
        
        // assign favorite array
        NSMutableDictionary *favoriteTmp = [[defaults objectForKey:kFavoriteKey] mutableCopy];
        if (favoriteTmp) {
            self.listFavorite = favoriteTmp;
        }
        
        // assign note array
        NSMutableDictionary *listNoteTmp = [[defaults objectForKey:kListNoteKey] mutableCopy];
        if (listNoteTmp) {
            self.listNotes = listNoteTmp;
        }
        
        // assign history array
        NSMutableDictionary *listHistoryTmp = [[defaults objectForKey:kListHistory] mutableCopy];
        if (listHistoryTmp) {
            self.listHistory = listHistoryTmp;
        }
    }
    
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    
    if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
        cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
    } else {
        cssBackground = @"background-color: transparent";
    }
    
    if ([defaults objectForKey:kHtmlHeadFontSize]) {
        cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
    } else {
        cssFontSize = @"font-size: 18";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
        cssFont = @"font-family: Monlam Uni Choukmatik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
        cssFont = @"font-family: Monlam Uni PayTsik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
        cssFont = @"font-family: SambhotaDege";
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }else {
        cssFont = @"font-family: SambhotaDege";
    }
    
    if ([defaults objectForKey:kHtmlHeadJustifiedText]) {
        cssJustifiedText = [defaults objectForKey:kHtmlHeadJustifiedText];
    } else {
        cssJustifiedText = @"text-align: justify";
    }
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [LoadContent loadJs:@"calc" inWebView:self.webView];
    [self HideHeaderAndFooter];
}

- (void) hideImageSplash{
    _imageSplash.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideSpinner];
    // Listen long press touch
    if (settingScreenClick == NO && scrollClick == NO && scrollToVerse == NO) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *bookNumber = [defaults objectForKey:KCurrentBook];
        self.currentYPositionOfAllChapter = [self getAllYChapterPosition:(int)[bookNumber integerValue]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openContextualMenuAt:) name:@"TapAndHoldNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllVerse:) name:@"TouchEndActionNotification" object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [self.webView addGestureRecognizer:tap];
        
        // detect uiwebview scroll
        self.webView.scrollView.delegate = self;
    } else if (settingScreenClick == YES) {
        settingScreenClick = NO;
    } else if (scrollClick == YES) {
        scrollClick = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *bookNumber = [defaults objectForKey:kSelectedBookNumber];
        NSString *chapterNumber = [defaults objectForKey:kSelectedChapterNumber];
        self.currentYPositionOfAllChapter = [self getAllYChapterPosition:(int)[bookNumber integerValue]];
        [self scrollToYPosition:[bookNumber integerValue] withChapter:[chapterNumber integerValue]];
        
    } else if (scrollToVerse == YES) {
        // Choose history or note or favorite
        scrollToVerse = NO;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *bookNumber = [defaults objectForKey:kSelectedBookNumber];
        // calculate offset for all chapter in new book
        self.currentYPositionOfAllChapter = [self getAllYChapterPosition:(int)[bookNumber integerValue]];
        NSString *chapterNumber = [defaults objectForKey:kSelectedChapterNumber];
        NSString *verseNumber = [defaults objectForKey:kSelectedVerseNumber];
        NSString *verseId = [NSString stringWithFormat:@"verse-%@-%@-%@", bookNumber, chapterNumber, verseNumber];
        [self scrollToY:verseId];
    }
}

//handle action icon
-(void) handleBtn{
    [btnFavorites setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
    btnFavorites.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnHighlight setImage:[UIImage imageNamed:@"highligh.png"] forState:UIControlStateNormal];
    [btnNote setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
    [btnCopy setImage:[UIImage imageNamed:@"copy.png"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
}


//handle long
//-(void)handleLong:(UILongPressGestureRecognizer *)recog{
//   if (recog.state == UIGestureRecognizerStateEnded) {
//        NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.getSelection().anchorNode.parentNode.id"]];
//        [self hideShowSelect];

//    }
//    [btnFavorites setEnabled:YES];
//    [btnNote setEnabled:YES];
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"gText();"]];

//}
#pragma mark - Handle tap
-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    bool isScrollViewAppear = NO;
    if (self.viewForScroll.hidden == false) {
        self.viewForScroll.hidden = true;
        isScrollViewAppear = YES;
    }
    if (!isScrollViewAppear) {
        if (recognizer.numberOfTapsRequired == 1) {
            if (self.headerView.hidden == true && self.footerView.hidden == true ) {
                self.headerView.hidden = false;
                self.footerView.hidden = false;
                return;
            } else {
                [self HideHeaderAndFooter];
            }
            
        }
    }
    
}

-(void)handleTapOpacity:(UITapGestureRecognizer*) recognizer{
    viewOpacitySelect.hidden = YES;
    viewSelect.hidden = YES;
    checkScroll = false;
}

#pragma IBAction Chapter Picker Tapped
- (IBAction)chapterPickerTapped:(id)sender {
    if (_chapterPickerTableViewController == nil) {
        _chapterPickerTableViewController = [[ChapterPickerTableViewController alloc] initWithStyle:UITableViewStylePlain listBookName:self.listBookNameTitle listChapter:self.listBookChapter];
        
        //TODO set delegate
        _chapterPickerTableViewController.delegate = self;
    }
    
    _chapterPickerTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPc = _chapterPickerTableViewController.popoverPresentationController;
    _chapterPickerTableViewController.popoverPresentationController.sourceRect = self.chapterPickerButton.frame;
    _chapterPickerTableViewController.popoverPresentationController.sourceView = self.view;
    popPc.delegate = self;
    [self presentViewController:_chapterPickerTableViewController animated:YES completion:nil];
}

- (void)exitChapterPicking {
    if (_chapterPickerTableViewController != nil) {
        [[_chapterPickerTableViewController presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
        [self HideHeaderAndFooter];
    }
}


#pragma ChapterPickerTableViewControllerDelegate
- (void)selectChapter: (NSIndexPath* )indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentBook = [defaults objectForKey:KCurrentBook];
    NSString *sectionCollect = [defaults objectForKey:@"section"];
    
    if ([currentBook integerValue] != ([sectionCollect integerValue] - 3)) {
        // Prepare For Html content string
        scrollClick = YES;
        self.currentYPositionOfAllChapter = nil;
        self.currentYPositionOfAllChapter = [[NSMutableArray alloc] init];
        // Head Css Can Change
        NSString *cssBackground = @"";
        NSString *cssFontSize = @"";
        NSString *cssFont = @"";
        NSString *cssJustifiedText = @"";
        
        if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
            cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
        } else {
            cssBackground = @"background-color: transparent";
        }
        
        if ([defaults objectForKey:kHtmlHeadFontSize]) {
            cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
        } else {
            cssFontSize = @"font-size: 14";
        }
        //        NSString *htmlStringFont = @"";
        NSString *htmlString = [self getHtmlString:[NSString stringWithFormat:@"%ld",(long)([sectionCollect integerValue] - 3)]];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
            cssFont = @"font-family: Monlam Uni Choukmatik";
            htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
            cssFont = @"font-family: Monlam Uni PayTsik";
            htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
            cssFont = @"font-family: SambhotaDege";
            htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
        }else {
            cssFont = @"font-family: SambhotaDege";
        }
        [defaults setObject:[NSString stringWithFormat:@"%ld",(long)([sectionCollect integerValue] - 3)] forKey:KCurrentBook];
        
        NSString *cssForAllHtml = [NSString stringWithFormat:
                                   @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                                   ];
        
        NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                        cssForAllHtml,
                                        htmlString,
                                        @"</body></html>"];
        // Add selected book and chapter to nsdefault
        [defaults setObject:[NSString stringWithFormat:@"%ld", (long)([sectionCollect integerValue] - 3)] forKey:kSelectedBookNumber];
        [defaults setObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:kSelectedChapterNumber];
        // Load the JavaScript code from the Resources and inject it into the web page
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
        
        // Scroll to Header
        NSString *scrollFunction0 = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[@"0" intValue]];
        [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction0];
        [self.webView loadHTMLString:contentHtml baseURL:nil];
        [self HideHeaderAndFooter];
        
    } else {
        [self scrollToYPosition:([sectionCollect integerValue] - 3) withChapter:indexPath.row];
    }
}

- (void)HideHeaderAndFooter {
    [self hideSpinner];
    
    // Hide header and footer
    if (self.headerView.hidden == false) {
        self.headerView.hidden = true;
    }
    
    if (self.footerView.hidden == false) {
        self.footerView.hidden = true;
        //        _btnFontSize.hidden = false;
    }
}

#pragma Cross Icon Tapped
- (IBAction)crossIconTapped:(id)sender {
    
    if (_crossIconTableViewController == nil) {
        _crossIconTableViewController = [[CrossIconTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //TODO set delegate
        _crossIconTableViewController.delegate = self;
    }
    
    _crossIconTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPc = _crossIconTableViewController.popoverPresentationController;
    _crossIconTableViewController.popoverPresentationController.sourceRect = self.crossIconButton.frame;
    _crossIconTableViewController.popoverPresentationController.sourceView = self.view;
    popPc.delegate = self;
    [self presentViewController:_crossIconTableViewController animated:YES completion:nil];
    
}

#pragma Cross Icon Delegate
- (void)selectCrossItem: (NSInteger )row {
    if (row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
    }
    
    if (row == 1) {
        // TODO: Feedback: send email
    }
    
    if (row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com/help"]];
    }
    
    if (_crossIconTableViewController != nil) {
        [[_crossIconTableViewController presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    
    [self HideHeaderAndFooter];
}

- (void)exitCrossSettingView {
    if (_crossIconTableViewController != nil) {
        [[_crossIconTableViewController presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
        [self HideHeaderAndFooter];
    }
    
}

#pragma scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.headerView.hidden == false && self.footerView.hidden == false) {
        [self HideHeaderAndFooter];
    }
}

#pragma uimenu and action for each menu
- (void)configUIMenu {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *markHighlightedString = [[UIMenuItem alloc] initWithTitle: @"གསལ་འདེབས།" action: @selector(markHighlightedString:)];
    UIMenuItem *markFavorite = [[UIMenuItem alloc] initWithTitle:@"དགའ་ཤོས།" action:@selector(markFavorites:)];
    UIMenuItem *markNote = [[UIMenuItem alloc] initWithTitle:@"ཟིན་བྲིས།" action:@selector(markNote:)];
    [menuController setMenuItems: [NSArray arrayWithObjects:markHighlightedString, markFavorite, markNote, nil]];
    [menuController setMenuVisible:YES animated:NO];
    //    //    [self hideShowSelect];
    //    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    //    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    //    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    //    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    //    NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    //    NSLog(@"verseIdSelected: %@", verseIdSelected);
    //    NSString *chapterId = [NSString stringWithFormat:@"%@", verseIdSelected];
    //    NSString *jsGetYPos = [[NSString alloc] initWithFormat:@"getYPositionVerse('%@')",chapterId];
    //    CGFloat offSetYOfChapter = [[self.webView stringByEvaluatingJavaScriptFromString:jsGetYPos] intValue];
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenHeight = screenRect.size.height;
    
    //    viewSelect.hidden = NO;
    //    viewOpacitySelect.hidden = NO;
    //    [self handleBtn];
    //    if (offSetYOfChapter < screenHeight/2 - 20) {
    //        [viewSelect setFrame:CGRectMake(viewSelect.frame.origin.x, offSetYOfChapter + 110 , viewSelect.frame.size.width, viewSelect.frame.size.height)];
    //    }else{
    //        [viewSelect setFrame:CGRectMake(viewSelect.frame.origin.x, offSetYOfChapter - 200 , viewSelect.frame.size.width, viewSelect.frame.size.height)];
    //    }
    
}
- (CGRect)rectForSelectedText {
    CGRect selectedTextFrame = CGRectFromString([self.webView stringByEvaluatingJavaScriptFromString:@"getRectForSelectedText()"]);
    return selectedTextFrame;
}

//hide/show viewselect
-(void) hideShowSelect{
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //The JS Function
    NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    NSString *selectedText = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    
    NSString *chapterId = [NSString stringWithFormat:@"%@", verseIdSelected];
    NSString *jsGetYPos = [[NSString alloc] initWithFormat:@"getYPositionVerse('%@')",chapterId];
    CGFloat offSetYOfChapter = [[self.webView stringByEvaluatingJavaScriptFromString:jsGetYPos] intValue];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    checkHighlight = 0;
    if (![selectedText isEqualToString:@""]) {
        viewSelect.hidden = NO;
        viewOpacitySelect.hidden = NO;
        [self handleBtn];
        if (offSetYOfChapter < screenHeight/2 - 20) {
            [viewSelect setFrame:CGRectMake(viewSelect.frame.origin.x, offSetYOfChapter + 110 , viewSelect.frame.size.width, viewSelect.frame.size.height)];
        }else{
            [viewSelect setFrame:CGRectMake(viewSelect.frame.origin.x, offSetYOfChapter - 200 , viewSelect.frame.size.width, viewSelect.frame.size.height)];
        }
        checkScroll = false;
        self.headerView.hidden = true;
        self.footerView.hidden = true;
    }else{
        viewSelect.hidden = YES;
        viewOpacitySelect.hidden = YES;
        checkScroll = true;
        self.headerView.hidden = false;
        self.footerView.hidden = false;
    }
    for (NSString *strHighligh in _listHighLight) {
        if ([strHighligh isEqualToString:verseIdSelected]) {
            [btnHighlight setImage:[UIImage imageNamed:@"highlight_action.png"] forState:UIControlStateNormal];
            checkHighlight = 1;
            break;
        }else{
            [btnHighlight setImage:[UIImage imageNamed:@"highligh.png"] forState:UIControlStateNormal];
            checkHighlight = 0;
        }
    }
    for (NSString *strFavourite in _listFavorite) {
        if ([strFavourite isEqualToString:verseIdSelected]) {
            [btnFavorites setImage:[UIImage imageNamed:@"favorites_action.png"] forState:UIControlStateNormal];
            checkFavourite = 1;
            [btnFavorites setEnabled:NO];
            break;
        }else{
            [btnFavorites setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
            checkFavourite = 0;
            [btnFavorites setEnabled:YES];
        }
    }
    for (NSString *strNote in _listNotes) {
        if ([strNote isEqualToString:verseIdSelected]) {
            [btnNote setImage:[UIImage imageNamed:@"note_action.png"] forState:UIControlStateNormal];
            checkNote = 1;
            [btnNote setEnabled:NO];
            break;
        }else{
            [btnNote setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
            checkNote = 0;
            [btnNote setEnabled:YES];
        }
    }
    
    
}


-(IBAction)markShare:(id)sender{
    [btnShare setImage:[UIImage imageNamed:@"share_action.png"] forState:UIControlStateNormal];
    [self markCopyString:sender];
    [btnCopy setImage:[UIImage imageNamed:@"copy.png"] forState:UIControlStateNormal];
    NSString *share = [[NSUserDefaults standardUserDefaults] objectForKey:kCopyKey];
    UIActivityViewController *activityViewController;
    activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[share] applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    viewSelect.hidden = YES;
    viewOpacitySelect.hidden = YES;
}

- (IBAction)markCopyString:(id)sender{
    [btnCopy setImage:[UIImage imageNamed:@"copy_action.png"] forState:UIControlStateNormal];
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //The JS Function
    NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    NSString *startSearch   = [NSString stringWithFormat:@"getSelectedText('%@')", verseIdSelected];
    NSString *selectedText = [_webView stringByEvaluatingJavaScriptFromString:startSearch];
    //    if ([selectedText isEqualToString:@""]) {
    selectedText = [[_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    }
    if (![selectedText isEqualToString:@" "]) {
        NSArray *listItem = [verseIdSelected componentsSeparatedByString:@"-"];
        NSString *strVerse = [listItem lastObject];
        NSString *strChapter = @"";
        if (listItem.count >= 3) {
            strChapter = [listItem objectAtIndex:2];
        }
        if ([strChapter isEqualToString:@""]) {
            if (checkRoman == 0) {
                checkRoman = 1;
            }
            strChapter = [NSString stringWithFormat:@"%i", checkRoman];
        }
        if (listItem.count > 0) {
            NSArray *ar = [selectedText componentsSeparatedByString:@" "];
            strVerse = ar[0];
            selectedText = [selectedText stringByReplacingOccurrencesOfString:ar[0] withString:@""];
        }
        
        // Save Copy
        [self.listCopy setObject:[NSString stringWithFormat:@"%@ ༼%@ %@:%@༽", selectedText, [copyPast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strChapter, strVerse] forKey:verseIdSelected];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%@ ༼%@ %@:%@༽", selectedText, [copyPast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strChapter, strVerse] forKey:kCopyKey];
        [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"%@ ༼%@ %@:%@༽", selectedText, [copyPast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strChapter, strVerse] ];
        
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:[NSString stringWithFormat:@"%@ %@:%@", [copyPast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strChapter, strVerse]
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:.5
                                         target:self
                                       selector:@selector(targetMethod)
                                       userInfo:nil
                                        repeats:NO];
    }
    
}

-(void) targetMethod{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}

- (IBAction)markHighlightedString:(id)sender {
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //  The JS Function
    NSString *idForSpanHighLight = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    NSString *selectHighlight = @"";
    if ([idForSpanHighLight isEqualToString:@""]) {
        selectHighlight = [[_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *listItem = [idForSpanHighLight componentsSeparatedByString:@"-"];
        NSString *strVerse = [listItem lastObject];
        NSString *strChapter = @"";
        if (listItem.count >= 3) {
            strChapter = [listItem objectAtIndex:2];
        }
        if ([strChapter isEqualToString:@""]) {
            if (checkRoman == 0) {
                checkRoman = 1;
            }
            strChapter = [NSString stringWithFormat:@"%i", checkRoman];
        }
        
        if (listItem.count == 1) {
            NSArray *ar = [selectHighlight componentsSeparatedByString:@" "];
            strVerse = ar[0];
            selectHighlight = [selectHighlight stringByReplacingOccurrencesOfString:ar[0] withString:@""];
        }
        idForSpanHighLight = [NSString stringWithFormat:@"verse-%@-%@-%@", [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentBook], strChapter, strVerse];
    }
    if (checkHighlight == 0) {
        if (![idForSpanHighLight isEqualToString:@""]) {
            [btnHighlight setImage:[UIImage imageNamed:@"highlight_action.png"] forState:UIControlStateNormal];
            NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString('%@')", idForSpanHighLight];
            NSString *selectedText = [_webView stringByEvaluatingJavaScriptFromString:startSearch];
            [self.listHighLight setObject:selectedText forKey:idForSpanHighLight];
            checkHighlight = 1;
        }
    }else{
        [btnHighlight setImage:[UIImage imageNamed:@"highligh.png"] forState:UIControlStateNormal];
        NSString *startSearch  = [NSString stringWithFormat:@"stylizeRemoveHighlightedString('%@')", idForSpanHighLight];
        [_webView stringByEvaluatingJavaScriptFromString:startSearch];
        [self.listHighLight removeObjectForKey:idForSpanHighLight];
        checkHighlight = 0;
    }
    NSArray *verseArray = [idForSpanHighLight componentsSeparatedByString:@"-"];
    if (verseArray.count>= 2) {
        [self SaveBookHtmlContent:(NSString *)[verseArray objectAtIndex:1]];
    }
    
    // Save highlight
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.listHighLight forKey:kHighlightKey];
}

- (IBAction)markFavorites:(id)sender {
    if (checkFavourite == 0) {
        [btnFavorites setImage:[UIImage imageNamed:@"favorites_action.png"] forState:UIControlStateNormal];
        // The JS File
        NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        [_webView stringByEvaluatingJavaScriptFromString:jsString];
        
        //     The JS Function
        NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
        NSString *startSearch   = [NSString stringWithFormat:@"getSelectedText('%@')", verseIdSelected];
        NSString *selectedText = [_webView stringByEvaluatingJavaScriptFromString:startSearch];
        selectedText = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.textContent"];
        [self.listFavorite setObject:selectedText forKey:verseIdSelected];
        
        // Save favorites array change
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.listFavorite forKey:kFavoriteKey];
        [self btnHideViewSize:sender];
    }
    
}

- (IBAction)markNote:(id)sender {
    if (checkNote == 0) {
        [btnNote setImage:[UIImage imageNamed:@"note_action.png"] forState:UIControlStateNormal];
        // Get Verse Id
        NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        [_webView stringByEvaluatingJavaScriptFromString:jsString];
        
        //     The JS Function
        NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
        NSString *select = @"";
        if ([verseIdSelected isEqualToString:@""]) {
            select = [[_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *listItem = [verseIdSelected componentsSeparatedByString:@"-"];
            NSString *strVerse = [listItem lastObject];
            NSString *strChapter = @"";
            if (listItem.count >= 3) {
                strChapter = [listItem objectAtIndex:2];
            }
            if ([strChapter isEqualToString:@""]) {
                if (checkRoman == 0) {
                    checkRoman = 1;
                }
                strChapter = [NSString stringWithFormat:@"%i", checkRoman];
            }
            
            if (listItem.count == 1) {
                NSArray *ar = [select componentsSeparatedByString:@" "];
                strVerse = ar[0];
                select = [select stringByReplacingOccurrencesOfString:ar[0] withString:@""];
            }
            verseIdSelected = [NSString stringWithFormat:@"verse-%@-%@-%@", [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentBook], strChapter, strVerse];
        }
        
        NSArray *allVerseDidNoted = [self.listNotes allKeys];
        NSUInteger indexOfTheVerse = [allVerseDidNoted indexOfObject: verseIdSelected];
        
        // Check this verse is noted or not ?
        
        
        NoteViewController *noteVc = [[NoteViewController alloc] init];
        noteVc.delegate = self;
        if (indexOfTheVerse != NSNotFound) {
            noteVc.currentNoteContent = [self.listNotes objectForKey:verseIdSelected];
        }
        popover = [[FPPopoverController alloc] initWithViewController:noteVc];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        popover.contentSize = CGSizeMake(screenRect.size.width - 40, screenRect.size.height/2);
        popover.arrowDirection = FPPopoverNoArrow;
        popover.border = NO;
        
        NSArray *verseArray = [verseIdSelected componentsSeparatedByString:@"-"];
        NSString *bookName;
        NSString *bookChapter;
        NSString *bookVerse;
        if (verseArray.count >= 2) {
            bookName = [self.listBookName objectAtIndex:[[verseArray objectAtIndex:1] integerValue]];
        }
        if (verseArray.count >= 3) {
            bookChapter = [verseArray objectAtIndex:2];
        }
        if (verseArray.count >= 4) {
            bookVerse = [verseArray objectAtIndex:3];
        }
        noteVc.titleView.text = [NSString stringWithFormat:@"%@:%@-%@", bookName, bookChapter, bookVerse];
        noteVc.currentVerseId = verseIdSelected;
        noteVc.listNotes = self.listNotes;
        
        //the popover will be presented from the okButton view
        [popover presentPopoverFromView:self.chapterPickerButton];
        viewSelect.hidden = YES;
        viewOpacitySelect.hidden = YES;
    }
}

#pragma Process Long Press In UIWebView

- (void)openContextualMenuAt:(CGPoint)pt
{
    //    if (!longpress) {
    //        NSString * highlighted = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.textContent"];
    //        NSString * toString = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    //    NSString *tags = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    // Load the JavaScript code from the Resources and inject it into the web page
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
    //    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *jsCode1 = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
    //    [self.webView stringByEvaluatingJavaScriptFromString: jsCode1];
    [self.webView stringByEvaluatingJavaScriptFromString: jsCode1];
    //    NSString * highlighted = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.parentNode"];
    // get the Tags at the touch location
    double delayInSeconds = 0.1;
    [self customMouse];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *tags = [self.webView stringByEvaluatingJavaScriptFromString:
                          [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint();"]];
        if ([tags rangeOfString:@"verse" ].location != NSNotFound) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SelectText('%@');", tags]];
            [self hideShowSelect];
        }
    });
    longpress = YES;
}

-(void) customMouse{
    NSString *verseIdSelected = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
    NSString *selectedText = [[_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.textContent"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([selectedText length] > 0) {
        NSArray *listItem = [verseIdSelected componentsSeparatedByString:@"-"];
        NSString *strVerse = [listItem lastObject];
        NSString *strChapter = @"";
        if (listItem.count >= 3) {
            strChapter = [listItem objectAtIndex:2];
        }
        if ([strChapter isEqualToString:@""]) {
            if (checkRoman == 0) {
                checkRoman = 1;
            }
            strChapter = [NSString stringWithFormat:@"%i", checkRoman];
        }
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:[NSString stringWithFormat:@"%@ %@:%@", [copyPast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strChapter, strVerse]
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}

- (void)getAllVerse:(CGPoint)pt {
    //    NSString * highlighted = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().anchorNode.textContent"];
    //    NSString * toString = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    if (!longpress) {
        self.webView.userInteractionEnabled = YES;
    } else {
        // Load the JavaScript code from the Resources and inject it into the web page
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js"];
        //        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
        ////        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //        NSString *jsCode1 = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
        ////        [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
        //        [self.webView stringByEvaluatingJavaScriptFromString: jsCode1];
        //
        //        double delayInSeconds = 0.2;
        //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //            NSString *tags = [self.webView stringByEvaluatingJavaScriptFromString:
        //                              [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint();"]];
        //            if ([tags isEqualToString:@""]) {
        //                tags = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"GetVerseIdSelected();"]];
        //            }
        //            if ([tags rangeOfString:@"verse" ].location != NSNotFound) {
        //                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SelectText('%@');", @""]];
        //            }
        ////            [self hideShowSelect];
        //        });
        longpress = NO;
    }
    
}

#pragma show personal view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowPersonalScreen"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PersonalTableViewTableViewController *personalController = (PersonalTableViewTableViewController *)navController.topViewController;
        personalController.listHighLight = self.listHighLight;
        personalController.listBookName = [self.listBookName mutableCopy];
        personalController.listFavorite = self.listFavorite;
        personalController.listNote = self.listNotes;
        personalController.listHistory = self.listHistory;
        personalController.viewController = self;
    }
    
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchTableViewController *searchController = segue.destinationViewController;
        searchController.listBookObject = self.listBookObject;
        searchController.listBookName = self.listBookNameTitle;
        searchController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"ShowSettingViewScreen"]) {
        SettingViewController *settingViewController = segue.destinationViewController;
        settingViewController.delegate = self;
        settingViewController.viewController = self;
    }
}

#pragma  highlight delegate
- (void)scrollToHighLight:(NSString *)verseId {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self scrollToYVersePosition:verseId];
    [self HideHeaderAndFooter];
}

//- (void)removeHighLight:(NSString *)verseId {
//    // The JS File
//    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
//    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
//    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
//    [_webView stringByEvaluatingJavaScriptFromString:jsString];
//
//    // The JS Function
//    NSString *jsRemoveHighLight = [NSString stringWithFormat:@"RemoveHighLight('%@');", verseId];
//    [_webView stringByEvaluatingJavaScriptFromString:jsRemoveHighLight];
//
//    // Save html content
//    NSArray *verseArr = [verseId componentsSeparatedByString:@"-"];
//    [self SaveBookHtmlContent:(NSString *)[verseArr objectAtIndex:1]];
//    // Save highlight array change
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.listHighLight forKey:kHighlightKey];
//}

#pragma favorites delegate
- (void)scrollToFavorite:(NSString *)verseId {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self scrollToYVersePosition:verseId];
    [self HideHeaderAndFooter];
    
}

#pragma History delegate

- (void)scrollToHistory:(NSString *)verseId {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self scrollToYVersePosition:verseId];
    [self HideHeaderAndFooter];
}

#pragma SearchViewControllerDelegate
- (void)scrollToSearch:(NSString *)verseId {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self scrollToYVersePosition:verseId];
    [self HideHeaderAndFooter];
}

#pragma save book model to nsuserdefault
- (void)saveCustomObject:(NSArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    NSArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


#pragma NoteViewController Delegate
- (void)closeNotePopover {
    [popover dismissPopoverAnimated:YES];
}

#pragma EditNoteContentViewController
- (void)scrollToNote:(NSString *)currentNoteVerseId {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self scrollToYVersePosition:currentNoteVerseId];
    [self HideHeaderAndFooter];
    
}


#pragma SettingViewControllerDelegate
- (void)changeBackground:(NSString *)backgroundColor {
    settingScreenClick = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *htmlStringFont = @"";
    NSString *htmlString = [self getHtmlString:[defaults objectForKey:KCurrentBook]];
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    cssBackground = [NSString stringWithFormat:@"background-color: %@", backgroundColor];
    
    if ([backgroundColor isEqualToString:@"black"]) {
        cssBackground = [NSString stringWithFormat:@"background-color: black; color: white"];
        _webView.backgroundColor=self.viewContent.backgroundColor = [UIColor blackColor];
        
    }
    if ([backgroundColor isEqualToString:@"white"]) {
        _webView.backgroundColor=self.viewContent.backgroundColor = [UIColor whiteColor];
    }
    if ([backgroundColor isEqualToString:@"#F9FAE6"]) {
        _webView.backgroundColor=self.viewContent.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.90 alpha:1.0];
    }
    
    if ([defaults objectForKey:kHtmlHeadFontSize]) {
        cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
    } else {
        cssFontSize = @"font-size: 14";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
        cssFont = @"font-family: Monlam Uni Choukmatik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
        cssFont = @"font-family: Monlam Uni PayTsik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
        cssFont = @"font-family: SambhotaDege";
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }else {
        cssFont = @"font-family: SambhotaDege";
    }
    if ([defaults objectForKey:kHtmlHeadJustifiedText]) {
        cssJustifiedText = [defaults objectForKey:kHtmlHeadJustifiedText];
    } else {
        cssJustifiedText = @"text-align: justify";
    }
    
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [self HideHeaderAndFooter];
    [defaults setObject:cssBackground forKey:kHtmlHeadBackgroundColor];
}

- (void)changeJustifiedText:(BOOL)flag {
    settingScreenClick = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *htmlStringFont = @"";
    NSString *htmlString = [self getHtmlString:[defaults objectForKey:KCurrentBook]];
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
        cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
    } else {
        cssBackground = @"background-color: transparent";
    }
    
    if ([defaults objectForKey:kHtmlHeadFontSize]) {
        cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
    } else {
        cssFontSize = @"font-size: 14";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
        cssFont = @"font-family: Monlam Uni Choukmatik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
        cssFont = @"font-family: Monlam Uni PayTsik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
        cssFont = @"font-family: SambhotaDege";
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }else {
        cssFont = @"font-family: SambhotaDege";
    }
    if (flag) {
        cssJustifiedText = @"text-align: justify";
    } else {
        cssJustifiedText = @"text-align: none";
    }
    
    
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [self HideHeaderAndFooter];
    [defaults setObject:cssJustifiedText forKey:kHtmlHeadJustifiedText];
}

#pragma EditFontSizeTableViewDelegate
- (void)editFontSize:(NSString *)fontSize {
    _lbNameChapterScroll.text = @"དམ་པའི་གསུང་རབ། གཞུང་པོད་འདེམ་རོགས།";
    settingScreenClick = YES;
    self.currentYPositionOfAllChapter = nil;
    self.currentYPositionOfAllChapter = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *htmlString = [self getHtmlString:[defaults objectForKey:KCurrentBook]];
    //    NSString *htmlStringFont = @"";
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    
    if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
        cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
    } else {
        cssBackground = @"background-color: transparent";
    }
    
    cssFontSize  = [NSString stringWithFormat:@"font-size: %@",fontSize];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
        cssFont = @"font-family: Monlam Uni Choukmatik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
        cssFont = @"font-family: Monlam Uni PayTsik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
        cssFont = @"font-family: SambhotaDege";
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }else {
        cssFont = @"font-family: SambhotaDege";
    }
    
    if ([defaults objectForKey:kHtmlHeadJustifiedText]) {
        cssJustifiedText = [defaults objectForKey:kHtmlHeadJustifiedText];
    } else {
        cssJustifiedText = @"text-align: justify";
    }
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [self HideHeaderAndFooter];
    
    [defaults setObject:cssFontSize forKey:kHtmlHeadFontSize];
}

#pragma EditFontTableViewControllerDelegate
- (void)editFont:(NSString *)fontName {
    _lbNameChapterScroll.text = @"དམ་པའི་གསུང་རབ། གཞུང་པོད་འདེམ་རོགས།";
    settingScreenClick = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *htmlString = [self getHtmlString:[defaults objectForKey:KCurrentBook]];
    //    NSString *htmlStringFont = @"";
    
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    
    if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
        cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
    } else {
        cssBackground = @"background-color: transparent";
    }
    
    if ([defaults objectForKey:kHtmlHeadFontSize]) {
        cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
    } else {
        cssFontSize = @"font-size: 14";
    }
    
    cssFont = [NSString stringWithFormat:@"font-family: %@", fontName];
    if ([cssFont isEqualToString:@"font-family: Monlam Uni Choukmatik"]) {
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([cssFont isEqualToString:@"font-family: Monlam Uni PayTsik"]){
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([cssFont isEqualToString:@"font-family: SambhotaDege"]){
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }
    
    if ([defaults objectForKey:kHtmlHeadJustifiedText]) {
        cssJustifiedText = [defaults objectForKey:kHtmlHeadJustifiedText];
    } else {
        cssJustifiedText = @"text-align: justify";
    }
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [self HideHeaderAndFooter];
    
    [defaults setObject:cssFontSize forKey:kHtmlHeadFont];
    
}

- (NSString *)getHtmlString:(NSString *)currentBook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *htmlString = @"";
    switch ([currentBook integerValue]) {
        case 0:
            htmlString = [defaults objectForKey:kHtmlContentBook1];
            break;
        case 1:
            htmlString = [defaults objectForKey:kHtmlContentBook2];
            break;
        case 2:
            htmlString =  [defaults objectForKey:kHtmlContentBook3];
            break;
        case 3:
            htmlString =  [defaults objectForKey:kHtmlContentBook4];
            break;
        case 4:
            htmlString = [defaults objectForKey:kHtmlContentBook5];
            break;
        case 5:
            htmlString = [defaults objectForKey:kHtmlContentBook6];
            break;
        case 6:
            htmlString = [defaults objectForKey:kHtmlContentBook7];
            break;
        case 7:
            htmlString = [defaults objectForKey:kHtmlContentBook8];
            break;
        case 8:
            htmlString = [defaults objectForKey:kHtmlContentBook9];
            break;
        case 9:
            htmlString = [defaults objectForKey:kHtmlContentBook10];
            break;
        case 10:
            htmlString = [defaults objectForKey:kHtmlContentBook11];
            break;
        case 11:
            htmlString = [defaults objectForKey:kHtmlContentBook12];
            break;
        case 12:
            htmlString = [defaults objectForKey:kHtmlContentBook13];
            break;
        case 13:
            htmlString = [defaults objectForKey:kHtmlContentBook14];
            break;
        case 14:
            htmlString = [defaults objectForKey:kHtmlContentBook15];
            break;
        case 15:
            htmlString = [defaults objectForKey:kHtmlContentBook16];
            break;
        case 16:
            htmlString = [defaults objectForKey:kHtmlContentBook17];
            break;
        case 17:
            htmlString = [defaults objectForKey:kHtmlContentBook18];
            break;
        case 18:
            htmlString = [defaults objectForKey:kHtmlContentBook19];
            break;
        case 19:
            htmlString = [defaults objectForKey:kHtmlContentBook20];
            break;
        case 20:
            htmlString = [defaults objectForKey:kHtmlContentBook21];
            break;
        case 21:
            htmlString = [defaults objectForKey:kHtmlContentBook22];
            break;
        case 22:
            htmlString = [defaults objectForKey:kHtmlContentBook23];
            break;
        case 23:
            htmlString = [defaults objectForKey:kHtmlContentBook24];
            break;
        case 24:
            htmlString = [defaults objectForKey:kHtmlContentBook25];
            break;
        case 25:
            htmlString = [defaults objectForKey:kHtmlContentBook26];
            break;
        case 26:
            htmlString = [defaults objectForKey:kHtmlContentBook27];
            break;
        default:
            break;
    }
    return htmlString;
}

- (void)SaveBookHtmlContent:(NSString *)currentBook {
    // The JS File
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // Save html content
    NSString *htmlContent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    switch ([currentBook integerValue]) {
        case 0:
            [defaults setObject:htmlContent forKey:kHtmlContentBook1];
            break;
        case 1:
            [defaults setObject:htmlContent forKey:kHtmlContentBook2];
            break;
        case 2:
            [defaults setObject:htmlContent forKey:kHtmlContentBook3];
            break;
        case 3:
            [defaults setObject:htmlContent forKey:kHtmlContentBook4];
            break;
        case 4:
            [defaults setObject:htmlContent forKey:kHtmlContentBook5];
            break;
        case 5:
            [defaults setObject:htmlContent forKey:kHtmlContentBook6];
            break;
        case 6:
            [defaults setObject:htmlContent forKey:kHtmlContentBook7];
            break;
        case 7:
            [defaults setObject:htmlContent forKey:kHtmlContentBook8];
            break;
        case 8:
            [defaults setObject:htmlContent forKey:kHtmlContentBook9];
            break;
        case 9:
            [defaults setObject:htmlContent forKey:kHtmlContentBook10];
            break;
        case 10:
            [defaults setObject:htmlContent forKey:kHtmlContentBook11];
            break;
        case 11:
            [defaults setObject:htmlContent forKey:kHtmlContentBook12];
            break;
        case 12:
            [defaults setObject:htmlContent forKey:kHtmlContentBook13];
            break;
        case 13:
            [defaults setObject:htmlContent forKey:kHtmlContentBook14];
            break;
        case 14:
            [defaults setObject:htmlContent forKey:kHtmlContentBook15];
            break;
        case 15:
            [defaults setObject:htmlContent forKey:kHtmlContentBook16];
            break;
        case 16:
            [defaults setObject:htmlContent forKey:kHtmlContentBook17];
            break;
        case 17:
            [defaults setObject:htmlContent forKey:kHtmlContentBook18];
            break;
        case 18:
            [defaults setObject:htmlContent forKey:kHtmlContentBook19];
            break;
        case 19:
            [defaults setObject:htmlContent forKey:kHtmlContentBook20];
            break;
        case 20:
            [defaults setObject:htmlContent forKey:kHtmlContentBook21];
            break;
        case 21:
            [defaults setObject:htmlContent forKey:kHtmlContentBook22];
            break;
        case 22:
            [defaults setObject:htmlContent forKey:kHtmlContentBook23];
            break;
        case 23:
            [defaults setObject:htmlContent forKey:kHtmlContentBook24];
            break;
        case 24:
            [defaults setObject:htmlContent forKey:kHtmlContentBook25];
            break;
        case 25:
            [defaults setObject:htmlContent forKey:kHtmlContentBook26];
            break;
        case 26:
            [defaults setObject:htmlContent forKey:kHtmlContentBook27];
            break;
        default:
            break;
    }
    
}

- (void)scrollToYPosition:(long)BookNumber withChapter:(long)ChapterNumber {
    // Load the JavaScript code from the Resources and inject it into the web page
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
    
    // Scroll to Header
    NSString *scrollFunction0 = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[@"0" intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction0];
    
    
    NSString *idForSpanHistory = [NSString stringWithFormat:@"verse-%ld-%ld-%d",BookNumber, ChapterNumber, 1];
    NSString *startSearch   = [NSString stringWithFormat:@"GetTextContenById('%@')", idForSpanHistory];
    NSString *selectedText = [_webView stringByEvaluatingJavaScriptFromString:startSearch];
    [self.listHistory setObject:selectedText forKey:idForSpanHistory];
    
    // scroll to y
    NSString *chapterId = [NSString stringWithFormat:@"%ld-%ld",BookNumber, (ChapterNumber +1)];
    NSString *jsGetYPos = [[NSString alloc] initWithFormat:@"getYPos('%@')",chapterId];
    NSString *offSetYOfChapter = [self.webView stringByEvaluatingJavaScriptFromString:jsGetYPos];
    
    NSString *scrollFunction = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[offSetYOfChapter intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction];
    
    if (_chapterPickerTableViewController != nil) {
        [[_chapterPickerTableViewController presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    [self.chapterPickerButton setTitle:[NSString stringWithFormat:@"དམ་པའི་གསུང་རབ། གཞུང་པོད་འདེམ་རོགས།"] forState:UIControlStateNormal];
    
    [self HideHeaderAndFooter];
    
}

- (void)scrollToY:(NSString *)verseId {
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // Scroll to Header
    NSString *scrollFunction0 = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[@"0" intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction0];
    
    // The JS Function
    NSString *offsetForVerse = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getHighLightYPosition('%@');", verseId]];
    
    // scroll to y
    NSString *scrollFunction = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[offsetForVerse intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction];
}

- (void)scrollToYVersePosition:(NSString *)verseId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *verseArray = [verseId componentsSeparatedByString:@"-"];
    if ([[defaults objectForKey:kSelectedBookNumber] integerValue] != [[verseArray objectAtIndex:1] integerValue]) {
        // calculate all chapter offset of new book
        self.currentYPositionOfAllChapter = nil;
        self.currentYPositionOfAllChapter = [[NSMutableArray alloc] init];
        [self LoadNewBook:[[verseArray objectAtIndex:1] integerValue] withChapter:[[verseArray objectAtIndex:2] integerValue] withVerse: [[verseArray objectAtIndex:3] integerValue]];
    } else {
        [self scrollToY:verseId];
    }
}


#pragma mark - Spinner
- (void) hideSpinner{
    [spinner stopAnimating];
    [spinner setHidesWhenStopped:YES];
    spinner.hidden = YES;
}

-(void) showSpinner{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor blackColor];
    spinner.center = self.view.center;
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [spinner setHidden:NO];
}


#pragma mark - Load New Book
- (void)LoadNewBook:(long)bookNumber withChapter:(long)chapterNumber withVerse:(long)verseNumber {
    [self showSpinner];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *htmlString = [self getHtmlString:[NSString stringWithFormat:@"%ld",bookNumber]];
    //    NSString *htmlStringFont = @"";
    // Prepare For Html content string
    scrollToVerse = YES;
    // Head Css Can Change
    NSString *cssBackground = @"";
    NSString *cssFontSize = @"";
    NSString *cssFont = @"";
    NSString *cssJustifiedText = @"";
    
    if ([defaults objectForKey:kHtmlHeadBackgroundColor]) {
        cssBackground = [defaults objectForKey:kHtmlHeadBackgroundColor];
    } else {
        cssBackground = @"background-color: transparent";
    }
    
    if ([defaults objectForKey:kHtmlHeadFontSize]) {
        cssFontSize = [defaults objectForKey:kHtmlHeadFontSize];
    } else {
        cssFontSize = @"font-size: 14";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni Choukmatik"]) {
        cssFont = @"font-family: Monlam Uni Choukmatik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"Monlam Uni PayTsik"]){
        cssFont = @"font-family: Monlam Uni PayTsik";
        htmlString = [[[htmlString stringByReplacingOccurrencesOfString:@"bottom: 12px; border-radius: 10px;" withString:@"bottom: 4px; position: relative;border-radius:10px;"] stringByReplacingOccurrencesOfString:@"<span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>" withString:@"<span style='bottom: 3px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span>"] stringByReplacingOccurrencesOfString:@"style='bottom: 6px; border-radius: 10px;width: 8px;" withString:@"style='bottom: 14px; border-radius: 10px;width: 8px;"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"keyFont"] isEqualToString:@"SambhotaDege"]){
        cssFont = @"font-family: SambhotaDege";
        htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"'> 54-55 &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།" withString:@"'> 54-55 &nbsp &nbsp གང་གིས་མེས་པོ་ཨབ་ར་ཧམ་སོགས༌ནི།།"] stringByReplacingOccurrencesOfString:@"'> 74-75 &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།" withString:@"'> 74-75 &nbsp &nbsp ཁོང་གིས་བདག་ཅག་ལ་ནི་དགྲ་ལས་སྐྱོབ་ཕྱིར༌དང༌།།"];
    }else {
        cssFont = @"font-family: SambhotaDege";
    }
    
    if ([defaults objectForKey:kHtmlHeadJustifiedText]) {
        cssJustifiedText = [defaults objectForKey:kHtmlHeadJustifiedText];
    } else {
        cssJustifiedText = @"text-align: justify";
    }
    
    [defaults setObject:[NSString stringWithFormat:@"%ld",bookNumber] forKey:KCurrentBook];
    
    NSString *cssForAllHtml = [NSString stringWithFormat:
                               @"<html><head><style>body { %@; %@; %@; %@;} .hidden { display: none !important; }  .visible { display: block !important;} .uiWebviewHighlight {background-color: #efebc5;}</style></head><body>",cssBackground, cssFontSize, cssFont, cssJustifiedText
                               ];
    
    NSMutableString *contentHtml = [NSMutableString stringWithFormat:@"%@%@%@",
                                    cssForAllHtml,
                                    htmlString,
                                    @"</body></html>"];
    // Add selected book and chapter to nsdefault
    [defaults setObject:[NSString stringWithFormat:@"%ld", bookNumber] forKey:kSelectedBookNumber];
    [defaults setObject:[NSString stringWithFormat:@"%ld", chapterNumber] forKey:kSelectedChapterNumber];
    [defaults setObject:[NSString stringWithFormat:@"%ld", verseNumber] forKey:kSelectedVerseNumber];
    // Load the JavaScript code from the Resources and inject it into the web page
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
    
    // Scroll to Header
    NSString *scrollFunction0 = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[@"0" intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction0];
    [self.webView loadHTMLString:contentHtml baseURL:nil];
    [self HideHeaderAndFooter];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentBook  = [defaults objectForKey:KCurrentBook];
    copyPast = [NSString stringWithFormat:@"%@",((BookModel*)[self.listBookObject objectAtIndex:[currentBook integerValue]]).name];
    
    if ([self.currentYPositionOfAllChapter count] == 0) {
        self.currentYPositionOfAllChapter = [self getAllYChapterPosition:(int)[currentBook integerValue]];
    }
    NSString *roman = @"I";
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"", @"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX",@"X",@"XI", @"XII", @"XIII", @"XIV", @"XV", @"XVI", @"XVII", @"XVIII", @"XIX",@"XX",@"XXI", @"XXII", @"XXIII", @"XXIV", @"XXV", @"XXVI", @"XXVII", @"XXVIII", @"XXIX",@"XXX",@"XXXI", @"XXXII", @"XXXIII", @"XXXIV", @"XXXV", @"XXXVI", @"XXXVII", @"XXXVIII", @"XXXIX",@"XL", nil];
    
    for (int i = ((int)[self.currentYPositionOfAllChapter count]-1); i >= 0; i--) {
        if (scrollView.contentOffset.y >= [[self.currentYPositionOfAllChapter objectAtIndex:i] integerValue]) {
            roman = [NSString stringWithFormat:@"%i", i+1];
            checkRoman = [roman intValue];
            roman = [array objectAtIndex:checkRoman];
            
            NSString *currentChapName = [NSString stringWithFormat:@"%@ %i",((BookModel*)[self.listBookObject objectAtIndex:[currentBook integerValue]]).name, i+1];
            NSString *currentChapNameCopy = [NSString stringWithFormat:@"%@",((BookModel*)[self.listBookObject objectAtIndex:[currentBook integerValue]]).name];
            copyPast = currentChapNameCopy;
            
            
            self.viewForScroll.hidden =  false;
            self.headerView.hidden = true;
            self.lbNameChapterScroll.hidden = false;
            self.lbNameChapterScroll.text =  currentChapName;
            break;
        }
    }
    
    if(scrollView.contentOffset.y
       >=
       (scrollView.contentSize.height - scrollView.frame.size.height)){
        if ([currentBook integerValue] == 0) {
            self.previousBtn.hidden = true;
        } else {
            self.previousBtn.hidden = false;
        }
        if ([currentBook integerValue] == 26) {
            self.nextBtn.hidden = true;
        } else {
            self.nextBtn.hidden = false;
        }
        self.changeBookView.hidden = false;
        self.headerView.hidden = false;
        self.footerView.hidden = false;
        _btnFontSize.hidden = true;
        
    }
    else if(scrollView.contentOffset.y < 0.0){
        NSString *currentBook = [defaults objectForKey:KCurrentBook];
        if ([currentBook integerValue] == 0) {
            self.previousBtn.hidden = true;
        } else {
            self.previousBtn.hidden = false;
        }
        if ([currentBook integerValue] == 26) {
            self.nextBtn.hidden = true;
        } else {
            self.nextBtn.hidden = false;
        }
        self.changeBookView.hidden = false;
        self.headerView.hidden = true;
        self.footerView.hidden = false;
        _btnFontSize.hidden = true;
    } else {
        self.changeBookView.hidden = true;
        _btnFontSize.hidden = false;
    }
}

- (IBAction)changeBook:(id)sender {
    [self.webView.scrollView scrollsToTop];
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long currentBook = [[defaults objectForKey:KCurrentBook] integerValue];
    if (button.tag == 101 && currentBook > 0) {
        [defaults setObject:[NSString stringWithFormat:@"%ld",(currentBook - 1)] forKey:KCurrentBook];
        [self LoadNewBook:(currentBook - 1) withChapter:1 withVerse:1];
    }
    if (button.tag == 102 && currentBook < 26) {
        [defaults setObject:[NSString stringWithFormat:@"%ld", (currentBook +1)] forKey:KCurrentBook];
        [self LoadNewBook:(currentBook + 1) withChapter:1 withVerse:1];
    }
    
}

- (NSMutableArray *)getAllYChapterPosition:(int )bookNumber {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calc" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString: jsCode];
    
    // Scroll to Header
    NSString *scrollFunction0 = [[NSString alloc] initWithFormat:@"scrollYPos(%i)",[@"0" intValue]];
    [self.webView stringByEvaluatingJavaScriptFromString:scrollFunction0];
    
    BookModel *bookModelObj = [self.listBookObject objectAtIndex: bookNumber];
    for (int i=0; i < [bookModelObj.chapter count]; i++) {
        NSString *chapterId = [NSString stringWithFormat:@"%d-%d",bookNumber, (i +1)];
        NSString *jsGetYPos = [[NSString alloc] initWithFormat:@"getYPos('%@')",chapterId];
        NSString *offSetYOfChapter = [self.webView stringByEvaluatingJavaScriptFromString:jsGetYPos];
        if (![offSetYOfChapter isEqualToString:@""]) {
            [result addObject:offSetYOfChapter];
        }
    }
    return result;
}

- (IBAction)btnFontSize:(id)sender {
    if (_viewContentTbSize.hidden == YES) {
        _viewContentTbSize.hidden = NO;
        _viewContentOpacity.hidden = NO;
    }else{
        _viewContentTbSize.hidden = YES;
        _viewContentOpacity.hidden = YES;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* iden = @"tbCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tbCell"];
    }
    cell.textLabel.text = [dataSize objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    if (indexPath.row == 1) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.row == 2) {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    if (indexPath.row == 3) {
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    }
    if (indexPath.row == 4) {
        cell.textLabel.font = [UIFont systemFontOfSize:22];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSize.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _viewContentTbSize.hidden = YES;
    _viewContentOpacity.hidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (indexPath.row) {
        case 0:
            [defaults setObject:@"0" forKey:@"CurrentFontSize"];
            [self editFontSize:@"12"];
            break;
        case 1:
            [defaults setObject:@"1" forKey:@"CurrentFontSize"];
            [self editFontSize:@"14"];
            break;
        case 2:
            [defaults setObject:@"2" forKey:@"CurrentFontSize"];
            [self editFontSize:@"16"];
            break;
        case 3:
            [defaults setObject:@"3" forKey:@"CurrentFontSize"];
            [self editFontSize:@"18"];
            break;
        case 4:
            [defaults setObject:@"4" forKey:@"CurrentFontSize"];
            [self editFontSize:@"20"];
            break;
        default:
            break;
    }
    [_currentYPositionOfAllChapter removeAllObjects];
    [defaults synchronize];
}
- (IBAction)btnHideViewSize:(id)sender {
    _viewContentTbSize.hidden = YES;
    _viewContentOpacity.hidden = YES;
}

@end
