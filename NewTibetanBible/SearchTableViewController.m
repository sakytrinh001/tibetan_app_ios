//
//  SearchTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/1/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "SearchTableViewController.h"

const int DEFAULT_ROWS_SHOW = 2;
NSString *const lbForSeeMoreCell = @"ད་དུང་འཆར།";
@interface SearchTableViewController () {
    NSMutableArray *allBookNumber;
    NSMutableArray *allList;
    NSMutableArray *allBookNumberCheck;
    NSMutableArray *arrSearchSave;
    NSMutableArray *arrHisSearch;
    int check;
    UIActivityIndicatorView *spinner;
    int checkSearch;
}

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    checkSearch = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchResult = [[NSMutableDictionary alloc] init];
    self.dataForDisplay = [[NSMutableDictionary alloc] init];
    allBookNumberCheck = [[NSMutableArray alloc] init];
    allList = [[NSMutableArray alloc] init];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, screenRect.size.width, 50.0f)];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"བསྒྲུབས་ཚར།" style: UIBarButtonItemStyleBordered target:self action:@selector(done)];
    UIBarButtonItem *mySpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *myTopToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width,40)];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width - 90,40)];
    self.searchBar.delegate = self;
    [myTopToolbar setItems:[NSArray arrayWithObjects:mySpacer,doneBtn, nil] animated:NO];
    myTopToolbar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.01 alpha:1.0];
    [headerView addSubview:myTopToolbar];
    [headerView addSubview:self.searchBar];
    [self.view addSubview:headerView];
    allBookNumber = (NSMutableArray*)[self.searchResult allKeys];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setEstimatedRowHeight:44];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    arrSearchSave = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"] != nil) {
        NSString *strResults = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"]];
        NSCharacterSet *removeCharecter = [NSCharacterSet characterSetWithCharactersInString:@"()\n\""];
        NSString *strSearch = [[strResults componentsSeparatedByCharactersInSet:removeCharecter] componentsJoinedByString:@""];
        NSString* searchStringDidLoad = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableArray *arrReversed = (NSMutableArray*)[searchStringDidLoad componentsSeparatedByString:@","];
        arrHisSearch = (NSMutableArray*)[[arrReversed reverseObjectEnumerator] allObjects];
        check = 1;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (check == 1) {
        return 1;
    }else{
        return [allBookNumber count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (check == 1) {
        return 0.0;
    }else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (check == 1) {
        return 0;
    }else{
    // Get Book Name
        NSString *bookNumber = [allBookNumber objectAtIndex: section];
        NSString *bookName = @"";
        for (int i=0; i <[self.listBookName count]; i++) {
            if (i == [bookNumber intValue] ) {
                check = 0;
                bookName = [self.listBookName objectAtIndex:i];
                break;
            }else{
                check = 1;
            }
        }
        UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 30)];
        viewHeader.backgroundColor = [UIColor whiteColor];
        UILabel *lblHeadertitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        lblHeadertitle.textColor = [UIColor grayColor];
        lblHeadertitle.text = bookName;
        [viewHeader addSubview:lblHeadertitle];
        return viewHeader;
    }
}

