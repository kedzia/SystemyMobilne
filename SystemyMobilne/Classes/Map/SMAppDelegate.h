//
//  SMAppDelegate.h
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPersistentStore.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext*)sharedManagedObjectContext;
+ (ALAssetsLibrary*)sharedLibrary;
@end
