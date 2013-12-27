//
//  JCHeartRateDeviceManager.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCHeartDateDeviceManagerDelegate.h"
#import "JCBluetoothPeripheral.h"

@class JCBluetoothPeripheral;

@interface JCHeartRateDeviceManager : NSObject

@property (nonatomic, weak) id<JCHeartDateDeviceManagerDelegate> delegate;

@property (nonatomic, strong) NSArray *peripherals; //you should be able to observe this

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)startScanning;
- (void)stopScanning;

- (void)connectPeripheral:(JCBluetoothPeripheral *)peripheral;

@end
