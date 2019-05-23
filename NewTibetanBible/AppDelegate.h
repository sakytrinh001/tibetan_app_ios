//
//  AppDelegate.h
//  NewTibetanBible
//
//  Created by Nguyen Minh Thanh
//  Copyright © 2015 Nguyen Minh Thanh. All rights reserved.
//17/11/2016

#import <UIKit/UIKit.h>
#import "CustomWindow.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

