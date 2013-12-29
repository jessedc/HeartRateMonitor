//
//  JCHeartRateTableViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCHeartRateTableViewController.h"
#import "JCHeartRateMonitor.h"
#import "NSFetchedResultsController+JCHeartRateMonitor.h"

@interface JCHeartRateTableViewController () <NSFetchedResultsControllerDelegate, JCHeartRateMonitorDelegate>
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) JCHeartRateMonitor *monitor;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation JCHeartRateTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.timeStyle = NSDateFormatterMediumStyle;
    self.formatter.dateStyle = NSDateFormatterMediumStyle;

    self.frc = [NSFetchedResultsController controllerForFetchingMeasurementsForHeartRateMonitor:self.monitor
                                                                         inManagedObjectContext:self.monitor.managedObjectContext
                                                                                      ascending:NO];

    self.frc.delegate = self;
    NSError *error;
    [self.frc performFetch:&error];
    NSParameterAssert(!error);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.monitor startUpdatingHeartRate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.monitor stopUpdatingHeartRate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureWithHeartRateMonitor:(JCHeartRateMonitor *)monitor
{
    self.monitor = monitor;
    self.monitor.delegate = self;
}

#pragma mark - FRC Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)monitor:(JCHeartRateMonitor *)monitor didReceiveHeartRateMeasurement:(JCHeartRateMeasurement *)measurement
{
    NSError *error;
    [measurement.managedObjectContext save:&error];
    NSParameterAssert(!error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JCHeartRateMeasurement *measurement = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ BPM ",measurement.beatsPerMinute];
    cell.detailTextLabel.text = [self.formatter stringFromDate:measurement.timestamp];
    
    return cell;
}

@end
