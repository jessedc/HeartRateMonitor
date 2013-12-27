//
//  JCAppDelegate.h
//  HeartRateMonitor
//
//  Created by Jesse Collis on 26/12/2013.
//  Copyright (c) 2013 JCMultimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCoreDataManager.h"

@interface JCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JCCoreDataManager *coreDataManager;

@end
