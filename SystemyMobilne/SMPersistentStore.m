//
//  SMPersistentStore.m
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPersistentStore.h"

@interface SMPersistentStore()
@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSURL* storeURL;
@property (strong, nonatomic) NSURL* modelURL;
@end

@implementation SMPersistentStore
-(instancetype)initWithStoreURl:(NSURL *)storeURL andModelURL:(NSURL *)modelURL
{
    self = [super init];
    if(self)
    {
        self->_modelURL = modelURL;
        self->_storeURL = storeURL;
        [self setupManagedObjectContext];
    }
    return self;
}

-(void) setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc]  initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self ManagedObjectModel]];
    NSError *error = nil;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

-(NSManagedObjectModel*)ManagedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}
@end
