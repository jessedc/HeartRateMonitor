//
//  JCHeartRateMeasurement.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHeartRateMeasurement : NSObject

@property (nonatomic, strong) NSNumber *beatsPerMinute;
@property (nonatomic, strong) NSDate *timestamp;

@end
