//
//  JCHeartRateMonitor.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "_JCHeartRateMonitor.h"

#import "JCHeartRateMonitorDelegate.h"
#import "JCHeartRateMeasurement.h"

@interface JCHeartRateMonitor : _JCHeartRateMonitor

+ (NSArray *)bluetoothServices;

@property (nonatomic, weak) id<JCHeartRateMonitorDelegate> delegate;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end
