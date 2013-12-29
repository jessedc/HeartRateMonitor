//
//  HeartRateController.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 29/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCHeartRateMonitor;

@protocol HeartRateController <NSObject>

- (void)configureWithHeartRateMonitor:(JCHeartRateMonitor *)monitor;

@end
