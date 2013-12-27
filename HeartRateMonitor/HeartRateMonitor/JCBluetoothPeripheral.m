//
//  JCBluetoothPeripheral.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCBluetoothPeripheral.h"

@implementation JCBluetoothPeripheral

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;

    if ([object isKindOfClass:[self class]])
    {
        return ([self.peripheral.identifier isEqual:[(JCBluetoothPeripheral *)object peripheral].identifier]);
    }

    return NO;
}

- (NSUInteger)hash
{
    return [self.peripheral.identifier hash];
}

@end
