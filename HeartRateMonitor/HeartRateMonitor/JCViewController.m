//
//  JCViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCViewController.h"

//FIXME: Remove this

#import "JCHeartRateMeasurement.h"
#import "JCHeartRateMonitorDelegate.h"


// https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx

#define HRM_DEVICE_INFO_SERVICE @"180A" //org.bluetooth.service.device_information
#define HRM_HEAT_RATE_SERVICE @"180D" //org.bluetooth.service.heart_rate

// https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicsHome.aspx

#define HRM_MEASUREMENT_CHARACTERISTIC @"2A37" //org.bluetooth.characteristic.heart_rate_measurement
#define HRM_BODY_LOCATION_CHARACTERISTIC @"2A38" //org.bluetooth.characteristic.blood_pressure_measurement
#define HRM_MANUFACTURER_NAME_CHARACTERISTIC @"2A29" //org.bluetooth.characteristic.manufacturer_name_string

NS_ENUM(uint8_t, JCBTHRFormat)
{
    JCBTHRFormat8Bit = 0x0,
    JCBTHRFormat16Bit = 0x1
};

NS_ENUM(uint8_t, JCBTHRSensorContactStatus)
{
    JCBTHRSensorContactStatusNotSupported = 0x0,
    JCBTHRSensorContactStatusSupportedNotDetected = 0x2,
    JCBTHRSensorContactStatusSupportedDetected = 0x3
};

NS_ENUM(uint8_t, JCBTHREnergyExpendedStatus)
{
    JCBTHREnergyExpendedStatusNotSupported = 0x0,
    JCBTHREnergyExpendedStatusFieldPresent = 0x1
};

NS_ENUM(uint8_t, JCBTHRIntervalValues)
{
    JCBTHRIntervalValuesNotPresent = 0x0,
    JCBTHRIntervalValuesPresent = 0x1
};

@interface JCViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, JCHeartRateMonitorDelegate>

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

#pragma mark - JCHeartRateMonitorDelegate

- (void)monitor:(JCHeartRateMonitor *)monitor didReceiveHeartRateMeasurement:(JCHeartRateMeasurement *)measurement
{
    self.heartRateBPM.text = [NSString stringWithFormat:@"HR: %i BPM", [measurement.beatsPerMinute intValue]];
}

#pragma mark - Characteristic Getter Instance Methods



- (void)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    //https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml
    // [8bit-flags [0-format][12-contact-status][3-energry][4-interval][567-NaN][8bit-integer]
    const uint8_t *reportData = [data bytes];
    uint8_t flags = reportData[0];

    enum JCBTHRFormat bpmFormat = (flags & 0x1);

    flags = flags << 1;

    __unused enum JCBTHRSensorContactStatus contactStatus = (flags & 0x3); //has a length of two

    flags = flags << 2;

    __unused enum JCBTHREnergyExpendedStatus energyExpendedStauts = (flags & 0x1);

    flags = flags << 1;

    __unused enum JCBTHRIntervalValues intervalValues = (flags & 0x1);

    uint16_t bpm = 0;
    if (bpmFormat == JCBTHRFormat8Bit) //Format is set to UINT8
    {
        bpm = reportData[1]; //grab the second byte directly, put it in the bigger container bpm
    }
    else //Format is set to UINT16
    {
        //FIXME: not tested
        uint16_t *pointerToSecondByte = (uint16_t *)(&reportData[1]);
        bpm = CFSwapInt16LittleToHost(*pointerToSecondByte);
    }

    if ((characteristic.value) || !error)
    {
        JCHeartRateMeasurement *measurement = [[JCHeartRateMeasurement alloc] init];
        measurement.beatsPerMinute = @(bpm);
        measurement.timestamp = [NSDate date];

        [self monitor:nil didReceiveHeartRateMeasurement:measurement];
    }
}

- (void)getManufacturerName:(CBCharacteristic *)characteristic
{
    NSString *name = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", name];
}

- (void)getBodyLocation:(CBCharacteristic *)characteristic
{
    //TODO: https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.body_sensor_location.xml
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;

    NSArray *services = @[ [CBUUID UUIDWithString:HRM_DEVICE_INFO_SERVICE], [CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE]];
    [peripheral discoverServices:services];
    self.connected = [NSString stringWithFormat:@"connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //TODO: Error case
    NSLog(@"did fail to connect");
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
    for (CBService *service in peripheral.services)
    {
        NSLog(@"found service: %@", service.UUID);

        NSArray *chars;
        if ([service.UUID isEqual:[CBUUID UUIDWithString:HRM_DEVICE_INFO_SERVICE]])
        {
            chars = @[[CBUUID UUIDWithString:HRM_MANUFACTURER_NAME_CHARACTERISTIC]];

        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE]])
        {
            chars = @[[CBUUID UUIDWithString:HRM_MEASUREMENT_CHARACTERISTIC],
                      [CBUUID UUIDWithString:HRM_BODY_LOCATION_CHARACTERISTIC]];
        }

        [peripheral discoverCharacteristics:chars forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

    NSAssert(peripheral == self.blueHRPeripheral, @"I'm expecting the peripheral is the same as the one I was using before");

    //FIXME: JC - I subscribed explicitly to these characteristics. I shouldn't have to check them twice, except for the case
    // where I want to setNotifyValue instead of readValue;

    if ([service.UUID isEqual:[CBUUID UUIDWithString:HRM_DEVICE_INFO_SERVICE]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:HRM_MANUFACTURER_NAME_CHARACTERISTIC]])
            {
                [peripheral readValueForCharacteristic:aChar];
            }
        }
    }
    else if ([service.UUID isEqual:[CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:HRM_MEASUREMENT_CHARACTERISTIC]])
            {
                [peripheral setNotifyValue:YES forCharacteristic:aChar];
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:HRM_BODY_LOCATION_CHARACTERISTIC]])
            {
                [peripheral readValueForCharacteristic:aChar];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HRM_MEASUREMENT_CHARACTERISTIC]])
    {
        [self getHeartBPMData:characteristic error:error];
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HRM_MANUFACTURER_NAME_CHARACTERISTIC]])
    {
        [self getManufacturerName:characteristic];
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HRM_BODY_LOCATION_CHARACTERISTIC]])
    {
        [self getBodyLocation:characteristic];
    }

    self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n", self.connected, self.manufacturer];
}

@end
