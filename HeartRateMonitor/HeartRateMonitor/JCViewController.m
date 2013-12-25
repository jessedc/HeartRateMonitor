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

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central   didConnectPeripheral:(CBPeripheral *)peripheral
{

}

- (void)centralManager:(CBCentralManager *)central   didDiscoverPeripheral:(CBPeripheral *)peripheral   advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{

}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral   didDiscoverServices:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral   didDiscoverCharacteristicsForService:(CBService *)service   error:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

#pragma mark - CBCharacteristic helpers (Ray Wenderlich)

- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
}

- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
}

- (void) getBodyLocation:(CBCharacteristic *)characteristic
{
}

- (void)doHeartBeat
{
}

@end
