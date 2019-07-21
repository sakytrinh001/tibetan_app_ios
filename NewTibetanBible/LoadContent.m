//
//  LoadContent.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import "LoadContent.h"
#import "BookModel.h"

@implementation LoadContent
+ (NSAttributedString *)readContentOfBook:(NSString *)fileName
{
    NSURL *rtfPath = [[NSBundle mainBundle] URLForResource: fileName withExtension:@"rtf"];
    NSAttributedString * att    =   [[NSAttributedString alloc] initWithURL:rtfPath
                                                                    options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}
                                                         documentAttributes:nil
                                                                      error:nil];
    
    return  att;
}

#pragma process content

+ (NSMutableArray *)splitContentEachLine:(NSString *)stringContent {
    NSMutableArray *resultArray = (NSMutableArray *)[stringContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return resultArray;
}

+ (NSString *)removeWhitespace:(NSString *)line {
    // Remove whitespace at first string if it exits
    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return line;
}

+ (NSString *)getUsfmTag: (NSString *) line {
    // Remove whitespace at first string if it exits
    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //search white space appear first
    NSString *whiteSpace = @" ";
    NSRange searchResult = [line rangeOfString:whiteSpace];
    if (searchResult.location == NSNotFound) {
        return line;
    } else {
        NSString *usfmTag = [line substringToIndex:searchResult.location];
        return usfmTag;
    }
}

+ (NSString *)excludeUsfmTagFromLine: (NSString *) line {
    // Remove whitespace at first string if it exits
    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //search white space appear first
    NSString *whiteSpace = @" ";
    NSRange searchResult = [line rangeOfString:whiteSpace];
    if (searchResult.location == NSNotFound) {
        return @"";
    } else {
        NSString *lineNotIncludeUsfmTag = [line substringFromIndex:searchResult.location];
        return lineNotIncludeUsfmTag;
    }
}

+ (NSString *)excludeVerseFromLine:(NSString *)line {
    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //search white space appear first
    NSString *whiteSpace = @" ";
    NSRange searchResult = [line rangeOfString:whiteSpace];
    if (searchResult.location == NSNotFound) {
        return @"";
    } else {
        NSString *lineNotIncludeUsfmTag = [line substringToIndex:searchResult.location];
        return lineNotIncludeUsfmTag;
    }
}


+ (NSString *)mergeArrToHtmlString:(NSMutableArray *)arr {
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    for (NSString * text in arr)
    {
        [htmlString appendFormat:@" %@", text];
    }
    
    return htmlString;
}

+ (NSString *)splitFooter:(NSString *)line atIndex:(int) i withBookId: (int) bookId inChapter:(int)currentChapter checkSpace:(int)csplitFooterheckSpace{
    NSRange beginFooter = [line rangeOfString: USFM_FOOTER_BEGIN];
    NSRange endFooter  =  [line rangeOfString:USFM_FOOTER_END];
    if (beginFooter.location == NSNotFound && endFooter.location == NSNotFound) {
        if ([line rangeOfString:@"verse"].location == NSNotFound) {
            NSString *verseNumber = [self excludeVerseFromLine:line];
            NSString *result;
            result = [NSString stringWithFormat:@"<span id='verse-%d-%d-%ld'>%@</span>", bookId, currentChapter,(long)[verseNumber integerValue], line];
            NSLog(@"result: %@", result);
            return result;
        }
        NSLog(@"result_line: %@", line);
        return line;
    } else {
        if ([line rangeOfString:@"verse"].location == NSNotFound) {
            NSString *verseNumber = [self excludeVerseFromLine:line];
            NSString *strBeginToFooterBegin = [line substringToIndex:(beginFooter.location)];
            NSString *strFooter = [self getFooterContent:line];
            NSString *strFooterToEnd = [[NSString alloc] init];
            NSString *footerButton = [[NSString alloc] initWithFormat:@"footer-btn-%d-%d",bookId, i];
            NSString *footerContentId = [[NSString alloc] initWithFormat:@"footer-content-%d-%d", bookId, i];
            
            NSString *jsOpenReadFooter = [[NSString alloc] initWithFormat:@"<script>document.getElementById('%@').onclick = function() {if (document.getElementById('%@').className == 'hidden') {document.getElementById('%@').className = 'visible';}else {document.getElementById('%@').className = 'hidden';}}; </script>",footerButton, footerContentId, footerContentId, footerContentId];
            
            strFooterToEnd = [line substringFromIndex:(endFooter.location + USFM_FOOTER_END.length)];
            if ([strFooterToEnd rangeOfString: @"གཙོ་བོ་ཞེས་པར་མ་ཕྱི་ལས་ཁོང་ཞེས་ཁོ་ན༌མཐོང༌།"].location != NSNotFound){
                NSLog(@"result 1: %@", strFooterToEnd);
            }
            NSString *result = @"";
            if ([strFooterToEnd rangeOfString:@"\\f"].location != NSNotFound) {
                NSRange endFooter1  =  [strFooterToEnd rangeOfString:USFM_FOOTER_END];
                NSRange beginFooter1 = [strFooterToEnd rangeOfString: USFM_FOOTER_BEGIN];
                NSString *strFooter1 = [self getFooterContent:strFooterToEnd];
                NSString *strFooterToEnd1 = [line substringFromIndex:(endFooter1.location + USFM_FOOTER_END.length)];
                NSString *strBeginToFooterBegin1 = [strFooterToEnd substringToIndex:(beginFooter1.location)];
                result = [NSString stringWithFormat:@"<span id='verse-%d-%d-%ld'> %@ <button id='%@' style='bottom: 12px; border-radius: 10px;height: 15px;text-align: center;position: relative;'><span style='display: inline-block;bottom: -2px; right: 0;position: absolute;left: 0.0px; font-size: 30px;border-radius: 10px;'>..</span></button><div class='hidden' id = '%@' style='font-size: 12px;display: none;'> <div style='width:250px;height:1px;background-color:#000000; margin-bottom: 5px'></div> <div style='display: inline-block;  width: 15px; height: 15px; border-radius: 50px; border: 1px solid #c3c3c3;'><span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span></div> %@ </div> %@ </span> %@<span id='verse-%d-%d-%ld'> %@ <button id='%@' style='bottom: 12px; border-radius: 10px;height: 15px;text-align: center;position: relative;'><span style='display: inline-block;bottom: -2px; right: 0;position: absolute;left: 0.0px; font-size: 30px;border-radius: 10px;'>..</span></button><div class='hidden' id = '%@' style='font-size: 12px;display: none;'> <div style='width:250px;height:1px;background-color:#000000; margin-bottom: 5px'></div> <div style='display: inline-block;  width: 15px; height: 15px; border-radius: 50px; border: 1px solid #c3c3c3;'><span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span></div> %@ </div> %@ </span> %@", bookId, currentChapter, (long)[verseNumber integerValue],strBeginToFooterBegin,footerButton, footerContentId, strFooter,@"", jsOpenReadFooter, bookId, currentChapter, (long)[verseNumber integerValue],strBeginToFooterBegin1,footerButton, footerContentId, strFooter1,strFooterToEnd1, jsOpenReadFooter];
            }else{
                result = [NSString stringWithFormat:@"<span id='verse-%d-%d-%ld'> %@ <button id='%@' style='bottom: 12px; border-radius: 10px;height: 15px;text-align: center;position: relative;'><span style='display: inline-block;bottom: -2px; right: 0;position: absolute;left: 0.0px; font-size: 30px;border-radius: 10px;'>..</span></button><div class='hidden' id = '%@' style='font-size: 12px;display: none;'> <div style='width:250px;height:1px;background-color:#000000; margin-bottom: 5px'></div> <div style='display: inline-block;  width: 15px; height: 15px; border-radius: 50px; border: 1px solid #c3c3c3;'><span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span></div> %@ </div> %@ </span> %@", bookId, currentChapter, (long)[verseNumber integerValue],strBeginToFooterBegin,footerButton, footerContentId, strFooter,strFooterToEnd, jsOpenReadFooter];
                
            }
            return result;
        }else{
            NSString *strBeginToFooterBegin = [line substringToIndex:(beginFooter.location)];
            NSString *strFooter = [self getFooterContent:line];
            NSString *strFooterToEnd = [[NSString alloc] init];
            NSString *footerButton = [[NSString alloc] initWithFormat:@"footer-btn-%d-%d",bookId, i];
            NSString *footerContentId = [[NSString alloc] initWithFormat:@"footer-content-%d-%d", bookId, i];
        
            NSString *jsOpenReadFooter = [[NSString alloc] initWithFormat:@"<script>document.getElementById('%@').onclick = function() {if (document.getElementById('%@').className == 'hidden') {document.getElementById('%@').className = 'visible';}else {document.getElementById('%@').className = 'hidden';}}; </script>",footerButton, footerContentId, footerContentId, footerContentId];
        
            strFooterToEnd = [line substringFromIndex:(endFooter.location + USFM_FOOTER_END.length)];
            NSString *result = [NSString stringWithFormat:@"%@ <button id='%@' style='bottom: 10px; border-radius: 12px;height: 15px;text-align: center;position: relative;'><span style='display: inline-block;bottom: -2px; right: 0;position: absolute;left: 0.0px;font-size: 30px;border-radius: 10px;'>..</span></button> <div class='hidden' id = '%@' style='font-size: 12px;display: none;'> <div style='width:250px;height:1px;background-color:#000000; margin-bottom: 5px'></div> <div style='display: inline-block;  width: 15px; height: 15px; border-radius: 50px; border: 1px solid #c3c3c3;'><span style='bottom: 7px; right: 0;left: 4.0px; font-size: 14px;text-align: center;position: relative;'>1</span></div> %@ </div> %@ %@",strBeginToFooterBegin, footerButton, footerContentId, strFooter, strFooterToEnd, jsOpenReadFooter];
            NSLog(@"result 2: %@", result);
            return result;
        }
    }
}

+ (NSString *)getFooterContent:(NSString *)line {
    NSRange beginFooter = [line rangeOfString:USFM_FOOTER_BEGIN];
    NSString *strFooterBeginToEnd = [line substringFromIndex:(beginFooter.location + USFM_FOOTER_BEGIN.length)];
    NSRange endFooter = [strFooterBeginToEnd rangeOfString:USFM_FOOTER_END];
    NSString *result = [strFooterBeginToEnd substringToIndex:endFooter.location];
    return  result;
}

+ (NSString *) getChapterNumber: (NSString *)usfmTag inString:(NSString *)line {
    if ([usfmTag isEqualToString:USFM_CHAPTER_NUMBER]) {
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:line];
        stringNoIncludeUsfm = [LoadContent removeWhitespace:stringNoIncludeUsfm];
        return stringNoIncludeUsfm;
    }
    return @"-1";
}

#pragma load javascript
+ (void)loadJs:(NSString *)jsFileName inWebView:(UIWebView *)webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:jsFileName ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
}

#pragma date time
+ (NSString*) getDateTime {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


@end
