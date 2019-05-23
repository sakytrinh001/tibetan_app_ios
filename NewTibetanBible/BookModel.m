//
//  BookModel.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 11/24/15.
//  Copyright © 2015 Cuong Nguyen The. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
- (id)initWithUrlFile:(NSString *)fileName {
    if ((self = [super init])) {
        NSAttributedString *tmp = [LoadContent readContentOfBook:fileName];
        self.arrBookSeperateLine = (NSMutableArray*)[LoadContent splitContentEachLine:[tmp string]];
        self.chapter = [[NSMutableOrderedSet alloc] init];
        self.chapterLabel = [[NSMutableOrderedSet alloc] init];
    }
    _checkVerse = 0;
    return self;
}

- (void)progressUsfmTag: (NSString *)usfmTag atIndex:(int) i withBookId:(int) bookId inChapter:(int)currentChapter{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    if ([usfmTag isEqualToString:USFM_BOOK_NAME]) {
        //get book name
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNotIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        self.name = stringNotIncludeUsfm;
        NSString *result = [[NSString alloc] initWithFormat:@"<div class='%@' style='text-align: center; -moz-user-select: -moz-none; -khtml-user-select: none; -webkit-user-select: none;ms-user-select: none;user-select: none;'><b> %@ </b></div>",KCSS_BOOK_NAME,@""];
        self.arrBookSeperateLine[i] = result;
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_BOOK_SHORTENED_NAME]) {
        //get shortened book name
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNotIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        self.shortenedName = stringNotIncludeUsfm;
        NSString *result = [[NSString alloc] initWithFormat:@"<br /><span class='%@' style='text-align: center; display: none;'><b> %@ </b></span>",KCSS_BOOK_TITLE,stringNotIncludeUsfm];
        self.arrBookSeperateLine[i] = result;
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_MAJOR_TITLE]) {
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        NSString *result = [[NSString alloc] initWithFormat:@"<div class='%@' style='text-align: center; -moz-user-select: -moz-none; -khtml-user-select: none; -webkit-user-select: none;ms-user-select: none;user-select: none;'><b> %@ </b></div>",kCSS_MAJOR_TITLE,stringNoIncludeUsfm ];
        self.arrBookSeperateLine[i] = result;
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_CHAPTER_NUMBER]) {
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        stringNoIncludeUsfm = [LoadContent removeWhitespace:stringNoIncludeUsfm];
        NSString *result = [[NSString alloc] initWithFormat:@"<div class='%@' id='c-%@-%@' style='visibility: hidden;'> %@ </div>",kCSS_CHAP_NUMBER,[NSString stringWithFormat:@"%d",bookId], stringNoIncludeUsfm, stringNoIncludeUsfm];
        self.arrBookSeperateLine[i] = result;
        [self.chapter addObject:stringNoIncludeUsfm];
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_CHAPTER_LABEL] || [usfmTag isEqualToString:USFM_CENTER]){
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        NSString *result = [[NSString alloc] initWithFormat:@"<div class='%@' style='text-align: center; -moz-user-select: -moz-none; -khtml-user-select: none; -webkit-user-select: none;ms-user-select: none;user-select: none;'> <b> %@ </b></div>",kCSS_CHAP_LABEL,stringNoIncludeUsfm];
        self.arrBookSeperateLine[i] = result;
        [self.chapterLabel addObject:stringNoIncludeUsfm];
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_SECTION_HEADING]) {
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        NSString *result = [[NSString alloc] initWithFormat:@"<br /><br /><span class='%@' style=' -moz-user-select: -moz-none; -khtml-user-select: none; -webkit-user-select: none;ms-user-select: none;user-select: none;'><b> %@ </b></span>",kCSS_SECTION_HEADING,stringNoIncludeUsfm ];
        self.arrBookSeperateLine[i] = result;
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_NORMAL_PARARAPH]  || [usfmTag isEqualToString:USFM_NORMAL_PARARAPHNEW]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CHECK"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _checkSpace = i;
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        if ([stringNoIncludeUsfm isEqualToString:@""]) {
            NSString *result = @"";
            result = [[NSString alloc] initWithFormat:@"<br/> &nbsp &nbsp"];
            self.arrBookSeperateLine[i] = result;
        } else {
            NSString *result = [[NSString alloc] initWithFormat:@"<p> %@ </p>",stringNoIncludeUsfm];
            self.arrBookSeperateLine[i] = result;
        }
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_VERSE] || [usfmTag isEqualToString:USFM_LEFT_ALIGNE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CHECK"];
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        stringNoIncludeUsfm = [LoadContent splitFooter:stringNoIncludeUsfm atIndex:i withBookId:bookId inChapter:currentChapter checkSpace:_checkSpace];
        int v;
        v = i - (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"check"];
        if (v == 1) {
            _checkQuote = 0;
            NSArray *ar = [tmp componentsSeparatedByString:@" "];
            for (NSString *strCheckP in array) {
                if ([ar[1] isEqualToString:strCheckP]) {
                    stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'> %@", ar[1]]  withString:[NSString stringWithFormat:@"'> &nbsp%@", ar[1]]];
                    v = 0;
                    break;
                }
            }
            if ([ar[1] isEqualToString:@"54-55"] || [ar[1] isEqualToString:@"74-75"]) {
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'> &nbsp%@", ar[1]] withString:[NSString stringWithFormat:@"'> &nbsp%@&nbsp&nbsp", ar[1]]];
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'> %@", ar[1]] withString:[NSString stringWithFormat:@"'> %@ &nbsp", ar[1]]];
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'>  %@", ar[1]] withString:[NSString stringWithFormat:@"'>%@ &nbsp &nbsp", ar[1]]];
            }else{
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'> &nbsp%@", ar[1]] withString:[NSString stringWithFormat:@"'> &nbsp%@ %@", ar[1], STR_4_WHITE_SPACE]];
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'> %@", ar[1]] withString:[NSString stringWithFormat:@"'> %@ %@", ar[1], STR_4_WHITE_SPACE]];
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'>  %@", ar[1]] withString:[NSString stringWithFormat:@"'>  %@ %@", ar[1], STR_4_WHITE_SPACE]];
                stringNoIncludeUsfm = [stringNoIncludeUsfm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"'>  1 &nbsp &nbsp &nbsp &nbsp ཐོག་མར་བཀའ་"] withString:[NSString stringWithFormat:@"'> &nbsp1 &nbsp &nbsp &nbsp &nbsp ཐོག་མར་བཀའ་"]];
                
            }
            
            self.arrBookSeperateLine[i] = @"";
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@?",stringNoIncludeUsfm] forKey:@"CHECK"];
            _checkQuote = 0;
        }else{
            self.arrBookSeperateLine[i] = stringNoIncludeUsfm;
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CHECK"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"check"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_OPEN_QUOTE]) {
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *result;
        result = [[NSString alloc] initWithFormat:@""];
        if ([tmp isEqualToString:@"\\q1"]) {
            if (_checkQuote == 1) {
                result = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KQ"] stringByReplacingOccurrencesOfString:@"</script>?" withString:@"</script>"];
                result = [result stringByReplacingOccurrencesOfString:@"</span>?" withString:@"</span>"];
            }
            if (_checkQuote == 0) {
//                result = [NSString stringWithFormat:@"<div class='usfm-m-tag' style='text-align: left'> %@</div>",[[NSUserDefaults standardUserDefaults] objectForKey:@"CHECK"]];
                result = [NSString stringWithFormat:@"<div> %@</div>",[[NSUserDefaults standardUserDefaults] objectForKey:@"CHECK"]];
                result = [result stringByReplacingOccurrencesOfString:@"</span>?" withString:@"</span>"];
                result = [result stringByReplacingOccurrencesOfString:@"</script>?" withString:@"</script>"];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"KQ"] length] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CHECK"] length] == 0) {
                result = @"";
            }
        }else{
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHECK"];
            NSString *stringNoIncludeUSfm = [LoadContent excludeUsfmTagFromLine:tmp];
            if ([str rangeOfString:@"?"].location == NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"</span>" withString:@"</span>?"];
            }
            str = [str stringByReplacingOccurrencesOfString:@"</span>?" withString:[NSString stringWithFormat:@"<br/> %@ &nbsp %@ %@</span>?",STR_1_WHITE_SPACE, STR_2_WHITE_SPACE, stringNoIncludeUSfm]];
            str = [str stringByReplacingOccurrencesOfString:@"</span> <script>" withString:[NSString stringWithFormat:@"<br/> %@ &nbsp %@ %@</span> <script>",STR_1_WHITE_SPACE, STR_2_WHITE_SPACE, stringNoIncludeUSfm]];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CHECK"] length] == 0) {
                str = [LoadContent splitFooter:[NSString stringWithFormat:@"%@ %@ %@", STR_4_WHITE_SPACE, STR_1_WHITE_SPACE, stringNoIncludeUSfm] atIndex:i withBookId:bookId inChapter:currentChapter checkSpace:_checkSpace];
            }else{
                str = [LoadContent splitFooter:str atIndex:i withBookId:bookId inChapter:currentChapter checkSpace:_checkSpace];
            }
