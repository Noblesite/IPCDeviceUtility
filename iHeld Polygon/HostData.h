//
//  HostData.h
//  DNSTest2
//
//  Created by Jonathon Poe on 10/7/16.
//  Copyright © 2016 Noblesite. All rights reserved.
//

#include <netinet/in.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>
#include <netdb.h>
#include "QCFHostResolver.h"
#import <UIKit/UIKit.h>


@interface HostData : NSObject

@property (nonatomic, strong) NSMutableArray *hostNames;
@property (retain, nonatomic) NSString *hostInfo;
@property (nonatomic, copy,   readonly ) NSArray *resolvers;
@property (nonatomic, copy, readwrite) NSMutableArray *dNSip;

-(id)initWithResolvers:(NSArray *)resolvers;
-(NSString*) getDNSServers;
-(NSString*)parseStoreNumber:(NSString*)hostName;
-(void)run;
-(NSString*)returnHostName:(NSMutableArray*)hostArray;

@end

