//
//  LoadContent.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// USFM tag define
#define USFM_BOOK_NAME  @"\\id"
#define USFM_BOOK_SHORTENED_NAME  @"\\h"
#define USFM_MAJOR_TITLE @"\\mt"
#define USFM_CHAPTER_NUMBER @"\\c"
#define USFM_CHAPTER_LABEL @"\\cl"
#define USFM_SECTION_HEADING @"\\s"
#define USFM_NORMAL_PARARAPH @"\\p"
#define USFM_VERSE @"\\v"
#define USFM_FOOTER_BEGIN  @"\\f + \\ft "
#define USFM_FOOTER_BEGIN2 @"\\f + "
#define USFM_FOOTER_END    @"\\f*"
#define USFM_OPEN_QUOTE @"\\q1"
#define USFM_M_TAG @"\\m"

#define USFM_CENTER @"\\periph"
#define USFM_INDENT @"\\p1"
#define USFM_LEFT_ALIGNE @"\\is"
#define USFM_NORMAL_PARARAPHNEW @"\\ipi"

#define STR_4_WHITE_SPACE @"&nbsp &nbsp &nbsp &nbsp"
#define STR_2_WHITE_SPACE @"&nbsp &nbsp &nbsp"
#define STR_1_WHITE_SPACE @"&nbsp &nbsp"


@interface LoadContent : NSObject
+ (NSAttributedString *)readContentOfBook:(NSString *)fileName;
+ (NSArray *)splitContentEachLine:(NSString *)stringContent;
+ (NSString *)getUsfmTag:(NSString *) line;
+ (NSString *)excludeUsfmTagFromLine:(NSString *) line;
+ (NSString *)mergeArrToHtmlString:(NSMutableArray *)arr;
+ (NSString *)removeWhitespace: (NSString *)line;
+ (void)loadJs:(NSString *)jsFileName inWebView:(UIWebView *)webView;
+ (NSString *)splitFooter:(NSString *)line atIndex:(int) i withBookId: (int) bookId inChapter:(int)currentChapter checkSpace:(int)csplitFooterheckSpace;
+ (NSString *)getFooterContent: (NSString *)line;
+ (NSString *) getDateTime;
+ (NSString *) getChapterNumber: (NSString *)usfmTag inString:(NSString *)line;
+ (NSString *)excludeVerseFromLine:(NSString *) line;
@end
