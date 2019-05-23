//
//  CustomWindow.h
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/14/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomWindow :  UIWindow {NSMutableArray *views;
@private UIView *touchView;
    CGPoint    tapLocation;
    NSTimer    *contextualMenuTimer;
    
}

@end