//
//  CustomWindow.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/14/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow

- (void)tapAndHoldAction:(NSTimer*)timer
{
    contextualMenuTimer = nil;
    NSDictionary *coord = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:tapLocation.x],@"x",
                           [NSNumber numberWithFloat:tapLocation.y],@"y",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TapAndHoldNotification" object:coord];
}

- (void)touchEndAction:(NSTimer*)timer {
    contextualMenuTimer =  nil;
    NSDictionary *coord = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:tapLocation.x],@"x",
                           [NSNumber numberWithFloat:tapLocation.y],@"y",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchEndActionNotification" object:coord];
}

- (void)sendEvent:(UIEvent *)event
{
    NSSet *touches = [event touchesForWindow:self];
    [super sendEvent:event];    // Call super to make sure the event is processed as usual
    if ([touches count] == 1) { // We're only interested in one-finger events
        UITouch *touch = [touches anyObject];
        switch ([touch phase]) {
            case UITouchPhaseBegan:  // A finger touched the screen
                tapLocation = [touch locationInView:self];
                [contextualMenuTimer invalidate];
                contextualMenuTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                       target:self selector:@selector(tapAndHoldAction:)
                                                                     userInfo:nil repeats:NO];
                break;
            case UITouchPhaseEnded:
                tapLocation = [touch locationInView:self];
                [contextualMenuTimer invalidate];
                contextualMenuTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(touchEndAction:) userInfo:nil repeats:NO];
                break;
            case UITouchPhaseMoved:
            case UITouchPhaseCancelled:
                [contextualMenuTimer invalidate];
                contextualMenuTimer = nil;
                break;
        }
    } else {                    // Multiple fingers are touching the screen
        [contextualMenuTimer invalidate];
        contextualMenuTimer = nil;
    }
    
}


@end
