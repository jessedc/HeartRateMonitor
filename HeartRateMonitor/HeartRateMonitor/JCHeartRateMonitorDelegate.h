//
//  JCHeartRateMonitorDelegate.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCHeartRateMonitor, JCHeartRateMeasurement;

@protocol JCHeartRateMonitorDelegate <NSObject>

- (void)monitor:(JCHeartRateMonitor *)monitor didReceiveHeartRateMeasurement:(JCHeartRateMeasurement *)measurement;

@end
