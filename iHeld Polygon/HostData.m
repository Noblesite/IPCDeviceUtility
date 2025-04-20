//
//  HostData.m
//  DNSTest2
//
//  Created by Jonathon Poe on 10/7/16.
//  Copyright © 2016 Noblesite. All rights reserved.
//

#include "HostData.h"
#import <Foundation/Foundation.h>


@interface HostData () <QCFHostResolverDelegate>

@property (nonatomic, assign, readwrite) NSUInteger     runningResolverCount;

@end

@implementation HostData

@synthesize resolvers = _resolvers;

@synthesize runningResolverCount = _runningResolverCount;



- (NSString*) getDNSServers{
    self.hostInfo = NULL;
    
    // dont forget to link libresolv.lib
    // Method for pulling the DNS server IP address on the iOS device
    NSMutableString *addresses = [[NSMutableString alloc]initWithString:@"DNS Addresses \n"];
    NSLog(@"First Address check before processing: %@", addresses);
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    NSMutableArray *iPodDNS = [[NSMutableArray alloc]init];
    NSMutableArray *iPodHost = [[NSMutableArray alloc]init];

    
    if ( result == 0 )
    {
        //For loop to pull multiple DNS server ip address on the iOS Device
        for ( int i = 0; i < res->nscount; i++ )
        {
        // Pulling the primary DNS server IP address
        NSString *s = [NSString stringWithUTF8String : inet_ntoa(res->nsaddr_list[i].sin_addr)];
        addresses = [NSMutableString stringWithFormat:@"%@", s];
        NSLog(@"Address %i with %@",i, s);
        
        // place the DNS IP addresses of the iOS device into self.dNSiP
        [iPodDNS addObject:addresses];
        
           NSString *DNSipArray;
            DNSipArray = iPodDNS[i];
            NSLog(@" info in self.dNSip: %@", DNSipArray);
        }
        int                 retVal;
        NSMutableArray *    resolvers;
        
        self.dNSip = iPodDNS;
    
        @autoreleasepool {
            
            int i = 0;
            for (NSString *s in self.dNSip)
            {
                
                NSLog(@" IP being Passed to QCHostReslover at: %i With %@", i, s);
                retVal = EXIT_SUCCESS;
                resolvers = [[NSMutableArray alloc] init];
                //overiding DNS IP address with info from User
            
                const char *cAddress = [s UTF8String];
                QCFHostResolver *    resolver;
                
                resolver = nil;
                resolver = [[QCFHostResolver alloc] initWithAddressString:[NSString stringWithUTF8String:cAddress]];
                if (resolver == nil) {
                    NSLog(@" Did not reslove at Array Location: %i", i);
                }
                if (resolver != nil) {
                    [resolvers addObject:resolver];
                    NSLog(@"Resolver object added at Array location: %i", i);
                }
                
                // Print the usage or do the resolution.
                
                if (retVal != EXIT_SUCCESS) {
                    NSLog(@"Error and Exit Success");
                    
                } else {
                    NSLog(@"Success, setting HostData Object");
                    HostData  *mainObj;
                    
                    mainObj = [[HostData alloc]initWithResolvers:resolvers];
                    assert(mainObj != nil);
                    
                    [mainObj run];
                    NSLog(@"mainObj has been sent to run at Array %i", i);
                    
                    self.hostInfo = [mainObj parseStoreNumber:mainObj.hostInfo];
                    [iPodHost addObject:self.hostInfo];
                    NSLog(@"Host Name being placed in hostName Array at: %i with %@", i, self.hostNames);
                    i++;
                }
            }
        
        }
            
    }
    self.hostNames = iPodHost;
    self.hostInfo = [[HostData alloc] returnHostName:self.hostNames];
    
   if(self.hostInfo != NULL){
        NSLog(@"Value Returned from HostData.m: %@", self.hostInfo);
        return self.hostInfo;
    }else{
        NSLog(@"value Returned fron HostData.m is NULL");
        self.hostInfo = @"No location: Check Network Connection";
        return self.hostInfo;
    }
}



- (id)initWithResolvers:(NSArray *)resolvers
{
    NSLog(@"In it With Reslovers called");
    self = [super init];
    if (self != nil) {
        self->_resolvers = [resolvers copy];
    }
    return self;
}

- (void)run
{
    self.runningResolverCount = [self.resolvers count];
    
    NSLog(@"Run Method is working");
    // Start each of the resolvers.
    
    for (QCFHostResolver * resolver in self.resolvers) {
        resolver.delegate = self;
        [resolver start];
    }
    
    // Run the run loop until they are all done.
    
    while (self.runningResolverCount != 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)hostResolverDidFinish:(QCFHostResolver *)resolver
// A resolver delegate callback, called when the resolve completes successfully.
// Prints the results.
{
    NSString *      argument;
    NSString *      result;
    
    if (resolver.name != nil) {
        argument = resolver.name;
        result   = [resolver.resolvedAddressStrings componentsJoinedByString:@", "];
        self.hostInfo = result;
        NSLog(@"Result: %@", result);
    } else {
        argument = resolver.addressString;
        result   = [resolver.resolvedNames componentsJoinedByString:@", "];
       self.hostInfo = result;
         NSLog(@"Result: %@", result);
    }
    // fprintf(stderr, "%s -> %s\n", [argument UTF8String], [result UTF8String]);
    self.runningResolverCount -= 1;
}

- (void)hostResolver:(QCFHostResolver *)resolver didFailWithError:(NSError *)error
// A resolver delegate callback, called when the resolve fails.  Prints the error.
{
    NSString *      argument;
    
    if (resolver.name != nil) {
        argument = resolver.name;
       self.hostInfo = argument;
        NSLog(@"%@",argument);
    } else {
        argument = resolver.addressString;
      self.hostInfo = argument;
    }
    NSLog(@"%@", argument);
    // fprintf(stderr, "%s -> %s / %zd\n", [argument UTF8String], [[error domain] UTF8String], (ssize_t) [error code]);
    self.runningResolverCount -= 1;
}

// Parse the host name and pull the store number return NULL if MAIS is not found
-(NSString*)parseStoreNumber:(NSString*)hostName
{
    NSLog(@"ParseStoreNumber has been call");
    if ([hostName rangeOfString:@"myHost"].location == NSNotFound)
    {
        hostName = @"NotFound";
        NSLog(@"Host server not found in ParseStoreNumber: Setting to NULL");
        return hostName;
    }else{
    
    NSLog(@"Parse Method started with: %@", hostName);
    NSRange prefex = [hostName rangeOfString:@"myHost"];
    NSRange append = [hostName rangeOfString:@"myHostTwo"];
    NSRange numberRange = NSMakeRange(prefex.location + 4, append.location - prefex.location - 4);
    NSString *storeNumber = [hostName substringWithRange:numberRange];
    
    return storeNumber;
    }

}

// pull host name out of the array that is not null
-(NSString*)returnHostName:(NSMutableArray*)hostArray
{
    NSLog(@"ReturnHostName excecuted");
    NSString *hostName = NULL;
    for(NSString *host in hostArray)
    {
        if(![host  isEqual: @"NotFound"]){
            NSLog(@" Host Name Found in HostArray: %@", host);
            hostName = host;
        }else{
            NSLog(@"No Host Name found in returnHostName Method");
        }
        
    }
    
    return hostName;
   
}
@end
