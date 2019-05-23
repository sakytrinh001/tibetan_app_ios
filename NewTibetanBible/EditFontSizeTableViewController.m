//
//  EditFontSizeTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/26/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "EditFontSizeTableViewController.h"
NSString *const kExtraSmall = @"14";
NSString *const kSmall = @"16";
NSString *const kMedium = @"18";
NSString *const kLarge = @"20";
NSString *const kExtraLarge = @"22";
//NSString *const kCurrentFontSize = @"CurrentFontSize";
@interface EditFontSizeTableViewController ()

@end

@implementation EditFontSizeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listFontSize = [[NSArray alloc] initWithObjects:@"ལྷག་ཏུ་ཆུང་བ།", @"ཆུང་བ།", @"འབྲིང་ཙམ།", @"ཆེ་བ།", @"ལྷག་ཏུ་ཆེ་བ།", nil];
    NSString *const kCurrentFontSize = @"CurrentFontSize";
    // Config TableView Header
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50.0f)];
    
    // Add Button
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneBtn.frame = CGRectMake(screenRect.size.width - 80, 20.0f, 80.0f, 30.0f);
    [doneBtn setTitle:@"བསྒྲུབས་ཚར།" forState:UIControlStateNormal];
    doneBtn.userInteractionEnabled = YES;
    doneBtn.showsTouchWhenHighlighted = TRUE;
    [doneBtn addTarget:self action:@selector(exitScreen) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneBtn];
    
    headerView.backgroundColor = RGB(225, 225, 225);
    self.tableView.tableHeaderView = headerView;
    
    // Get Current Font Size
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: kCurrentFontSize]) {
        self.currentFontSize = [defaults objectForKey: kCurrentFontSize];
    } else {
        self.currentFontSize = @"2";
    }
    
    switch ([self.currentFontSize integerValue]) {
        case 0:
            self.currentRowChecked = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
        case 1:
            self.currentRowChecked = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
        case 2:
            self.currentRowChecked = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
        case 3:
            self.currentRowChecked = [NSIndexPath indexPathForRow:3 inSection:0];
            break;
        case 4:
            self.currentRowChecked = [NSIndexPath indexPathForRow:4 inSection:0];
            break;
        default:
            break;
    }
}


- (void)exitScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listFontSize count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EditFontSizeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.listFontSize objectAtIndex:indexPath.row];
    if (indexPath.row == self.currentRowChecked.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Uncheck the previous checked row
    if(self.currentRowChecked)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.currentRowChecked];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentRowChecked = indexPath;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (indexPath.row) {
        case 0:
            [defaults setObject:@"0" forKey:@"CurrentFontSize"];
            [self.delegate editFontSize:kExtraSmall];
            break;
        case 1:
            [defaults setObject:@"1" forKey:@"CurrentFontSize"];
            [self.delegate editFontSize:kSmall];
            break;
        case 2:
            [defaults setObject:@"2" forKey:@"CurrentFontSize"];
            [self.delegate editFontSize:kMedium];
            break;
        case 3:
            [defaults setObject:@"3" forKey:@"CurrentFontSize"];
            [self.delegate editFontSize:kLarge];
            break;
        case 4:
            [defaults setObject:@"4" forKey:@"CurrentFontSize"];
            [self.delegate editFontSize:kExtraLarge];
            break;
        default:
            break;
    }
    [defaults synchronize];
}


@end
