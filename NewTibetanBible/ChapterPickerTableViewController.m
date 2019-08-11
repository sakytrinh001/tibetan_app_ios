//
//  ChapterPickerTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/27/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import "ChapterPickerTableViewController.h"
#import "IntroAppViewController.h"

@interface ChapterPickerTableViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *arrayForBool;
    UICollectionView *_collectionView;
    NSMutableArray *content;
    int checkBottom;
    int scrollCheck;
    
}

@end

@implementation ChapterPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray arrayWithObjects:
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    }
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, 248, 480) collectionViewLayout:layout];
    }else{
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 480) collectionViewLayout:layout];
    }
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.tableView.userInteractionEnabled = NO;
    self.tableView.allowsSelection = NO;
    checkBottom = 0;
    scrollCheck = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listBookNameFull count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(id)initWithStyle:(UITableViewStyle)style listBookName:(NSMutableArray *)bookNameArr listChapter:(NSMutableArray *)chapterName
{
    _listChapterName = [[NSMutableArray alloc] init];
    if (_listChapterName != chapterName) {
        [_listChapterName addObject:@"དམ་པའི་གསུང་རབ་བོད་འགྱུར་གྱི་བྱུང་རབས།"];
        [_listChapterName addObject:@"སྔོན་དུ་འགྲོ་བའི་གཏམ།"];
        [_listChapterName addObject:@"ཞལ་ཆད་ཕྱི་མ།"];
        for (int i = 0; i < chapterName.count; i++) {
            [_listChapterName addObject: [chapterName objectAtIndex:i]];
        }
        [_listChapterName addObject:@"དམ་པའི་གསུང་རབ་ལས་བྱུང་བའི་མིང་བརྡ་སྐོར་ཞིག"];
    }
    
    _listBookNameFull = [[NSMutableArray alloc] init];
    if (_listBookNameFull != bookNameArr) {
        
        [_listBookNameFull addObject:@"དམ་པའི་གསུང་རབ་བོད་འགྱུར་གྱི་བྱུང་རབས།"];
        [_listBookNameFull addObject:@"སྔོན་དུ་འགྲོ་བའི་གཏམ།"];
        [_listBookNameFull addObject:@"ཞལ་ཆད་ཕྱི་མ།"];
        for (int i = 0; i < bookNameArr.count; i++) {
            [_listBookNameFull addObject: [bookNameArr objectAtIndex:i]];
        }
        [_listBookNameFull addObject:@"དམ་པའི་གསུང་རབ་ལས་བྱུང་བའི་མིང་བརྡ་སྐོར་ཞིག"];
    }
    
    if ([super initWithStyle:style] != nil) {
        
        //Initialize the array
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;
        
        //Calculate how wide the view should be by finding how
        //wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *chapterItem in _listBookNameFull) {
            if (![chapterItem isEqualToString:@"དམ་པའི་གསུང་རབ་བོད་འགྱུར་གྱི་བྱུང་རབས།"] && ![chapterItem isEqualToString:@"སྔོན་དུ་འགྲོ་བའི་གཏམ།"] && ![chapterItem isEqualToString:@"ཞལ་ཆད་ཕྱི་མ།"]) {
                CGSize labelSize = [chapterItem sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];
                if (labelSize.width > largestLabelWidth) {
                    largestLabelWidth = labelSize.width;
                }
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        //Set the property to tell the popover container how big this view will be.
        self.preferredContentSize = CGSizeMake(popoverWidth, 500);
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    //    [self.tableView reloadData];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50.0f)];
        
        // Add Button
        UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSString *buttonLabel = @"ཐོ་གསུབ།";
        CGSize labelSize = [buttonLabel sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];
        doneBtn.frame = CGRectMake(screenRect.size.width - labelSize.width - 10, 22.0f, labelSize.width, 20.0f);
        [doneBtn setTitle:@"ཐོ་གསུབ།" forState:UIControlStateNormal];
        doneBtn.userInteractionEnabled = YES;
        doneBtn.showsTouchWhenHighlighted = TRUE;
        [doneBtn addTarget:self action:@selector(exitChapterTapped) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:doneBtn];
        
        headerView.backgroundColor = RGB(225, 225, 225);
        self.tableView.tableHeaderView = headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-70, 50)];
    
    headerString.text =  [self.listBookNameFull objectAtIndex:section];
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerString setFont:[UIFont systemFontOfSize:18]];//change
    if (section == 2) {
        headerString.textColor      = [self colorWithHexString:@"CFB53B"];//change
    }
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section <= 2 || indexPath.section == self.listBookNameFull.count - 1) {
        return 0;
    }
    CGFloat screenWidth = self.view.frame.size.width;
    int sec = 0;
    if (checkBottom == 0) {
        if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"section"] == indexPath.section) {
                if (screenWidth <= 320) {
                    int laydu = content.count%5;
                    int chiahet = (int)content.count/5;
                    if (laydu > 0) {
                        laydu = 50;
                    }
                    if (laydu == 0) {
                        laydu = 10;
                    }
                    sec = laydu+chiahet*50;
                }
                if (screenWidth > 320 && screenWidth <= 375) {
                    int laydu = content.count%6;
                    int chiahet = (int)content.count/6;
                    if (laydu > 0) {
                        laydu = 70;
                    }
                    if (laydu == 0) {
                        laydu = 10;
                    }
                    sec = laydu+chiahet*50;
                }
                if (screenWidth > 375 && screenWidth <= 414) {
                    int laydu = content.count%6;
                    int chiahet = (int)content.count/6;
                    if (laydu > 0) {
                        laydu = 50;
                    }
                    sec = laydu+chiahet*60;
                }
            }
        }
    }
    NSLog(@"%d", sec);
    return sec;
}


