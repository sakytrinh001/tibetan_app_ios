//
//  NoteViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/17/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.currentNoteContent) {
        self.textView.text = self.currentNoteContent;
    }
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnTapped:(id)sender {
    [self.delegate closeNotePopover];
}

- (IBAction)doneBtnTapped:(id)sender {
    NSString *noteContent = self.textView.text;
    [self.listNotes setObject:noteContent forKey:self.currentVerseId];
    [self.delegate closeNotePopover];
}

@end