- (void) tableView: (UITableView*) tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (check == 1) {
        
    }else{
        CGRect sepFrame = CGRectMake(15, 34, (view.bounds.size.width - 30), 1);
        UIView *seperatorView =[[UIView alloc] initWithFrame:sepFrame];
        seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
        [view addSubview:seperatorView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (check == 1) {
        return arrHisSearch.count;
    }else{
        NSDictionary *dicForSection = [self.dataForDisplay objectForKey:[NSString stringWithFormat:@"%ld", (long)section]];
        NSDictionary *dicForSectionOrigin = [self.searchResult objectForKey:[NSString stringWithFormat:@"%@", [allBookNumber objectAtIndex:section]]];
        int numberOfRowInSection = 0;
        if ([dicForSection count] == DEFAULT_ROWS_SHOW && [dicForSection count] < [dicForSectionOrigin count]) {
            numberOfRowInSection = (int)[dicForSection count] + 1;
        } else if ([dicForSection count] != DEFAULT_ROWS_SHOW){
            numberOfRowInSection = (int)[dicForSection count];
        }
        if (numberOfRowInSection == 0) {
            numberOfRowInSection = 1;
        }
        return numberOfRowInSection;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"SearchCellIdentifier";
    static NSString* cellReadMoreIdentifier = @"ReadMoreCellIdentifier";
    UITableViewCell *cell = nil;
    if (check == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"tbSearch"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tbSearch"];
        }
        NSString *strConvert = [arrHisSearch objectAtIndex:indexPath.row];
        const char *jsonString = [strConvert UTF8String];
        NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
        NSString* searchString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        cell.textLabel.text = searchString;
        
    }else{
        checkSearch = 1;
        NSUInteger section = [indexPath section];
        NSDictionary *dicOriginInSection = [self.searchResult objectForKey:[NSString stringWithFormat:@"%@", [allBookNumber objectAtIndex:indexPath.section]]];
        NSDictionary *dicDataForDisplayInSection = [self.dataForDisplay objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)section]];
        
        if ([dicDataForDisplayInSection count] < [dicOriginInSection count]) {
            if (indexPath.row == DEFAULT_ROWS_SHOW) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellReadMoreIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellReadMoreIdentifier];
                }
                cell.textLabel.text = lbForSeeMoreCell;
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
                }
                NSArray *allVerseForSection = [[dicDataForDisplayInSection allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                if (allVerseForSection.count != 0) {
                    allVerseForSection = [allVerseForSection sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                    }];
                    NSString *verse = [allVerseForSection objectAtIndex:indexPath.row];
                    if (verse) {
                        NSArray *verseArray = [verse componentsSeparatedByString:@"-"];
                        NSString *bookChapter = @"";
                        NSString *bookVerse = @"";
                        if (verseArray.count >= 3) {
                            bookChapter = [verseArray objectAtIndex:2];
                        }
                        if (verseArray.count >= 4) {
                            bookVerse = [verseArray objectAtIndex:3];
                        }
                        
                        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", bookChapter, bookVerse];
                        
                        NSString *str = [[NSString stringWithFormat:@"%@", [dicDataForDisplayInSection objectForKey:verse]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        NSArray *arr = [str componentsSeparatedByString:@" "];
                        if ([str rangeOfString:[NSString stringWithFormat:@"%@", [arr objectAtIndex:1]]].location != NSNotFound) {
                            str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", [arr objectAtIndex:0]] withString:@""];
                            
                        }
                        NSRange range = [str rangeOfString:@"<button id='"];
                        if (range.location != NSNotFound) {
                            str = [str substringToIndex:range.location];
                        }
                        if ([str rangeOfString:@"span"].location == NSNotFound   ) {
                            cell.detailTextLabel.text = [[[str stringByReplacingOccurrencesOfString:@"&nbsp &nbsp " withString:@""] stringByReplacingOccurrencesOfString:@"<br/>" withString:@""] stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
                        }else{
                            NSArray *verseArray = [[str stringByReplacingOccurrencesOfString:@"&nbsp &nbsp " withString:@""] componentsSeparatedByString:@"-"];
                            NSMutableCharacterSet *characterSet =
                            [NSMutableCharacterSet characterSetWithCharactersInString:@"'></div"];
                            
                            NSArray *verseArr = [str componentsSeparatedByString:@"'"];
                            NSString *strVerse = [verseArr objectAtIndex:1];
                            NSArray *arrayLabel = [strVerse componentsSeparatedByString:@"-"];
                            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", [arrayLabel objectAtIndex:2], [arrayLabel objectAtIndex:3]];
                            
                            // Build array of components using specified characters as separtors
                            NSArray *arrayOfComponents = [[verseArray objectAtIndex:3] componentsSeparatedByCharactersInSet:characterSet];
                            NSLog(@"arrayOfComponents: %@", arrayOfComponents);
                            // Create string from the array components
                            cell.detailTextLabel.text = [arrayOfComponents componentsJoinedByString:@""];
                            
                        }
                    }
                }
                }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
            }
            NSArray *allVerseForSection = [[dicDataForDisplayInSection allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            if (allVerseForSection.count != 0) {
                allVerseForSection = [allVerseForSection sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                NSString *verse = [allVerseForSection objectAtIndex:[indexPath row]];
                
                if (verse) {
                    NSArray *verseArray = [verse componentsSeparatedByString:@"-"];
                    NSString *bookChapter = @"";
                    NSString *bookVerse = @"";
                    if (verseArray.count >= 3) {
                        bookChapter = [verseArray objectAtIndex:2];
                        if ([bookChapter isEqualToString:@"tag"]) {
                            bookChapter = @"";
                        }
                    }
                    if (verseArray.count >= 4) {
                        bookVerse = [verseArray objectAtIndex:3];
                    }
                    if (![bookChapter isEqualToString:@""]) {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", bookChapter, bookVerse];
                        NSString *str = [[NSString stringWithFormat:@"%@", [dicDataForDisplayInSection objectForKey:verse]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        NSArray *arr = [str componentsSeparatedByString:@" "];
                        if (arr.count > 1) {
                            if ([str rangeOfString:[NSString stringWithFormat:@"%@", [arr objectAtIndex:1]]].location != NSNotFound) {
                                str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", [arr objectAtIndex:0]] withString:@""];
                            }
                        }
                        NSRange range = [str rangeOfString:@"<button id='"];
                        if (range.location != NSNotFound) {
                            str = [str substringToIndex:range.location];
                        }
                        if ([str rangeOfString:@"span"].location == NSNotFound) {
                            cell.detailTextLabel.text = [[[str stringByReplacingOccurrencesOfString:@"&nbsp &nbsp " withString:@""] stringByReplacingOccurrencesOfString:@"<br/>" withString:@""] stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
                        }else{
                            NSArray *verseArray = [[str stringByReplacingOccurrencesOfString:@"&nbsp &nbsp " withString:@""] componentsSeparatedByString:@"-"];
                            NSMutableCharacterSet *characterSet =
                            [NSMutableCharacterSet characterSetWithCharactersInString:@"'></div"];
                            // Build array of components using specified characters as separtors
                            NSArray *arrayOfComponents = [[verseArray objectAtIndex:3] componentsSeparatedByCharactersInSet:characterSet];
                            // Create string from the array components
                            cell.detailTextLabel.text = [arrayOfComponents componentsJoinedByString:@""];
                        }
                    }   
                }
            }
            
        }
    }
    
    return cell;
}

-(void) hideSpiner{
    [spinner stopAnimating];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    BOOL stopped = NO;
    check = 0;
    NSString *results = self.searchBar.text;
    //Remove white space from the left string
    NSString* searchString = [results stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.searchBar.text = searchString;
    
    NSArray *arrSave;
    NSArray *arrHis;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"] != nil) {
        arrSearchSave = [@[[[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"]] mutableCopy];
        NSString *strResults = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"]];
        NSCharacterSet *removeCharecter = [NSCharacterSet characterSetWithCharactersInString:@"()\n\""];
        NSString *strSearch = [[strResults componentsSeparatedByCharactersInSet:removeCharecter] componentsJoinedByString:@""];
        NSString* searchStringHis = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        arrHis = (NSMutableArray*)[searchStringHis componentsSeparatedByString:@","];
        
    }
    //add object
    [arrSearchSave addObject:searchString];
    
    NSArray *array = [NSArray arrayWithObjects:searchString, nil];
    NSString *strResults = [NSString stringWithFormat:@"%@",array];
    NSCharacterSet *removeCharecter = [NSCharacterSet characterSetWithCharactersInString:@"()\n\""];
    NSString *strSearch = [[strResults componentsSeparatedByCharactersInSet:removeCharecter] componentsJoinedByString:@""];
    NSString* resultsString = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    arrSave = (NSMutableArray*)[resultsString componentsSeparatedByString:@","];
    
    if (arrHis.count >0) {
        if (checkSearch == 0) {
            for (int save = 0; save< arrSave.count; save++) {
                for (int his = 0; his< arrHis.count; his++) {
                    if ([[arrSave objectAtIndex:save] isEqualToString:[[arrHis objectAtIndex:his] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                        checkSearch = 1;
                        break;
                    }
                }
            }
        }
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:arrSearchSave forKey:@"arrSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        checkSearch = 1;
    }
    
    if (checkSearch == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:arrSearchSave forKey:@"arrSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    for (int i=0; i < [self.listBookObject count]; i++) {
        @autoreleasepool {
            NSMutableDictionary *resultTmp = [[NSMutableDictionary alloc] init];
            BookModel *bookModel = [self.listBookObject objectAtIndex:i];
            for (int j=0; j < [bookModel.arrBookSeperateLine count]; j ++) {
                NSString *currentLine = [bookModel.arrBookSeperateLine objectAtIndex:j];
                if ([currentLine rangeOfString:@"verse"].location == NSNotFound) {
                    stopped = YES;
                }
                if (stopped == NO) {
                    if ([currentLine rangeOfString:searchString].location != NSNotFound) {
                        NSString *verseId = [self getVerseIdFromLine:currentLine];
                        NSString *verseContent = [self getVerseContent:currentLine];
                        if (![verseId isEqualToString:@"usfm-m-tag"]) {
                            [resultTmp setObject:verseContent forKey:verseId];
                        }
                    }
                }
                stopped = NO;
            }
            if ([resultTmp count] > 0) {
                [self.searchResult setObject:resultTmp forKey:[NSString stringWithFormat:@"%d", i]];
            }
            resultTmp = nil;
        }
    }
    
    allBookNumber = (NSMutableArray*)[self sortBookNumber:[self.searchResult allKeys]];
    for (int i=0; i < [allBookNumber count]; i++) {
        int count = 0;
        NSMutableDictionary *dicForBook =  [self.searchResult objectForKey:[NSString stringWithFormat:@"%@", [allBookNumber objectAtIndex:i]]];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        for (NSString *key in dicForBook) {
            [temDic setObject:[dicForBook objectForKey:key] forKey:key];
            count++;
            if (count == DEFAULT_ROWS_SHOW) {
                break;
            }
        }
        [self.dataForDisplay setObject:temDic forKey:[NSString stringWithFormat:@"%d", i]];
        temDic = nil;
    }
    [self.searchBar resignFirstResponder];
    
    if (_searchResult.count != 0) {
        [self.tableView reloadData];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (check == 1) {
        NSString *strConvert = [arrHisSearch objectAtIndex:indexPath.row];
        
        const char *jsonString = [strConvert UTF8String];
        NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
        self.searchBar.text = str;
        
        //loading
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor blackColor];
        spinner.center = self.view.center;
        spinner.tag = 12;
        [self.tableView addSubview:spinner];
        [spinner startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(hideSpiner)
                                       userInfo:nil
                                        repeats:NO];
        
        [self searchBarSearchButtonClicked:_searchBar];
        checkSearch = 1;
    }else{
        if ([cell.textLabel.text isEqualToString:lbForSeeMoreCell]) {
            NSDictionary *originDicInSection = [self.searchResult objectForKey:[NSString stringWithFormat:@"%@", [allBookNumber objectAtIndex:indexPath.section]]];
            [self.dataForDisplay setObject:originDicInSection forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
            [self.tableView reloadData];
            return;
        }
        NSDictionary *dicForSection = [self.searchResult objectForKey:[NSString stringWithFormat:@"%@", [allBookNumber objectAtIndex:indexPath.section]]];
        NSArray *allVerseForSection = [dicForSection allKeys];
        NSString *verse = [allVerseForSection objectAtIndex:indexPath.row];
        NSArray *arrVerseCell = [cell.textLabel.text componentsSeparatedByString:@":"];
        NSArray *arrVerse = [verse componentsSeparatedByString:@"-"];
        verse = [NSString stringWithFormat:@"%@-%@-%@-%@", arrVerse[0], arrVerse[1], arrVerseCell[0], arrVerseCell[1]];
        [self.delegate scrollToSearch:verse];
    }
}


- (NSString *)getVerseIdFromLine:(NSString *)currentLine {
    NSRange begin = [currentLine rangeOfString:@"'"];
    NSString *beginText = [currentLine substringFromIndex:begin.location +1];
    NSRange end = [beginText rangeOfString:@"'"];
    NSString *endText = [beginText substringToIndex:end.location];
    return endText;
}

- (NSString *)getVerseContent:(NSString *)currentLine {
    NSRange begin2 = [currentLine rangeOfString:@"'>"];
    NSString *beginText2 = [currentLine substringFromIndex:begin2.location + 2];
    beginText2 = [beginText2 stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    return beginText2;
}

- (NSArray *)sortBookNumber:(NSArray *)arrUnSorted {
    NSMutableArray *sortedArr = [arrUnSorted mutableCopy];
    if ([sortedArr count] > 0) {
        for (int i=0; i < ([sortedArr count] -1); i++) {
            for (int j=i+1; j < [sortedArr count]; j++) {
                if ([sortedArr[j] integerValue] < [sortedArr[i] integerValue] ) {
                    [sortedArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    return [sortedArr copy];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_searchBar.text.length == 0) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"] != nil) {
            NSString *strResults = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"arrSearch"]];
            NSCharacterSet *removeCharecter = [NSCharacterSet characterSetWithCharactersInString:@"()\n\""];
            NSString *strSearch = [[strResults componentsSeparatedByCharactersInSet:removeCharecter] componentsJoinedByString:@""];
            NSString* searchStringBar = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableArray *arrReversed = (NSMutableArray*)[searchStringBar componentsSeparatedByString:@","];
            arrHisSearch = (NSMutableArray*)[[arrReversed reverseObjectEnumerator] allObjects];
            
            check = 1;
        }
        [self.tableView reloadData];
    }
}

@end
