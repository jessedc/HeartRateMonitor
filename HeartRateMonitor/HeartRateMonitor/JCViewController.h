//
//  JCViewController.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCHeartRateMonitor;

@interface JCViewController : UIViewController

- (void)configureWithHeartRateMonitor:(JCHeartRateMonitor *)monitor;

@end
