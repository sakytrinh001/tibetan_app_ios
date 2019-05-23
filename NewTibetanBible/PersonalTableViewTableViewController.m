//
//  PersonalTableViewTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/7/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "PersonalTableViewTableViewController.h"

@interface PersonalTableViewTableViewController ()

@end

@implementation PersonalTableViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.elementArr  = [[NSArray alloc] initWithObjects:@"ཟིན་བྲིས།", @"དགའ་ཤོས།", @"གསལ་འདེབས།", @"བྱུང་ཟིན།", nil];
    // Config UI
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
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
    return [self.elementArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"PersonalCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.elementArr objectAtIndex:row];
    if (row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"note.png"];
    }
    if (row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"favorites.png"];
    }
    if (row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"highligh.png"];
    }
    if (row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"history.png"];
    }
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UINavigationController *navagationController = self.navigationController;
    if (row == 0) {
        NoteTableViewController *noteTableViewController = [[NoteTableViewController alloc] initWithNibName:@"NoteTableViewController" bundle:nil];
        noteTableViewController.listNotes = self.listNote;
        noteTableViewController.listBookName = self.listBookName;
        noteTableViewController.viewController = self.viewController;
        [navagationController pushViewController:noteTableViewController animated:YES];
        
    }
    if (row == 1) {
        FavoritesTableViewController *favoritesTableViewController = [[FavoritesTableViewController alloc] initWithNibName:@"FavoritesTableViewController" bundle:nil];
        favoritesTableViewController.listBookName = self.listBookName;
        favoritesTableViewController.listFavorites= self.listFavorite;
        favoritesTableViewController.delegate = self.viewController;
        [navagationController pushViewController:favoritesTableViewController animated:YES];
    }
    if (row == 2) {
        HighLightTableViewController *highLightTableViewController = [[HighLightTableViewController alloc] initWithNibName:@"HighLightTableViewController" bundle:nil];
        highLightTableViewController.listBookName = self.listBookName;
        highLightTableViewController.listHighLight = self.listHighLight;
        highLightTableViewController.delegate = self.viewController;
        [navagationController pushViewController:highLightTableViewController animated:YES];
    }
    if (row == 3) {
        HistoryTableViewController *historyTableViewController = [[HistoryTableViewController alloc] initWithNibName:@"HistoryTableViewController" bundle:nil];
        historyTableViewController.listBookName = self.listBookName;
        historyTableViewController.listHistory = self.listHistory;
        historyTableViewController.delegate = self.viewController;
        [navagationController pushViewController:historyTableViewController animated:YES];
    }
}


- (IBAction)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
