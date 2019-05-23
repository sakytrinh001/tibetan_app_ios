//
//  BookModel.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadContent.h"

#define kCSS_CHAP_LABEL @"chap-label"
#define kCSS_MAJOR_TITLE @"major-title"
#define KCSS_BOOK_NAME @"book-name"
#define KCSS_BOOK_TITLE @"book-title"
#define kCSS_CHAP_NUMBER @"chap-number"
#define kCSS_SECTION_HEADING @"section-heading"


@interface BookModel : NSObject <NSCoding>
@property (strong, nonatomic) NSMutableArray *arrBookSeperateLine;
@property (strong, nonatomic) NSMutableOrderedSet *chapter;
@property (strong, nonatomic) NSMutableOrderedSet *chapterLabel;
//@property (strong, nonatomic) NSMutableArray *positionYChapter;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortenedName;
@property (strong, nonatomic) NSString *verseTiber;
@property int checkSpace;
@property int checkVerse;
@property int checkQuote;

- (id)initWithUrlFile:(NSString *)fileName;
- (void)progressUsfmTag: (NSString *)usfmTag atIndex:(int) i withBookId:(int) bookId inChapter:(int)currentChapter;
@end
