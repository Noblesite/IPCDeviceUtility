//
//  GoogleFactory.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "GoogleFactory.h"

@implementation GoogleFactory



-(void)sendCurrentViewController:(NSString*)name{
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)sendFirmwareFlashEvent{
    
   NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    

    NSString *category = [NSString stringWithFormat:@"SledFirmwareFlash : %@",currentTime1];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}


-(void)sendFirmwareEngineFlashEvent{
    
    
   NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
     NSString *category = [NSString stringWithFormat:@"FirmwareEngineFlash : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}

-(void)sendEngineResetEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
     NSString *category = [NSString stringWithFormat:@"EngineReset : %@",currentTime1];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}

-(void)sendMPUTestPrintEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"MPUTestPrint : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}
-(void)sendSNCTestPrintEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"SNCTestPrint : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}


-(void)sendIPCScanTestEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"BarCode Test Scan : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}

-(void)sendIPCMSRTestEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"MSR Test Swipe : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"SUCCESS"
                                                           value:@1] build]];
    
}


//********************************** Error Events ***************************************************

-(void)sendErrorFirmwareFlashEvent{
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    NSString *category = [NSString stringWithFormat:@"SledFirmwareFlash : %@",currentTime1];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}


-(void)sendErrorFirmwareEngineFlashEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"FirmwareEngineFlash : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}

-(void)sendErrorEngineResetEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"EngineReset : %@",currentTime1];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}

-(void)sendErrorMPUTestPrintEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"MPUTestPrint : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}
-(void)sendErrorSNCTestPrintEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"SNCTestPrint : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}


-(void)sendErrorIPCScanTestEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"BarCode Test Scan : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}

-(void)sendErrorIPCMSRTestEvent{
    
    
    NSString *userName=[self getUserName];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *currentTime = [NSDate date];
    NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
    
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    
    NSString *category = [NSString stringWithFormat:@"MSR Test Swipe : %@",currentTime1];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:userName
                                                           label:@"ERROR"
                                                           value:@1] build]];
    
}




-(NSString*)getUserName{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"ldapInfo"]];

    if(ldapUsrInfo==NULL){
        NSLog(@"No Information found in NSUserDefaults");
        return @"User Not Found";
    }else{
    // check time and authication value
        NSLog(@"LDAP info found in NSUserDefaults");
        
    NSString *locationNumber=[ldapUsrInfo objectForKey:@"unitNumber"];
    NSString *firstName=[ldapUsrInfo objectForKey:@"firstName"];
    NSString *lastName=[ldapUsrInfo objectForKey:@"lastName"];
    NSString *name=[NSString stringWithFormat:@"%@ %@ Store: %@",firstName,lastName,locationNumber];
    
        return name;
    }

}


@end
