//
//  SMPersistentStore.h
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPersistentStore : NSObject
@property (strong, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
-(instancetype)initWithStoreURl:(NSURL*)storeURL andModelURL:(NSURL*)modelURL;
@end
