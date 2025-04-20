//
//  IpodBuilder.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "IpodBuilder.h"

@implementation IpodBuilder

- (IpodBuilder*)newiPod{
    
    IpodBuilder *iPod = [IpodBuilder alloc];
    iPod.serialNumber = iPod.getSerialNumber;
    iPod.SSID = iPod.getCurrentNetwork;
    iPod.IP = iPod.getIPAddress;
    iPod.iOS = iPod.getIOSVersion;
    
    
    
    return iPod;
}


- (NSString *)getSerialNumber{
    
    
    BOOL isIOS8 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);
    
    NSString *getserialNumber = @"Missing AirWatch Data";
    NSString *serialNumber;
    
    
    if  (isIOS8) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *serialDetails = [prefs dictionaryForKey:@"com.apple.configuration.managed"];
        serialNumber = [serialDetails objectForKey:@"DeviceSerialNumber"];
    } else {
        
        serialNumber = [[UIDevice currentDevice] serialnumber];
        
    }
    
    if (serialNumber != nil) {
        getserialNumber = serialNumber;
    }
    return getserialNumber;
    
}

// Get SSID: Return NULL if no network found
- (NSString*)getCurrentNetwork{
    
    NSString *wifiName = nil;
    NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *name in interFaceNames) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }else{
            wifiName = @"Not Connected";
        }
    }
    
    return wifiName;
}

- (NSString *)getIPAddress{
    
    NSString *address = @"0.0.0.0";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
    
}


- (NSString*)getIOSVersion{
    
  NSString *iOS = [[UIDevice currentDevice] systemVersion];
    
    
    return iOS;
    
}

- (float*)getIOSFloatVersion{
    
    float iOS = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    
    return &iOS;
    
}

@end






