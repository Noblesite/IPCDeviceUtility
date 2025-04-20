//
//  TicketFactory.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketFactory : NSObject


-(NSData*)getPrinterTicket:(NSInteger)ticketNum;

@end

