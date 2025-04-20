//
//  RestHandler.h
//  RESTest
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <foundation/foundation.h>
#import "TicketFactory.h"
#import <UIKit/UIKit.h>


@interface RestHandler : NSURLConnection <NSURLConnectionDelegate>


- (BOOL)sendPickUpTestPrint:(NSString*)storeNumber;
- (BOOL)sendZebraTestPrint:(NSString*)storeNumber zebraSN:(NSString*)serialNumber;


@end
