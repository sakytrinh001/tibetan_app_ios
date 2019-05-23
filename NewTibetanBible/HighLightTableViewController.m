//
//  HighLightTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/21/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "HighLightTableViewController.h"

@interface HighLightTableViewController () {
    NSMutableArray *verseId;
}

@end

@implementation HighLightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Config UI tableview
    self.title = @"གསལ་འདེབས།";
    // Get ListHighLight and ListBookName from ViewController
    verseId = [[NSMutableArray alloc] initWithArray:[self.listHighLight allKeys]];
    NSString *strAll = @"";
    for (int i = 0; i< verseId.count; i++) {
        strAll = [verseId objectAtIndex:i];
        if ([strAll isEqualToString:@""]) {
            [verseId removeObjectAtIndex:i];
        }
    }
    
    
    // Add Done button
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(Done:)];
    
    self.navigationItem.rightBarButtonItem = doneBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma function for add buttons
- (IBAction)toggleEdit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSortMenu:(id)sender {
    UIButton *sortBtn = (UIButton *)sender;
    SortTableViewController *sortController = [[SortTableViewController alloc] initWithStyle:UITableViewStylePlain];
    sortController.delegate = self;
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:sortController];
    popover.border = NO;
    popover.tint = FPPopoverLightGrayTint;
    popover.contentSize = CGSizeMake(280, 150);
    [popover presentPopoverFromView:sortBtn];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return [self.listHighLight count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GroupButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupButtonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GroupButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupButtonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GroupButtonCell"];
        }
        [cell.editBtn addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sortBtn addTarget:self action:@selector(showSortMenu:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString* cellIdentifier = @"HighLightCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
        }
        NSUInteger row = [indexPath row];
        NSString *verse = [verseId objectAtIndex:row];
        if (verse) {
            NSArray *verseArray = [verse componentsSeparatedByString:@"-"];
            NSString *bookName = [self.listBookName objectAtIndex:[[verseArray objectAtIndex:1] integerValue]];
            NSString *bookChapter = [verseArray objectAtIndex:2];
            NSString *bookVerse = [verseArray objectAtIndex:3];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@:%@",bookName, bookChapter, bookVerse];
            cell.detailTextLabel.text = [self.listHighLight objectForKey:verse];
        }
        return cell;
    }
    return nil;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            NSString *verse = [verseId objectAtIndex:indexPath.row];
            [self.listHighLight removeObjectForKey:verse];
            verseId = (NSMutableArray*)[self.listHighLight allKeys];
            [self.delegate removeHighLight:verse];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *verse = [verseId objectAtIndex:indexPath.row];
        [self.delegate scrollToHighLight:verse];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    
#pragma SortTableViewDelegate
- (void)sorted:(NSInteger)row {
    BOOL stoped = FALSE;
    if (row == 1) {
        // Verse Ascending
        NSMutableArray *temp = [verseId mutableCopy];
        if ([temp count] > 0) {
            for (int i=0; i < ([temp count] -1); i++) {
                for (int j=i+1; j < [temp count]; j++) {
                    NSArray *temp1ItemArr = [temp[i] componentsSeparatedByString:@"-"];
                    NSArray *temp2ItemArr = [temp[j] componentsSeparatedByString:@"-"];
                    if ([temp1ItemArr[1] integerValue] > [temp2ItemArr[1] integerValue]) {
                        [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                        stoped = TRUE;
                    }
                    
                    if ([temp1ItemArr[1] integerValue] < [temp2ItemArr[1] integerValue]) {
                        stoped = TRUE;
                    }
                    if (stoped == FALSE && ([temp1ItemArr[2] integerValue] > [temp2ItemArr[2] integerValue])) {
                        [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                        stoped = TRUE;
                    }
                    
                    if ([temp1ItemArr[2] integerValue] < [temp2ItemArr[2] integerValue]) {
                        stoped = TRUE;
                    }
                
                    if (stoped == FALSE && ([temp1ItemArr[3] integerValue] > [temp2ItemArr[3] integerValue])) {
                        [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                    }
                    stoped= FALSE;
                }
            }
        
        verseId = [temp copy];
        [self.tableView reloadData];
        }
    }
    
    if (row == 0) {
        // Verse Descending
        NSMutableArray *temp = [verseId mutableCopy];
        if ([temp count] > 0) {
        for (int i=0; i < ([temp count] -1); i++) {
            for (int j=i+1; j < [temp count]; j++) {
                NSArray *temp1ItemArr = [temp[i] componentsSeparatedByString:@"-"];
                NSArray *temp2ItemArr = [temp[j] componentsSeparatedByString:@"-"];
                if ([temp1ItemArr[1] integerValue] < [temp2ItemArr[1] integerValue]) {
                    [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                    stoped = TRUE;
                }
                
                if ([temp1ItemArr[1] integerValue] > [temp2ItemArr[1] integerValue]) {
                    stoped = TRUE;
                }
                
                if (stoped == FALSE && ([temp1ItemArr[2] integerValue] < [temp2ItemArr[2] integerValue])) {
                    [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                    stoped = TRUE;
                }
                
                if ([temp1ItemArr[2] integerValue] > [temp2ItemArr[2] integerValue]) {
                    stoped = TRUE;
                }
                
                if (stoped == FALSE && ([temp1ItemArr[3] integerValue] < [temp2ItemArr[3] integerValue])) {
                    [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }
                stoped= FALSE;
            }
        }
        
        verseId = [temp copy];
        [self.tableView reloadData];
        }
    }
}

@end
