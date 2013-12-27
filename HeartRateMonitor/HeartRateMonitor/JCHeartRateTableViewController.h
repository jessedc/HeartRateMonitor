//
//  JCHeartRateTableViewController.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 27/12/13.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCHeartRateMonitor;

@interface JCHeartRateTableViewController : UITableViewController

- (void)configureWithHeartRateMonitor:(JCHeartRateMonitor *)monitor;

@end
