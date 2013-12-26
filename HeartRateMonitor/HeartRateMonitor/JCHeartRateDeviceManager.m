//
//  JCHeartRateDeviceManager.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCHeartRateDeviceManager.h"
#import "JCHeartRateMonitor.h"
#import "JCBluetoothPeripheral.h"

@interface JCHeartRateDeviceManager() <CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@end

@implementation JCHeartRateDeviceManager

- (id)init
{
    if (self = [super init])
    {
        self.peripherals = @[];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)startScanning
{
    [self.centralManager scanForPeripheralsWithServices:[JCHeartRateMonitor bluetoothServices] options:nil];
}

- (void)stopScanning
{
    [self.centralManager stopScan];
}

- (void)connectPeripheral:(JCBluetoothPeripheral *)peripheral
{
    //TODO: discover the options
    [self.centralManager connectPeripheral:peripheral.peripheral options:nil];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CoreBluetooth didUpdateState: hardware is powered off.");
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"CoreBluetooth didUpdateState: hardware is powered on.");
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"CoreBluetooth didUpdateState: unauthorized.");
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"CoreBluetooth didUpdateState: hardware is resetting.");
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"CoreBluetooth didUpdateState: hardware is unsupported.");
            break;
        }
        default:
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"CoreBluetooth didUpdateState: state is unknown.");
            break;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSMutableArray *mutablePeripherals = [self mutableArrayValueForKey:@"peripherals"];

    JCBluetoothPeripheral *p = [[JCBluetoothPeripheral alloc] init];
    p.peripheral = peripheral;
    p.advertisementData = advertisementData;
    p.RSSI = RSSI;

    if (![mutablePeripherals containsObject:p])
    {
        [mutablePeripherals addObject:p];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral.state == CBPeripheralStateConnected)
    {
        JCHeartRateMonitor *monitor = [[JCHeartRateMonitor alloc] initWithPeripheral:peripheral];
        typeof (self.delegate) strongDelegate = self.delegate;
        [strongDelegate manager:self didConnectHeartRateMonitor:monitor];
    }
    else
    {
        //FIXME: TODO: Handle this case
        NSAssert(false, @"Not expecting the peripheral to not be connected at this point");
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    typeof (self.delegate) strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(manager:didFailToConnectPeripheral:error:)])
    {
        [strongDelegate manager:self didFailToConnectPeripheral:peripheral error:error];
    }
}

@end
