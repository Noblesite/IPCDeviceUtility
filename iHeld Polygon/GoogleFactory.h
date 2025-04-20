//
//  GoogleFactory.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/Analytics.h>


@interface GoogleFactory : NSObject

-(void)sendFirmwareFlashEvent;
-(void)sendFirmwareEngineFlashEvent;
-(void)sendEngineResetEvent;
-(void)sendSNCTestPrintEvent;
-(void)sendMPUTestPrintEvent;
-(void)sendIPCScanTestEvent;
-(void)sendIPCMSRTestEvent;

-(void)sendErrorFirmwareFlashEvent;
-(void)sendErrorFirmwareEngineFlashEvent;
-(void)sendErrorEngineResetEvent;
-(void)sendErrorSNCTestPrintEvent;
-(void)sendErrorMPUTestPrintEvent;
-(void)sendErrorIPCScanTestEvent;
-(void)sendErrorIPCMSRTestEvent;

@end
