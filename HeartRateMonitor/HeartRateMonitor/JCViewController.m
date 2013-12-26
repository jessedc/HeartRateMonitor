//
//  JCViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCViewController.h"

// https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx

#define HRM_DEVICE_INFO_SERVICE @"180A" //org.bluetooth.service.device_information
#define HRM_HEAT_RATE_SERVICE @"180D" //org.bluetooth.service.heart_rate

// https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicsHome.aspx

#define HRM_MEASUREMENT_CHARACTERISTIC @"2A37" //org.bluetooth.characteristic.heart_rate_measurement
#define HRM_BODY_LOCATION_CHARACTERISTIC @"2A38" //org.bluetooth.characteristic.blood_pressure_measurement
#define HRM_MANUFACTURER_NAME_CHARACTERISTIC @"2A29" //org.bluetooth.characteristic.manufacturer_name_string


@interface JCViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *blueHRPeripheral;

@property (nonatomic, strong) IBOutlet UITextView *deviceInfo;
@property (nonatomic, strong) NSString *connected;
@property (nonatomic, strong) NSString *bodyData;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *deviceData;
@property (nonatomic, assign) uint16_t heartRate;

@property (nonatomic, strong) IBOutlet UILabel *heartRateBPM;
@property (nonatomic, strong) NSTimer *pulseTimer;

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *services = @[[CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE], [CBUUID UUIDWithString:HRM_DEVICE_INFO_SERVICE] ];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [self.centralManager scanForPeripheralsWithServices:services options:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Characteristic Getter Instance Methods

- (void)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

- (void)getManufacturerName:(CBCharacteristic *)characteristic
{

}

- (void)getBodyLocation:(CBCharacteristic *)characteristic
{

}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    //FIXME: JC - Why check for a length?
    if (localName.length > 0)
    {
        NSLog(@"Found the HRM: %@", localName);
        [self.centralManager stopScan];
        self.blueHRPeripheral = peripheral;
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

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

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

@end
