//
//  CrossIconTableViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/30/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import "CrossIconTableViewController.h"

@interface CrossIconTableViewController ()

@end

@implementation CrossIconTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemArray = [[NSArray alloc] initWithObjects:@"TIBETANBIBLE.COM",@"ལན་སློག",@"རོགས་རམ།", nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50.0f)];
        
        // Add Button
        UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneBtn.frame = CGRectMake(screenRect.size.width - 80, 18.0f, 80.0f, 30.0f);
        [doneBtn setTitle:@"བསྒྲུབས་ཚར།" forState:UIControlStateNormal];
        doneBtn.userInteractionEnabled = YES;
        doneBtn.showsTouchWhenHighlighted = TRUE;
        [doneBtn addTarget:self action:@selector(exitCrossSetting) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:doneBtn];
        
        headerView.backgroundColor = RGB(225, 225, 225);
        self.tableView.tableHeaderView = headerView;

    }
    
}

- (void)exitCrossSetting {
    if (_delegate != nil) {
        [_delegate exitCrossSettingView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        
        //Initialize the array
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [self.itemArray count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how
        //wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *item in self.itemArray) {
            //Checks size of text using the default font for UITableViewCell's textLabel.
            CGSize labelSize = [item sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 20;
        
        //Set the property to tell the popover container how big this view will be.
        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CrossItemNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.itemArray objectAtIndex:indexPath.row];
    
    return cell;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectCrossItem:indexPath.row];
    }
    
}


@end
