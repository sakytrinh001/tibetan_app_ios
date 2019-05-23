//
//  NoteTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/18/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "NoteTableViewController.h"

@interface NoteTableViewController ()<SortTableViewDelegate> {
    NSArray *verseId;
}

@end

@implementation NoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Config UI tableview
    self.title = @"ཟིན་བྲིས།";
    // Get ListHighLight and ListBookName from ViewController
    verseId = [self.listNotes allKeys];
    
    // Add Done button
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"བསྒྲུབས་ཚར།" style:UIBarButtonItemStyleBordered target:self action:@selector(Done:)];
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
        return [self.listNotes count];
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
        static NSString* cellIdentifier = @"NoteCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
        }
        NSUInteger row = [indexPath row];
        NSString *verse = [verseId objectAtIndex:row];
        if (verse) {
            NSArray *verseArray = [verse componentsSeparatedByString:@"-"];
            if (verseArray.count >= 1) {
                NSString *bookName = [self.listBookName objectAtIndex:[[verseArray objectAtIndex:1] integerValue]];
                NSString *bookChapter = [verseArray objectAtIndex:2];
                NSString *bookVerse = [verseArray objectAtIndex:3];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@:%@",bookName, bookChapter, bookVerse];
                cell.detailTextLabel.text = [self.listNotes objectForKey:verse];
            }
            
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

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            NSString *verse = [verseId objectAtIndex:indexPath.row];
            [self.listNotes removeObjectForKey:verse];
            verseId = [self.listNotes allKeys];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // save change of list note
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.listNotes forKey:@"NoteKey"];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *verse = [verseId objectAtIndex:indexPath.row];
        // Open edit screen for edit note content
        EditNoteContentViewController *editViewController = [[EditNoteContentViewController alloc] init];
        editViewController.currentVerseId = verse;
        editViewController.listNote = self.listNotes;
        editViewController.listBookName = self.listBookName;
        editViewController.delegate = self.viewController;
        [self.navigationController pushViewController:editViewController animated:YES];
    }
}


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
