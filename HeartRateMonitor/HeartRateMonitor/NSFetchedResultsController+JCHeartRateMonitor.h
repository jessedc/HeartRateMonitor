//
//  NSFetchedResultsController+JCHeartRateMonitor.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 29/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <CoreData/CoreData.h>

@class JCHeartRateMonitor;

@interface NSFetchedResultsController (JCHeartRateMonitor)

+ (instancetype)controllerForFetchingMeasurementsForHeartRateMonitor:(JCHeartRateMonitor *)monitor
                                              inManagedObjectContext:(NSManagedObjectContext *)moc ascending:(BOOL)ascending;

@end
