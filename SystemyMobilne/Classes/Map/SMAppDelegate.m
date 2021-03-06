//
//  SMAppDelegate.m
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMViewController.h"
#import "SMPhotosCVC.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SMAppDelegate()
@property (strong, nonatomic) SMPersistentStore *persistentStore;
@end
@implementation SMAppDelegate



- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    SMViewController *vc = [[SMViewController alloc] init ];
    self.window.backgroundColor = [UIColor whiteColor];
    self.persistentStore = [[SMPersistentStore alloc] initWithStoreURl:[self storeURL] andModelURL:[self modelURL]];
    vc.managedObjectContext = self.persistentStore.managedObjectContext;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.restorationIdentifier = @"navController";
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(NSManagedObjectContext*)sharedManagedObjectContext
{
    return self.persistentStore.managedObjectContext;
}
-(UIViewController*)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController* result;
    if([[identifierComponents lastObject] isEqualToString:@"PhotosCVC"])
    {
        NSPredicate* predicate = [coder decodeObjectForKey:@"predicate"];
        NSFetchedResultsController *frc = [[(UINavigationController*)self.window.rootViewController viewControllers][0] createFetchRCforPhtotWithPredicate:predicate];
        result = [[SMPhotosCVC alloc] initWithRequest:frc];
        result.restorationIdentifier = @"PhotosCVC";
    }
    else if ([[identifierComponents lastObject] isEqualToString:@"SMViewController"])
    {
        result = [(UINavigationController*)self.window.rootViewController viewControllers][0];
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSAssert(self.persistentStore.managedObjectContext, @"managed object context doesn't exists");
    
    [self.persistentStore.managedObjectContext performBlock:^(){
        NSError *savingError;
        [self.persistentStore.managedObjectContext save:&savingError];
        if(savingError != nil)
        {
            NSLog(@"%@",savingError.localizedDescription);
        }
    }];
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

+ (ALAssetsLibrary*)sharedLibrary
{
    static dispatch_once_t once;
    static ALAssetsLibrary *library;
    dispatch_once(&once, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}
#pragma mark - Core Data stack
-(NSURL*)storeURL
{
    NSURL *storeULR = [self applicationDocumentsDirectory];
    return  [storeULR URLByAppendingPathComponent:@"dataBase.sqlite"];
}

-(NSURL*) modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"SystemyMobilne" withExtension:@"momd"];
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
