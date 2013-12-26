//
//  JCHeartDateDeviceManagerDelegate.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCHeartRateDeviceManager, JCHeartRateMonitor;

@protocol JCHeartDateDeviceManagerDelegate <NSObject>

- (void)manager:(JCHeartRateDeviceManager *)manager didConnectHeartRateMonitor:(JCHeartRateMonitor *)monitor;

@optional
- (void)manager:(JCHeartRateDeviceManager *)manager didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@end