- (void)exitChapterTapped {
    if (_delegate != nil) {
        [_delegate exitChapterPicking];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ChapterNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell removeFromSuperview];
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        tableView.scrollEnabled = true;
    }
    else{
        content = [self.listChapterName objectAtIndex:indexPath.section];
        [cell addSubview:_collectionView];
        cell.textLabel.text = @"";
        [_collectionView reloadData];
    }
    
    return cell;
}

#pragma mark - Table view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    checkBottom = 1;
    for (int i = 0; i < arrayForBool.count; i++) {
        [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section forKey:@"section"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    checkBottom = 0;
    if (indexPath.section <= 2 || indexPath.section == _listBookNameFull.count - 1) {
        IntroAppViewController *intro = [[IntroAppViewController alloc]
                                         initWithNibName:@"IntroAppViewController" bundle:nil];
        if (indexPath.section < 2) {
            
            intro.introS = [NSString stringWithFormat:@"%li", (long)indexPath.section];
            [self presentViewController: intro animated:true completion:^{}];
        }
        if (indexPath.section == _listBookNameFull.count - 1){
            intro.introS = @"2";
            [self presentViewController: intro animated:true completion:^{}];
        }
        
        return;
    }
    
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (indexPath.section + 1 == arrayForBool.count) {
                [self.tableView setContentOffset:CGPointMake(0, 2*[UIScreen mainScreen].bounds.size.height)];
                if (scrollCheck == 0) {
                    scrollCheck = (int)(indexPath.section +1);
                }else{
                    scrollCheck = 0;
                }
            }
        }else{
            if (indexPath.section + 1 == arrayForBool.count) {
                [self.tableView setContentOffset:CGPointMake(0, [UIScreen mainScreen].bounds.size.height-80)];
                if (scrollCheck == 0) {
                    scrollCheck = (int)(indexPath.section + 1);
                }else{
                    scrollCheck = 0;
                }
            }
        }
        
    }
}



#pragma mark - Collectionview
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int numberOfCellInRow = 8;
    CGFloat cellWidth =  self.view.frame.size.width/numberOfCellInRow;
    return CGSizeMake(cellWidth, cellWidth);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%i", (int)indexPath.row+1]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:img];
    cell.backgroundView.contentMode = UIViewContentModeCenter;
    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //    [cell.backgroundView sizeToFit];
    cell.backgroundView.clipsToBounds = YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate != nil) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [_delegate selectChapter:indexPath];
            });
        });
    }
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
