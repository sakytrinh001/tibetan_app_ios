//
//  EditNoteContentViewController.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/18/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditNoteContentViewControllerDelegate <NSObject>
- (void)scrollToNote:(NSString *)currentNoteVerseId;
@end

@interface EditNoteContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableDictionary *listNote;
@property (strong, nonatomic) NSArray* listBookName;
@property (strong, nonatomic) NSString* currentVerseId;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) id <EditNoteContentViewControllerDelegate> delegate;

- (IBAction)scrollToNoteTapped:(id)sender;
- (IBAction)deleteNote:(id)sender;
@end
