//
//  JCViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCViewController.h"
#import "JCHeartRateMonitor.h"

@interface JCViewController () <JCHeartRateMonitorDelegate>

@property (nonatomic, strong) JCHeartRateMonitor *heartRateMonitor;

@property (nonatomic, strong) IBOutlet UITextView *deviceInfo;
@property (nonatomic, strong) IBOutlet UILabel *heartRateBPM;

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.heartRateMonitor = [[JCHeartRateMonitor alloc] init];
    self.heartRateMonitor.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - JCHeartRateMonitorDelegate

- (void)monitor:(JCHeartRateMonitor *)monitor didReceiveHeartRateMeasurement:(JCHeartRateMeasurement *)measurement
{
    self.heartRateBPM.text = [NSString stringWithFormat:@"HR: %i BPM", [measurement.beatsPerMinute intValue]];
}

@end
