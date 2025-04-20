//
//  IpodBuilder.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDevice-IOKitExtensions.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface IpodBuilder : NSObject

@property (nonatomic, strong)NSString *serialNumber;
@property (nonatomic, strong)NSString *SSID;
@property (nonatomic, strong)NSString *IP;
@property (nonatomic, strong)NSString *iOS;


- (NSString *)getSerialNumber;
- (NSString*)getCurrentNetwork;
- (NSString *)getIPAddress;
- (NSString*)getIOSVersion;
- (IpodBuilder*)newiPod;


@end
