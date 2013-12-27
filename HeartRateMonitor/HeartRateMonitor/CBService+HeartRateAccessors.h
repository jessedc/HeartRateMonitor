//
//  CBService+HeartRateAccessors.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (HeartRateAccessors)

- (CBCharacteristic *)heartRateMeasurementCharacteristic;

@end
