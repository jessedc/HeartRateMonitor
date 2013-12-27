//
//  JCCoreDataManager.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCCoreDataManager.h"

@interface JCCoreDataManager()
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@end

@implementation JCCoreDataManager

- (id)init
{
    if (self = [super init])
    {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack
{
    NSURL *momURL = [[self class] modelURL];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

//    NSURL *storeURL = [[self class] storeURL];

    NSError *error;
    [psc addPersistentStoreWithType:NSInMemoryStoreType
                      configuration:nil
                                URL:nil
                            options:nil
                              error:&error];

    self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.moc setPersistentStoreCoordinator:psc];

    self.psc = psc;
}

#pragma mark - Utilities

+ (NSURL *)storeURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Database.sqlite"];
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSBundle *)modelBundle
{
    return [NSBundle mainBundle];
}

- (NSURL *)modelURL
{
    return [[self modelBundle] URLForResource:@"DataModel" withExtension:@"momd"];
}

@end
