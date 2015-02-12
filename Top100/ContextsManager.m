//
//  ContextsManager.m
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "ContextsManager.h"

static ContextsManager* sharedUpdateManager = nil;

@interface ContextsManager ()

@property(nonatomic, strong, getter = managedObjectModel) NSManagedObjectModel* managedObjectModel;
@property(strong, getter = persistentStoreCoordinator) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext* mainContext;

@end

@implementation ContextsManager

+ (ContextsManager*)sharedManager
{
    if(!sharedUpdateManager)
    {
        @synchronized(self)
        {
            if(!sharedUpdateManager)
            {
                sharedUpdateManager = [[super allocWithZone:NULL] init];
            }
        }
    }
    return sharedUpdateManager;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)init
{
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    if (sharedUpdateManager)
    {
        return sharedUpdateManager;
    }
    
    self = [super init];
    if (self)
    {
        [self performSelectorOnMainThread:@selector(mainContext) withObject:nil waitUntilDone:YES];
    }
    
    NSLog(@"Time needed for initialization of ContextManager init is %f",CFAbsoluteTimeGetCurrent() - time);
    return self;
}

#pragma mark - Core Data objects

- (NSManagedObjectContext *)mainContext
{
    if (_mainContext != nil)
    {
        return _mainContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self sharedPersistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:coordinator];
    }
    return _mainContext;
}

- (NSPersistentStoreCoordinator*)sharedPersistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    @synchronized(self)
    {
        NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Top100.sqlite"];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Top100" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


#pragma mark - Private messages

- (NSURL *)applicationDocumentsDirectory
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    return [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)didSave:(NSNotification *)notification
{
    [self.mainContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) onThread:[NSThread mainThread] withObject:notification waitUntilDone:YES];
}

#pragma mark - Public messages

-(NSManagedObjectContext *)getContext
{
    if([NSThread isMainThread])
    {
        return self.mainContext;
    }
    
    NSManagedObjectContext *result = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    result.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return result;
}

//this method should be called on the thread associated with the aContex parameter
-(BOOL)saveContext:(NSManagedObjectContext *)aContext error:(NSError **)error
{
    if([aContext isEqual:self.mainContext])
    {
        BOOL result = [aContext save:error];
        return result;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSave:) name:NSManagedObjectContextDidSaveNotification object:aContext];
    BOOL result = [aContext save:error];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:aContext];
    return result;
}

@end

