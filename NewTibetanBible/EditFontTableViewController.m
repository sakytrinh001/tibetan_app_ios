//
//  EditFontTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/29/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "EditFontTableViewController.h"

@interface EditFontTableViewController ()

@end

@implementation EditFontTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listFontName = [[NSArray alloc] initWithObjects:@"དབུ་ཅན།", @"འཁྱུག་ཡིག", @"དཔེ་ཚུགས།", nil];
    
    // Config TableView Header
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50.0f)];
    
    // Add Button
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    if ([defaults objectForKey: @"CurrentFont"]) {
        self.currentFontName = [defaults objectForKey: @"CurrentFont"];
    } else {
        self.currentFontName = @"0";
    }
    
    switch ([self.currentFontName integerValue]) {
        case 0:
            self.currentRowChecked = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
        case 1:
            self.currentRowChecked = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
        case 2:
            self.currentRowChecked = [NSIndexPath indexPathForRow:2 inSection:0];
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
    return [self.listFontName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EditFontCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.listFontName objectAtIndex:indexPath.row];
    if (indexPath.row == self.currentRowChecked.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Uncheck the previous checked row
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"keyFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            [defaults setObject:@"0" forKey:@"CurrentFont"];
            [self.delegate editFont:@"SambhotaDege"];
            [[NSUserDefaults standardUserDefaults] setObject:@"SambhotaDege" forKey:@"keyFont"];
            break;
        case 1:
            [defaults setObject:@"1" forKey:@"CurrentFont"];
            [self.delegate editFont:@"Monlam Uni Choukmatik"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Monlam Uni Choukmatik" forKey:@"keyFont"];
            break;
        case 2:
            [defaults setObject:@"2" forKey:@"CurrentFont"];
            [self.delegate editFont:@"Monlam Uni PayTsik"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Monlam Uni PayTsik" forKey:@"keyFont"];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
