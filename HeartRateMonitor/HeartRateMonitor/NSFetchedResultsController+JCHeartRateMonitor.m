//
//  NSFetchedResultsController+JCHeartRateMonitor.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 29/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "NSFetchedResultsController+JCHeartRateMonitor.h"
#import "JCHeartRateMeasurement.h"

@implementation NSFetchedResultsController (JCHeartRateMonitor)

+ (instancetype)controllerForFetchingMeasurementsForHeartRateMonitor:(JCHeartRateMonitor *)monitor
                                              inManagedObjectContext:(NSManagedObjectContext *)moc
                                                           ascending:(BOOL)ascending
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JCHeartRateMeasurement entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"heartRateMonitor == %@", monitor];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:ascending]];

    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:moc
                                                 sectionNameKeyPath:nil
                                                          cacheName:@"hr"];
}

@end
