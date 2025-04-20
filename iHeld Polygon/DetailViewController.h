//
//  DetailViewController.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDevices.h"
#import <Foundation/Foundation.h>
#import "DetailTableView.h"
#import <AudioToolbox/AudioServices.h>
#import <Google/Analytics.h>
#import "HostData.h"
#import "RestHandler.h"
#import "IpodBuilder.h"
#import "InfoViewController.h"
#import "GoogleFactory.h"


//@interface DetailViewController : UITableViewController <DTDeviceDelegate>{
@interface DetailViewController : UIViewController <DTDeviceDelegate, UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate, UIPopoverControllerDelegate>{
    //Instince of sled class
    DTDevices *dtdev;
    NSString *lastBarcode;
    NSString *lastBarcodeType;
    NSString *msrState;
    //App State
    int AppState;
    int scroll;
    int ShowWarrning;
    int fwUpdateTarget;
    NSMutableArray *firmwareFiles;
    
    int progressPhase;
    int progressPercent;
    
    

}

//Interface props

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;


@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (readwrite, nonatomic) NSArray *DetailModual;

//@property (strong, nonatomic) IBOutlet UISwitch *sledConnectedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *SledConnectedLabel;

@property (readwrite, nonatomic)  UITableView *DetailTableView;

@property (weak, nonatomic) IBOutlet DetailTableView *tableView;

@property (weak, nonatomic) IBOutlet UIProgressView * threadProgressView;
//sled props
@property(nonatomic,copy) NSString *firmwareFile;
@property(nonatomic,copy) NSData *downloadFirmwareFile;
@property(assign) int scanMode;

-(void)createiHeldDataArray;


// Interface state Arrays
@property (nonatomic, readwrite) NSArray *DetailImages;
@property (nonatomic, readwrite) NSArray *DetailTitle;
@property (nonatomic, readwrite) NSArray *DetailDescription;

//UI colors
@property (nonatomic, readwrite) UIColor *backGroundColor;
@property (nonatomic, readwrite) UIColor *selectColor;

@property (nonatomic, readwrite) NSMutableDictionary *sledMaintWrng;



@end