//            NSString *resultKQ = [[NSString alloc] initWithFormat:@"<div class='usfm-m-tag' style='text-align: left'> %@</div>",str];
            NSString *resultKQ = [[NSString alloc] initWithFormat:@"<div> %@</div>",str];
            [[NSUserDefaults standardUserDefaults] setObject:resultKQ forKey:@"KQ"];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"CHECK"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _checkQuote = 1;
        }
        _checkSpace = i;
        [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"check"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.arrBookSeperateLine[i] = result;
        return;
    }
    
    if ([usfmTag isEqualToString:USFM_M_TAG]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CHECK"];
        _checkSpace = i;
        NSString *tmp = self.arrBookSeperateLine[i];
        NSString *stringNoIncludeUsfm = [LoadContent excludeUsfmTagFromLine:tmp];
        NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"KQ"];
        if ([result rangeOfString:@"</span>?"].location == NSNotFound) {
            result = [result stringByReplacingOccurrencesOfString:@"</span> <script>" withString:[NSString stringWithFormat:@"<br/>%@</span> <script>", stringNoIncludeUsfm]];
        }else{
            result = [result stringByReplacingOccurrencesOfString:@"</span>?" withString:[NSString stringWithFormat:@"<br/>%@</span>", stringNoIncludeUsfm]];
        }
        result = [result stringByReplacingOccurrencesOfString:@"</script>?" withString:@"</script>"];

        self.arrBookSeperateLine[i] = result;
        NSLog(@"%@", result);
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"KQ"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
}

#pragma encode and decode object
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.arrBookSeperateLine forKey:@"ArrBookSeperateLine"];
    [encoder encodeObject:self.chapter forKey:@"Chapter"];
    [encoder encodeObject:self.chapterLabel forKey:@"Chapter-Label"];
    [encoder encodeObject:self.name forKey:@"Name"];
    [encoder encodeObject:self.shortenedName forKey:@"Title"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.arrBookSeperateLine = [decoder decodeObjectForKey:@"ArrBookSeperateLine"];
        self.chapter = [decoder decodeObjectForKey:@"Chapter"];
        self.chapterLabel = [decoder decodeObjectForKey:@"Chapter-Label"];
        self.name = [decoder decodeObjectForKey:@"Name"];
        self.shortenedName = [decoder decodeObjectForKey:@"Title"];
    }
    return self;
}

@end
