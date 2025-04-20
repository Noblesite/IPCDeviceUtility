//
//  RestHandler.m
//  RESTest
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "RestHandler.h"
#import <UIKit/UIKit.h>


@interface RestHandler () <NSURLConnectionDelegate>


@end

@implementation RestHandler


- (BOOL)sendPickUpTestPrint:(NSString*)storeNumber{
    
   
    NSData *jsonData = [[TicketFactory alloc]getPrinterTicket:1];
    

    NSString *postLength = [NSString stringWithFormat:@"%d",[jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    
    
    bool success=[self checkOvrideForQA];
    
    NSString *urlString;
    
    if(success){
        
        NSLog(@"QA Overide set for MPU Test Print");
        urlString = [NSString stringWithFormat:@"https://qa.example.com/print/lockerTicket/0%@/locker", storeNumber];
        
    }else{
        
        NSLog(@"Production URL Set for MPU Test Print");
        urlString = [NSString stringWithFormat:@"https://prod.example.com/print/lockerTicket/0%@/locker", storeNumber];
        
    }
    
    NSLog(@"URL for MPU Request: %@",urlString);
  
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length" ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    NSLog(@"JSON Summary: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
  //  NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[theConnection start];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"****Request Sent*********");
    
    
    NSLog(@"Response Error= %@", response);
    NSString *jsonString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    if ([response statusCode] == 200)
    {
        NSLog(@"Test Print Return Response: %@", jsonString);
        return true;
    }
    
    NSLog(@"Test Print Return Response: %@", jsonString);
    return false;
}





//___________________________ Zebra Logic ___________________________________

//Send Zebra Test Print
- (BOOL)sendZebraTestPrint:(NSString*)storeNumber zebraSN:(NSString*)serialNumber{
    
    
    //Check TicketFactory for list of Tickets & returns a NSData
   NSData *jsonData = [[TicketFactory alloc]getPrinterTicket:0];

    
    NSString *postLength = [NSString stringWithFormat:@"%d",[jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
   
    
    //Checking for QA overide of webservice URL in Bunddle Settings
    bool success=[self checkOvrideForQA];
    
    NSString *urlString;
    
    if(success){
        
        NSLog(@"QA Overide set for Zebra Test Print");
        urlString = [NSString stringWithFormat:@"http://qa.example.com/print/%@/0%@?type=StageTicket", serialNumber, storeNumber];
        
    }else{
        
        NSLog(@"Production URL Set for Zebra Test Print");
        urlString = [NSString stringWithFormat:@"http://prod.example.com/print/%@/0%@?type=StageTicket", serialNumber, storeNumber];
        
    }
     [request setURL:[NSURL URLWithString:urlString]];
    
    
    NSLog(@"Request URL for Zeber Test Print: %@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:jsonData];
    
    NSLog(@"JSON Data Summary: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    //NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[theConnection start];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    
    NSLog(@"Web Service Response Error= %@", response);
    NSString *jsonString2 = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    if ([response statusCode] == 200)
    {
        NSLog(@"*****Zebra Test Print Return Response*****: %@", jsonString2);
        return true;
    }
    
    
    NSLog(@"Zebra Test Print Error");
    

    NSLog(@"Zebra Test Print Return Response: %@", jsonString2);

    return false;
}


-(bool)checkOvrideForQA{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *password=[defaults objectForKey:@"autheticate_value"];
    Boolean qaEnabled=[defaults boolForKey:@"enable_QA_URL"];
    
    if(qaEnabled){
        
        if([password isEqual:@"3333bev3333"])
            return YES;
    }
    
    
    
    return NO;
}
@end
