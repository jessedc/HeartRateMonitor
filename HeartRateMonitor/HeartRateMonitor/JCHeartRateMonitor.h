//
//  JCHeartRateMonitor.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCHeartRateMonitorDelegate.h"
#import "JCHeartRateMeasurement.h"

@interface JCHeartRateMonitor : NSObject

@property (nonatomic, strong, readonly) NSArray *bluetoothServices;

@property (nonatomic, strong, readonly) NSString *manufacturerName; //this may not be available right away
@property (nonatomic, strong, readonly) NSUUID *identifier;

@property (nonatomic, weak) id<JCHeartRateMonitorDelegate> delegate;
@end
