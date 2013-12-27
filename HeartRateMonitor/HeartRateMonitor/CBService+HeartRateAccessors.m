//
//  CBService+HeartRateAccessors.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "CBService+HeartRateAccessors.h"

#define HRM_MEASUREMENT_CHARACTERISTIC @"2A37" //org.bluetooth.characteristic.heart_rate_measurement

@implementation CBService (HeartRateAccessors)

- (CBCharacteristic *)heartRateMeasurementCharacteristic
{
    __block CBCharacteristic *characteristic;
    [self.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *c, NSUInteger idx, BOOL *stop) {
        if ([c.UUID isEqual:[CBUUID UUIDWithString:HRM_MEASUREMENT_CHARACTERISTIC]])
        {
            characteristic = c;
            *stop = YES;
        }
    }];

    return characteristic;
}

@end
