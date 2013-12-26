//
//  JCBluetoothPeripheralsViewController.m
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import "JCBluetoothPeripheralsViewController.h"
#import "JCHeartRateDeviceManager.h"

@interface JCBluetoothPeripheralsViewController ()
@property (nonatomic, strong) JCHeartRateDeviceManager *deviceManager;
@end

@implementation JCBluetoothPeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deviceManager = [[JCHeartRateDeviceManager alloc] init];
    [self.deviceManager addObserver:self forKeyPath:@"peripherals" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];

    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.deviceManager startScanning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.deviceManager stopScanning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"peripherals"])
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceManager.peripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    JCBluetoothPeripheral *p = [self.deviceManager.peripherals objectAtIndex:indexPath.row];

    cell.textLabel.text = p.advertisementData[CBAdvertisementDataLocalNameKey];
    cell.detailTextLabel.text = [p.peripheral.identifier UUIDString];
    
    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
