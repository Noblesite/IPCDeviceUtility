//
//  TicketFactory.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "TicketFactory.h"

@implementation TicketFactory


-(NSData*)getPrinterTicket:(NSInteger)ticketNum{
    
    NSLog(@"getPrinterTicket Called");
   
    NSData *ticket=[NSData alloc];
    
    switch (ticketNum) {
        case 0:
            
           ticket=[self stageTicket];

            break;
            
        case 1:
            
            ticket=[self lockerPin];
            
            break;

            
        default:
            
            ticket=[self stageTicket];
            
            break;
    }
    
    
    
    NSLog(@"***Retrun Ticket from TicketFctory***");
    
    
    
    return ticket;
}


- (NSData*)stageTicket{
    
    NSString *jsonString=@"{\"phoneNumber\":\"2562562\",\"deliveryType\":\"A\",\"registerNum\":null,\"itemlocation\":\"FLR\",\"sku\":\"000\",\"storeNumber\":null,\"quantity\":1,\"altAreaCode\":\"000\",\"exchangeFlag\":\"false\",\"upc\":null,\"orderId\":\"013335313175\",\"listOfItems\":null,\"itemDescription\":\"COMPACTOR\",\"lastName\":\"PRINT\",\"paymentMapList\":null,\"tranNum\":null,\"taxAmount\":null,\"line\":null,\"transactiontype\":\"A\",\"assocDiscount\":null,\"dotComOrderNumber\":null,\"itemNum\":\"13601\",\"stockLocation\":null,\"destination\":\"STG\",\"taskType\":null,\"reprint\":\"false\",\"inquiryType\":null,\"timeRecieved\":null,\"itemIndex\":1,\"plus4\":null,\"transactionDate\":null,\"storeInfoMap\":null,\"requestId\":null,\"numberOfPackages\":null,\"customerName\":null,\"returnReason\":null,\"emailAddress\":null,\"m_location\":null,\"origin\":\"\",\"listOfPackages\":null,\"areaCode\":\"256\",\"restockingFee\":null,\"originalIdentifier\":null,\"binnumber\":null,\"relatedTransactionId\":null,\"altPhoneNumber\":\"0000000\",\"amount\":null,\"expirationTime\":1482498067000,\"notifyCount\":null,\"subLineVariable\":null,\"m_title\":null,\"associateNumber\":\"000075\",\"division\":\"022\",\"itemCount\":1,\"m_barcode\":null,\"sellPrice\":0,\"subLine\":null,\"saleType\":null,\"firstName\":\"TEST\"}";
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    return jsonData;
}

- (NSData*)lockerPin{
    
    NSLog(@"lockerPint Called");
    
  
    
    NSString *jsonString=@"{\"pinNumber\":\"123456\",\"firstName\":\"TEST\",\"lastName\":\"HELP\",\"printerId\":\"12341\"}";
    
  
    NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    return jsonData;
}

@end
