//
//  JCChartVieControllerViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 29/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCChartVieControllerViewController.h"
#import "JCHeartRateMonitor.h"
#import "NSFetchedResultsController+JCHeartRateMonitor.h"
#import "JBLineChartView.h"
#import "JCHeartRateTableViewController.h"

@interface JCChartVieControllerViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) JBLineChartView *lineChart;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) JCHeartRateMonitor *monitor;
@property (nonatomic, strong) JCHeartRateTableViewController *tableViewController;
@end

@implementation JCChartVieControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lineChart = [[JBLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    self.lineChart.delegate = self;
    self.lineChart.dataSource = self;
    self.lineChart.backgroundColor = [UIColor orangeColor];
    self.lineChart.headerPadding = 10;

    [self.view addSubview:self.lineChart];

    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HeartRateTable"];
    [self.tableViewController configureWithHeartRateMonitor:self.monitor];
    [self addChildViewController:self.tableViewController];

    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.lineChart setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    [self.tableViewController.view setFrame:CGRectMake(0, CGRectGetMaxY(self.lineChart.frame), self.view.bounds.size.width, self.view.bounds.size.height - self.lineChart.bounds.size.height)];
}

- (void)configureWithHeartRateMonitor:(JCHeartRateMonitor *)monitor
{
    self.monitor = monitor;

    self.frc = [NSFetchedResultsController controllerForFetchingMeasurementsForHeartRateMonitor:self.monitor
                                                                         inManagedObjectContext:self.monitor.managedObjectContext
                                                                                      ascending:YES];

    self.frc.delegate = self;
    NSError *error;
    [self.frc performFetch:&error];
    NSParameterAssert(!error);
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.lineChart reloadData];
}

#pragma mark - JBLineChartViewDelegate

- (NSInteger)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
//    NSInteger lastObject = self.frc.fetchedObjects.count - 1;

//    NSInteger thisObject = lastObject - index;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    JCHeartRateMeasurement *measurement = [self.frc objectAtIndexPath:indexPath];

    return [measurement.beatsPerMinute integerValue] - 50;
}

//- (void)lineChartView:(JBLineChartView *)lineChartView didSelectChartAtIndex:(NSInteger)index
//{
//}

//- (void)lineChartView:(JBLineChartView *)lineChartView didUnselectChartAtIndex:(NSInteger)index
//{
//}

#pragma mark - JBLineChartViewDataSource

- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return self.frc.fetchedObjects.count;
}

- (UIColor *)lineColorForLineChartView:(JBLineChartView *)lineChartView
{
    return [UIColor blueColor];
}

//- (UIColor *)selectionColorForLineChartView:(JBLineChartView *)lineChartView
//{
//}

@end
