//
//  CBPeripheral+HeartRateAccessors.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "CBPeripheral+HeartRateAccessors.h"

#define HRM_HEAT_RATE_SERVICE @"180D" //org.bluetooth.service.heart_rate

@implementation CBPeripheral (HeartRateAccessors)

- (CBService *)heartRateMonitorService
{
    __block CBService *service;
    [self.services enumerateObjectsUsingBlock:^(CBService *s, NSUInteger idx, BOOL *stop) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE]])
        {
            service = s;
            *stop = YES;
        }
    }];

    return service;
}

@end
