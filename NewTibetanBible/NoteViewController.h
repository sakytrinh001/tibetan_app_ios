//
//  NoteViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/17/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoteViewControllerDelegate <NSObject>
- (void)closeNotePopover;
@end
@interface NoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel* titleView;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *done;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id <NoteViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *listNotes;
@property (strong, nonatomic) NSString* currentVerseId;
@property (strong, nonatomic) NSString* currentNoteContent;

-(IBAction)doneBtnTapped:(id)sender;
-(IBAction)cancelBtnTapped:(id)sender;

@end
