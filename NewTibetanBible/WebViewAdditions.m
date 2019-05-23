//
//  WebViewAdditions.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/14/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "WebViewAdditions.h"

@implementation UIWebView(WebViewAdditions)

- (CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}
@end
