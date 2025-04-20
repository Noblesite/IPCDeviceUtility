//
//  TableViewController.h
//  iHeld_Polygone
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "DTDevices.h"

@interface TableViewController : UITableViewController<DTDeviceDelegate>{
    DTDevices *dtdev;
    CGRect cellRecStart;
    int AppState;
}

@property (nonatomic, strong) NSArray *Images;
@property (nonatomic, strong) NSArray *Title;
@property (nonatomic, strong) NSArray *Description;
@property(assign) int scanMode;
@property(assign) int cTextState;

@property (nonatomic, strong) UIColor *iHeldColor;
@property (nonatomic, strong) UIColor *iHeldSelectColor;
@property (nonatomic, strong) UIColor *scannerMsrTestColor;
@property (nonatomic, strong) UIColor *scannerMsrTestSelectColor;
@property (nonatomic, strong) UIColor *sledMaintColor;
@property (nonatomic, strong) UIColor *sledMaintSelectColor;
@property (nonatomic, strong) UIColor *zebraPrinterColor;
@property (nonatomic, strong) UIColor *zebraPrinterSelectColor;
@property (nonatomic, strong) UIColor *selfHelpColor;
@property (nonatomic, strong) UIColor *selfHelpSelectColor;


-(void) LdapLogIn:(UIBarButtonItem*) sender;

@end
