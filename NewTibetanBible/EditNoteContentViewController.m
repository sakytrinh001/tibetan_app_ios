//
//  EditNoteContentViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/18/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "EditNoteContentViewController.h"

@interface EditNoteContentViewController ()

@end

@implementation EditNoteContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *verseArray = [self.currentVerseId componentsSeparatedByString:@"-"];
    NSString *bookName = [self.listBookName objectAtIndex:[[verseArray objectAtIndex:1] integerValue]];
    NSString *bookChapter = [verseArray objectAtIndex:2];
    NSString *bookVerse = [verseArray objectAtIndex:3];
    NSString *titleNote = [NSString stringWithFormat:@"%@ %@:%@",bookName, bookChapter, bookVerse];
    self.title = titleNote;
    NSString *contentNote = [self.listNote objectForKey:self.currentVerseId];
    self.textView.text = contentNote;
    
    // Config ToolBar
    UIBarButtonItem *scrollToNote = [[UIBarButtonItem alloc] initWithTitle:titleNote style:UIBarButtonItemStyleBordered target:self action:@selector(scrollToNoteTapped:)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteNote:)];
    self.toolBar.items = [[NSArray alloc] initWithObjects: scrollToNote, flexSpace, delete,nil];
    // Add Done button
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"བསྒྲུབས་ཚར།" style:UIBarButtonItemStyleBordered target:self action:@selector(Done:)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
}


- (IBAction)Done:(id)sender {
    NSString *contentNote = self.textView.text;
    [self.listNote setObject:contentNote forKey:self.currentVerseId];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.listNote forKey:@"NoteKey"];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)scrollToNoteTapped:(id)sender {
    [self.delegate scrollToNote:self.currentVerseId];
}

- (IBAction)deleteNote:(id)sender {
    [self.listNote removeObjectForKey:self.currentVerseId];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.listNote forKey:@"NoteKey"];
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
