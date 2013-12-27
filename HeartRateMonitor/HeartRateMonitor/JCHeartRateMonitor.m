//
//  JCHeartRateMonitor.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCHeartRateMonitor.h"

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

@interface JCHeartRateMonitor() <CBPeripheralDelegate>

//Bluetooth Characteristics
@property (nonatomic, strong) CBUUID *heartRateMeasurementCharacteristic;
@property (nonatomic, strong) CBUUID *bodyLocationCharacteristic;
@property (nonatomic, strong) CBUUID *manufacturerNameCharacteristic;

@property (nonatomic, strong) CBPeripheral *heartRatePeripheral;

@end

@implementation JCHeartRateMonitor
@dynamic identifier;
@synthesize heartRateMeasurementCharacteristic;
@synthesize bodyLocationCharacteristic;
@synthesize manufacturerNameCharacteristic;
@synthesize heartRatePeripheral;
@synthesize delegate;

+ (NSArray *)bluetoothServices
{
    static dispatch_once_t onceToken;
    static NSArray *bluetoothServices;
    dispatch_once(&onceToken, ^{
        bluetoothServices = @[[CBUUID UUIDWithString:HRM_HEAT_RATE_SERVICE], [CBUUID UUIDWithString:HRM_DEVICE_INFO_SERVICE]];
    });
    return bluetoothServices;
}

- (void)configureWithPeripheral:(CBPeripheral *)peripheral
{
    //FIXME: make these static
    self.heartRateMeasurementCharacteristic = [CBUUID UUIDWithString:HRM_MEASUREMENT_CHARACTERISTIC];
    self.manufacturerNameCharacteristic = [CBUUID UUIDWithString:HRM_MANUFACTURER_NAME_CHARACTERISTIC];
    self.bodyLocationCharacteristic = [CBUUID UUIDWithString:HRM_BODY_LOCATION_CHARACTERISTIC];

    self.heartRatePeripheral = peripheral;
    self.heartRatePeripheral.delegate = self;
    [self.heartRatePeripheral discoverServices:[[self class] bluetoothServices]];

    self.identifier = [peripheral.identifier UUIDString];
}

- (void)startUpdatingHeartRate
{

}

- (void)stopUpdatingHeartRate
{
    
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        NSLog(@"found service: %@", service.UUID);

        NSArray *chars;
        if ([service.UUID isEqual:[[self class] bluetoothServices][1]])
        {
            chars = @[self.manufacturerNameCharacteristic];

        }
        else if ([service.UUID isEqual:[[self class] bluetoothServices][0]])
        {
            chars = @[self.heartRateMeasurementCharacteristic];
        }

        [peripheral discoverCharacteristics:chars forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *aChar in service.characteristics)
    {
        if ([aChar.UUID isEqual:self.heartRateMeasurementCharacteristic])
        {
            [peripheral setNotifyValue:YES forCharacteristic:aChar];
        }
        else if ([aChar.UUID isEqual:self.manufacturerNameCharacteristic])
        {
            [peripheral readValueForCharacteristic:aChar];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:self.heartRateMeasurementCharacteristic])
    {
        [self getHeartBPMData:characteristic error:error];
    }
    else if ([characteristic.UUID isEqual:self.manufacturerNameCharacteristic])
    {
        [self getManufacturerName:characteristic];
    }
    //TODO: if I care, subscribe to this
//    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HRM_BODY_LOCATION_CHARACTERISTIC]])
//    {
//        [self getBodyLocation:characteristic];
//    }
}

#pragma mark - CBPeripheral Getters

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

    if (characteristic.value || !error)
    {
        JCHeartRateMeasurement *measurement = [JCHeartRateMeasurement insertInManagedObjectContext:self.managedObjectContext];
        measurement.beatsPerMinute = @(bpm);
        measurement.timestamp = [NSDate date];
        measurement.heartRateMonitor = self;

        typeof (self.delegate) strongDelegate = self.delegate;
        [strongDelegate monitor:self didReceiveHeartRateMeasurement:measurement];
    }
}

- (void)getManufacturerName:(CBCharacteristic *)characteristic
{
    self.manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

//- (void)getBodyLocation:(CBCharacteristic *)characteristic
//{
//    //TODO: https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.body_sensor_location.xml
//}

@end
