//
//  DetailViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 12/21/16.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailViewCell.h"
#import "HelpiHeldViewController.h"


@interface DetailViewController ()


@end



@implementation DetailViewController

@synthesize firmwareFile;
@synthesize scanMode;
@synthesize loginIndicator;

static NSString *settings[]={
    @"Beep upon scan",
    @"Enable scan button",
    @"Magnetic card raw mode",
    @"Synchronization enabled",
    @"Automated charge enabled",
    @"Barcode engine always on"
};

static NSString *scan_modes[]={
    @"Single scan",
    @"Multi scan",
    @"Motion detect",
    @"Single scan on button release",
    @"Multi scan without duplicates",
};


enum SETTINGS{
    SET_BEEP=0,
    SET_ENABLE_SCAN_BUTTON,
    SET_MSR_RAW,
    SET_SYNC_ENABLED,
    SET_AUTOCHARGING,
    SET_ENGINE_ON,
    SET_LAST
};


static BOOL settings_values[SET_LAST];
//static int scanMode;






//Defined targers for the IPC sled
#define TARGET_LINEA 0
#define TARGET_EMSR 1
#define TARGET_OPTICON 2
#define TARGET_CODE 3
#define TARGET_BARCODE 4


//Defined states for the Application
#define IHELD_INFO 0
#define SCANNER_MSR 1
#define SLED_MAINT 2
#define DATA_UPDATE 3
#define NOT_AUTHETICATED 4
#define ZEBRA_PRINTER 5
#define SELF_HELP 6


//Set for if the app should refresh Scroll State

#define SCROLLING 0
#define NOT_SCROLLING 1

//Should Segue For Warning
#define SHOW_WARRRING 0
#define SHOW_NO_WARRING 1

//System Sounds to play for firmware install
#define systemSoundID 1322
#define systemSoundID2 1106
#define systemSoundID3 1028

#ifndef IFT_ETHER
#  define IFT_ETHER 0x6
#endif

//Sounds for when the sled scans
int beep1[]={2730,250};
int beep2[]={2730,150,65000,20,2730,150};

- (void)viewDidLoad {
    [super viewDidLoad];


    
    //Setup load bar for Sled Maint View
    self.threadProgressView.hidden = TRUE;
    self.DetailTableView.delegate = self;
    self.DetailTableView.dataSource = self;
    self.threadProgressView.progress = 0.0;
    self.threadProgressView.progressTintColor = [UIColor colorWithRed:118.0/255 green:32.0/255 blue:19.0/255 alpha:1];
    self.threadProgressView.trackTintColor = [UIColor whiteColor];     CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    self.threadProgressView.transform = transform;
    loginIndicator.hidden = YES;
    
   
   msrState = @"Swipe Card";
   lastBarcodeType = @"Press Scan Button";
   lastBarcode = @"Scan Data: ";
    
    
    dtdev=[DTDevices sharedDevice];
    [dtdev addDelegate:self];
    [dtdev connect];
    
    
    // Setup Sled info Label based on connection
    
    if(dtdev.connstate!=CONN_CONNECTED)
    {
        //[self.sledConnectedSwitch setOn:NO];
        //_sledConnectedSwitch.backgroundColor = [UIColor redColor];
        _SledConnectedLabel.text = @"Sled is not connected";
        _SledConnectedLabel.textColor = [UIColor whiteColor];
        _SledConnectedLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:15];
        _SledConnectedLabel.backgroundColor = [UIColor redColor];
        CALayer * l1 = [_SledConnectedLabel layer];
        [l1 setMasksToBounds:YES];
        [l1 setCornerRadius:16.0];
        
        // You can even add a border
        [l1 setBorderWidth:5.0];
        [l1 setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.tableView reloadData];
        
    }else{
        _SledConnectedLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:15];
       // [self.sledConnectedSwitch setOn:YES];
        _SledConnectedLabel.text = @"Sled Connected";
        _SledConnectedLabel.textColor = [UIColor whiteColor];
        _SledConnectedLabel.backgroundColor = [UIColor greenColor];
        CALayer * l1 = [_SledConnectedLabel layer];
        [l1 setMasksToBounds:YES];
        [l1 setCornerRadius:16.0];
        
        // You can even add a border
        [l1 setBorderWidth:5.0];
        [l1 setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.tableView reloadData];
        
    }
    
    
    //Setup Static Labels
    
    _TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:25];
    _DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:18];
    
    _TitleLabel.text = _DetailModual[0];
    _DescriptionLabel.text = _DetailModual[1];
    _ImageView.image = [UIImage imageNamed:_DetailModual[2]];
    _TitleLabel.textColor = [UIColor whiteColor];
    _DescriptionLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.title = _DetailModual[0];
    
    
    // Set the backbutton
    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(upDateAuthTime)];
    
    [[self navigationItem] setBackBarButtonItem:NewBackButton];
    
    //Set the color for the view
    self.view.backgroundColor = _backGroundColor;
    self.tableView.backgroundColor = _backGroundColor;
    
    //Google Analytics Object
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"NULL"];
    
    //iHeld info View data
    if([_DetailModual[0]  isEqual: @"iHeld Information"]){
        
        AppState = IHELD_INFO;
       
        [self createiHeldDataArray];
        
        [tracker set:kGAIScreenName value:@"iHeld Info"];
        
    }
    
    // Scanner & MSR view data
    if([_DetailModual[0]  isEqual: @"Scanner & MSR Test"]){
        
      // [self setScannerInterface];
        
        AppState = SCANNER_MSR;
      
        _DetailTitle = @[@"Press scan button", @"Swipe a Card", @"",];
        
        _DetailDescription = @[@"Scan Data: ", @"Test MSR", @"",];
        _DetailImages = @[@"scanning.png", @"creditCard.png", @"",];
        
        [tracker set:kGAIScreenName value:@"Scanner MSR"];
    }
    
    // Sled Maint view
    if([_DetailModual[0]  isEqual: @"Sled Maintenance"]){
        
       
        BOOL success=[self checkLdapInfoDefaults];
        BOOL QAsuccess=[self checkOvrideForQA];
        
        if(success){
            AppState=SLED_MAINT;
            
            //Add info Button to UI
            [self setInfoButton];
            
            //Check to see if the user has seen the InfoView
            [self checkScannerEngineWarrning];
            
           [tracker set:kGAIScreenName value:@"Sled Maint Autheticated"];
            
        }else{

            AppState=NOT_AUTHETICATED;
            ShowWarrning=SHOW_WARRRING;
            
            [tracker set:kGAIScreenName value:@"Sled Maint NOT Autheticated"];
            
            if(QAsuccess){
                AppState=SLED_MAINT;
                ShowWarrning=SHOW_NO_WARRING;
                [tracker set:kGAIScreenName value:@"Sled Maint QA Autheticated"];
            }
        }
    
        
        
        // Commented out to remove SFTP. SFTP will be a future feature
      /*  _DetailTitle = @[@"Update Sled Firmware", @"Update Scanner Engine", @"IPC Sled Firm File Update", @"IPC Scaner Firm File Update", ];
        
        _DetailDescription = @[@"Tap Here", @"Tap Here", @"Check For New Firmware Files", @"Check For New Firmware Files",];
        _DetailImages = @[@"sled.png", @"scanning.png", @"settings.png", @"settings.png", ];
        
       */
        // Setup for Minimal viable product
        _DetailTitle = @[@"Update Sled Firmware", @"Update Scanner Engine", @"Set Scan Mode:Single", @"Factory Default Scanner", ];
        
        _DetailDescription = @[@"Tap Here", @"Tap Here", @"Tap Here", @"Tap Here",];
        _DetailImages = @[@"sled.png", @"scanning.png", @"scanning.png", @"scanning.png"];

    }
    //Zebra printer view data
    if([_DetailModual[0]  isEqual: @"Zebra Printers"]){
        
        AppState = ZEBRA_PRINTER;
        
        _DetailTitle = @[@"Test Pickup Printer", @"Test Printer", @"", ];
        
        _DetailDescription = @[@"Tap Here", @"Scan Printer Barcode", @"",];
        _DetailImages = @[@"printer.png", @"printer.png", @"", ];
        
        [tracker set:kGAIScreenName value:@"Zebra Printer"];
    }

    //Self help View data
    if([_DetailModual[0]  isEqual: @"Self Help"]){
        
        AppState = SELF_HELP;
        
        [tracker set:kGAIScreenName value:@"Self Help"];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        NSDate *currentTime = [NSDate date];
        NSString *tempTime = [timeFormat stringFromDate:currentTime];
        
        NSString *iHeldTime = [NSString stringWithFormat:@"Current iPod Time: %@", tempTime];
        NSString *tempSSID = [[IpodBuilder alloc]getCurrentNetwork];
        NSString *SSID;
        //check network
        if ([tempSSID  isEqual: @"YourSSID"] || [tempSSID  isEqual: @"YourSSID2"]||[tempSSID  isEqual: @"YourSSID3"]||[tempSSID  isEqual: @"YourSSID4"]||[tempSSID  isEqual: @"YourSSID5"]){
            
           SSID = [NSString stringWithFormat:@"Correct Network: %@", tempSSID];
            
        }else{
            
           SSID = @"Connect to the Your Network Network:Tap Here";
        }
       
        // Build the SlefHelp UI Data Arrays
        
        _DetailTitle = @[@"Check Date & Time", @"Network Check", @"Reset Seld", @"Check Sled Charge", ];
        
        _DetailDescription = @[iHeldTime, SSID, @"Tap Here For More Info", @"Tap For More Info",];
        _DetailImages = @[@"settings.png", @"settings.png", @"settings.png", @"settings.png",];
    }
    
    //Google Analytics Send Data
   [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//***********************Bellow is INTERFACE Logic**********************************
-(void)turnActivitySpinnerOn {
    
    
    loginIndicator.hidden = FALSE;
    [loginIndicator startAnimating];
  }

-(void)turnActivitySpinnerOFF {

    loginIndicator.hidden=TRUE;
    [loginIndicator stopAnimating];
}

-(bool)checkOvrideForQA{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *password=[defaults objectForKey:@"autheticate_value"];
    Boolean qaEnabled=[defaults boolForKey:@"enabled_QA"];
    
    if(qaEnabled){
        
        if([password isEqual:@"3333bev3333"])
        return YES;
    }
    
    

    return NO;
}

-(NSString*)getQAStoreNumber:(NSUserDefaults*)defaults{
    
     NSString *storeNumber=[defaults objectForKey:@"location"];
    
    
    return storeNumber;
}


-(void)setScannerInterface{
    
  [self.tableView sizeToFit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _DetailTitle.count;
}


//Method to build the table/cell view based on the applicaiton state
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    static NSString *CellIdentifer = @"DetailViewCell";
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *bgColorView = [[UIView alloc] init];
    
  
    int row = [indexPath row];
    
    switch (AppState) {
        case 0:
            // iHeld info View
           // [self createiHeldDataArray];
            cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
            cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
            cell.TitleLabel.textColor = [UIColor whiteColor];
            cell.DescriptionLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = _backGroundColor;
            cell.TitleLabel.text = _DetailTitle[row];
            cell.DescriptionLabel.text = _DetailDescription[row];
            cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [bgColorView setBackgroundColor:_selectColor];
            [cell setSelectedBackgroundView:bgColorView];
            
            break;
        case 1:
            // Test MSR view without update
            cell.accessoryType = UITableViewCellAccessoryNone;
            tableView.scrollEnabled = NO;
            cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
            cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
            cell.TitleLabel.textColor = [UIColor whiteColor];
            cell.DescriptionLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = _backGroundColor;
            cell.TitleLabel.text = _DetailTitle[row];
            cell.DescriptionLabel.text = _DetailDescription[row];
            cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
            cell.userInteractionEnabled = NO;
            tableView.bounces = FALSE;
          
            break;
        case 2:
            // Sled maint view with authetication
            cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
            cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
            cell.TitleLabel.textColor = [UIColor whiteColor];
            cell.DescriptionLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = _backGroundColor;
            cell.TitleLabel.text = _DetailTitle[row];
            cell.DescriptionLabel.text = _DetailDescription[row];
            cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
            cell.userInteractionEnabled = YES;
            [bgColorView setBackgroundColor:_selectColor];
            [cell setSelectedBackgroundView:bgColorView];
            tableView.bounces = YES;
            
            break;
        case 3:
           // Update view for testing MSR & Scanner
            cell.accessoryType = UITableViewCellAccessoryNone;
            _DetailTitle = @[lastBarcodeType, @"Test MSR", @"",];
            _DetailDescription = @[lastBarcode, msrState, @"",];
            cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
            cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
            cell.TitleLabel.textColor = [UIColor whiteColor];
            cell.DescriptionLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = _backGroundColor;
            cell.TitleLabel.text = _DetailTitle[row];
            cell.DescriptionLabel.text = _DetailDescription[row];
            cell.userInteractionEnabled = NO;
            tableView.bounces = FALSE;
            AppState = SCANNER_MSR; //JP - Check this
            
            break;
        case 4:
            tableView.bounces = YES;
            tableView.scrollEnabled = YES;
            //None autheticated Sled Maint View
            switch (indexPath.row) {
                case 0:
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.TitleLabel.text = _DetailTitle[0];
                    cell.DescriptionLabel.text = _DetailDescription[0];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[0]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    break;
                case 1 :
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _selectColor; // Selected color for user to know they cannot select this cell
                    cell.TitleLabel.text = _DetailTitle[1];
                    cell.DescriptionLabel.text = @"Manager or Supervisor Login Required";
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[1]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                
                    break;
                case 2 :
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _selectColor; // Selected color for user to know they cannot select this cell
                    cell.TitleLabel.text = _DetailTitle[2];
                    cell.DescriptionLabel.text = @"Manager or Supervisor Login Required";
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[2]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    
                    break;
                case 3 :
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _selectColor; // Selected color for user to know they cannot select this cell
                    cell.TitleLabel.text = _DetailTitle[3];
                    cell.DescriptionLabel.text = @"Manager or Supervisor Login Required";
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[3]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    
                    break;

            }
            break;
        case 5:
            tableView.bounces = NO;
            tableView.scrollEnabled = NO;
            
            //SNC Zebra Priner View
            switch (indexPath.row) {
                case 0:
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    break;
                case 1 :
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
                    cell.userInteractionEnabled = NO;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    
                    break;
                case 2 :
                   
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.backgroundColor = _backGroundColor;
                    cell.userInteractionEnabled = NO;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    break;
            }
            break;
        case 6:
            tableView.bounces = YES;
            tableView.scrollEnabled = YES;
            
            //Self Help View
            switch (indexPath.row) {
                case 0:
                    
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    break;
                case 1 :

                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
                    cell.userInteractionEnabled = YES;
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                    
                    break;
                default:
                    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
                    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.TitleLabel.textColor = [UIColor whiteColor];
                    cell.DescriptionLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = _backGroundColor;
                    cell.userInteractionEnabled = YES;
                    cell.TitleLabel.text = _DetailTitle[row];
                    cell.DescriptionLabel.text = _DetailDescription[row];
                    cell.ThumImage.image = [UIImage imageNamed: _DetailImages[row]];
                    [bgColorView setBackgroundColor:_selectColor];
                    [cell setSelectedBackgroundView:bgColorView];
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
 
                }
                break;
    }
    NSLog(@"Tabel/Cell Returned");
    [bgColorView removeFromSuperview];
    
    return cell;
}





//Apple Delegate that gets called when the user touches a cell within the tabel
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"TableView Did Selet Row called");
    NSInteger selectedRow = indexPath.row; //this is the number row that was selected
    
    switch (AppState){
            
        case 2: //Sled Maint view
            switch (selectedRow){
                    
                case 0:  fwUpdateTarget=TARGET_LINEA;
                    [self checkForLineaFirmwareUpdate];
                    
                    
                    break;
                case 1:   fwUpdateTarget=TARGET_BARCODE;
                    [self checkForNewlandFirmwareUpdate];
                    
                    break;
                case 2:
                    [self setToSingleScanMode];
                    
                    break;
                case 3:
                    [self restScannerToDefaults];
                    
                    break;
                    
            }
            break;
        case 4: //sled main not Autheticated
            switch (selectedRow){
                    
                case 0:
                    fwUpdateTarget=TARGET_LINEA;
                    [self checkForLineaFirmwareUpdate];
                    
                    break;
                    
                case 1:
                    [self moveToLdapLogIn];
                    
                    
                    break;
                case 2:
                    [self moveToLdapLogIn];
                    
                    break;
                case 3:
                    [self moveToLdapLogIn];
                    break;
                    
            }
            break;
        case 5: //Zebra View
            switch (selectedRow){
                    
                case 0:
                    
                    [self testMpuKioskPrinter];
                    
                    break;
               /* case 1:
                    
                    [self testZebraPrinter:@""]; //JP-TESTING
                    
                    break; */
                    
            }
            
        break;
    }
}
//Creats the iHeldinfoView Array data for the UI
-(void)createiHeldDataArray{
    
    
    IpodBuilder* iPod = [[IpodBuilder alloc]newiPod];
    
    NSString *newStoreNumber;
    
    NSLog(@"Device IP: %@", iPod.IP);
    
    if(![iPod.IP isEqual:@"0.0.0.0"]){
    
    NSLog(@"Calling getDNSServers in iHeldDataArray");
    newStoreNumber = [[HostData alloc] getDNSServers];
   
    }else{
        
    newStoreNumber = @"No location#: Check WiFi Connection";
    
    }


    if(dtdev.connstate!=CONN_CONNECTED){
        
        
        _DetailTitle = @[@"location Number", @"iHeld IP Address", @"Handheld Serial Number", @"Handheld WiFi", @"iOS Version", @"Sled Model", ];
        _DetailImages = @[@"store.png", @"sled.png", @"sled.png", @"sled.png",@"sled.png", @"scanning.png", @"scanning.png"];
        _DetailDescription = @[newStoreNumber, iPod.IP , iPod.serialNumber, iPod.SSID ,iPod.iOS, @"Sled Not Connected",];

        
    }else{
    
    NSError *error;
    NSString *scannerMode;
    NSString *name=[[dtdev.deviceName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    NSString *deviceModel=[dtdev.deviceModel stringByReplacingOccurrencesOfString:@"PM" withString:@"AM"];
    NSString *scannerFirmware = [self getBarcodeFirmwareVersion];
    NSString *scannerVersion = [self getBarcodeEngine];
    NSString *sledFirmware = [dtdev firmwareRevision];
    NSString *fullModel = [NSString stringWithFormat:@"%@ %@", name, deviceModel];
        
        if(![dtdev barcodeGetScanMode:&scanMode error:&error]){
            
            scanMode=0;
            scannerMode = @"Scan Mode: Failed";
        
        }else{
            
            scannerMode = @"Scan Mode: Single";
        }
        

        if(scannerVersion!=nil){
        
            if ([scannerVersion  isEqual: @"EM3000"]){
                NSRange rangeValueStart = [scannerFirmware rangeOfString:@"Firmware:" options:NSCaseInsensitiveSearch];
                NSRange rangeValueEnd = [scannerFirmware rangeOfString:@"Hardware:" options:NSCaseInsensitiveSearch];
                NSRange userIdSub = NSMakeRange(rangeValueStart.location + rangeValueStart.length, rangeValueEnd.location - rangeValueStart.location - rangeValueStart.length);
                NSString *temp = [scannerFirmware substringWithRange:userIdSub];
                scannerFirmware =[NSString stringWithFormat:@"Version:%@", temp];
            
            }
        }
        
        if([scannerVersion isEqual:@""]||scannerVersion==nil){
            
            scannerVersion=@"Engine Query Failed";
        }
        
        

    
        
        _DetailTitle = @[@"Location Number", @"Handheld IP Address", @"Handheld Serial Number", @"Handheld WiFi", @"iOS Version", @"Sled Model", @"Sled Firmware", @"Scanner Engine Model", @"Scanner Engine Firmware", @"Scan Mode",];
        _DetailImages = @[@"store.png", @"sled.png", @"sled.png", @"sled.png",@"sled.png", @"scanning.png", @"scanning.png", @"scanning.png", @"scanning.png", @"scanning.png" ];
        
        
        _DetailDescription = @[newStoreNumber, iPod.IP , iPod.serialNumber, iPod.SSID ,iPod.iOS ,fullModel , sledFirmware, scannerVersion, scannerFirmware, scannerMode];
    
      
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"PrepairForSegue called!");
    
    if(AppState == IHELD_INFO){
        
        if([[segue identifier] isEqualToString:@"HelpiHeldSegue"]){
            
            [self upDateAuthTime];
            
            HelpiHeldViewController *selfiHeldView= [segue destinationViewController];
            
            selfiHeldView.HelpiHeldTitle = _DetailTitle;
            selfiHeldView.HelpiHeldDescription = _DetailDescription;
            selfiHeldView.HelpiHeldImages = _DetailImages;
            selfiHeldView.backGroundColor = _backGroundColor;
            
            
            
        }
    }
    
    if(AppState == SELF_HELP){
        
        if([[segue identifier] isEqualToString:@"HelpiHeldSegue"]){
            
            [self upDateAuthTime];
            
            HelpiHeldViewController *selfiHeldView= [segue destinationViewController];
            
            selfiHeldView.HelpiHeldTitle = _DetailTitle;
            selfiHeldView.HelpiHeldDescription = _DetailDescription;
            selfiHeldView.HelpiHeldImages = _DetailImages;
            selfiHeldView.backGroundColor = _backGroundColor;
            selfiHeldView.selectColor = _selectColor;
        }
    }
    
    if(AppState==SLED_MAINT){
        
        if([[segue identifier] isEqualToString:@"HelpiHeldSegue"]){
            
            [self upDateAuthTime];
            
            InfoViewController *infoView=[segue destinationViewController];
            infoView.appState=&(AppState);
            
        }
        
    }
    
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    //check app state befor performing the Segue
    if (AppState == SELF_HELP){
        
        return YES;
    }
    
    if (AppState == IHELD_INFO){
        
        return YES;
    }
    
    if (AppState==SLED_MAINT){

        return NO;
    }
    return NO;
}

-(void)setInfoButton{
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
   [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.navigationItem setRightBarButtonItem:modalButton animated:YES];
}

-(void)infoButtonAction{
    
    [self performSegueWithIdentifier:@"information" sender:self];
}


//Check for LDAP info in NSUerDefaults
-(BOOL)checkLdapInfoDefaults{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"ldapInfo"]];
    
    _sledMaintWrng = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"NSDefaultsScanWarning"]];
    
    if(ldapUsrInfo==NULL){
        
        NSLog(@"No info in ldapUserInfo for checkLDAPInfo");

        return NO;
    
    }else{
        // check time and authication value
        NSLog(@"LDAP info found in NSUserDefaults");
        
        NSString *autheticated = [ldapUsrInfo objectForKey:@"Autheticated"];
        NSString *authTime = [ldapUsrInfo objectForKey:@"AuthTime"];
        
        
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        NSDate *ldapAuthTime = [[NSDate alloc] init];
        ldapAuthTime = [timeFormat dateFromString:authTime];
        
        NSDate *currentTime = [NSDate date];
        NSString *currentTime1 = [timeFormat stringFromDate:currentTime];
        currentTime = [timeFormat dateFromString:currentTime1];
        
        
        
        NSTimeInterval diff = [currentTime timeIntervalSinceDate:ldapAuthTime];
        
        float milliseconds = diff;
        float timeDiffrence = milliseconds / 60.0;
        float authTimeOut = 15.0;
        
        NSLog(@"Diffrence in milliseconds: %f Diffrence in minutes : %f", diff, timeDiffrence);
        
        if(timeDiffrence < authTimeOut && [autheticated  isEqual: @"YES"]){
            NSLog(@"Authetication approved:CheckLDAP");
            

            return YES;
        }else{
            NSLog(@"Autthenticaiton not approved:CheckLDAP");
            
            return NO;
        }
    }
}


//Move to LDAP ViewConroller
-(void)moveToLdapLogIn{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LdapLoginView" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LdapNav"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
}


//Update Auuthetication Time in NSUserDefaults
-(void)upDateAuthTime{
    
    NSLog(@"upDateAuthTime Called");
    BOOL success = [self checkLdapInfoDefaults];
    if (success){
        NSUserDefaults *temp = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[temp objectForKey:@"ldapInfo"]];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        NSDate *currentTime = [NSDate date];
        NSString *newAuthTime = [timeFormat stringFromDate:currentTime];
        [ldapUsrInfo setObject:newAuthTime forKey:@"AuthTime"];
        
    }
    
}

-(void)checkScannerEngineWarrning{
    
    if(ShowWarrning==SHOW_WARRRING){
        ShowWarrning=SHOW_NO_WARRING;
        [self infoButtonAction];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    if (AppState==SLED_MAINT){
        
    
    [dtdev addDelegate:self];
    [dtdev connect];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"***viewWillDisappear Being Called***");
    
   // [self dismissViewControllerAnimated:YES completion:nil];
    
    [super viewWillDisappear:animated];
    
    [dtdev removeDelegate:self];
    [dtdev disconnect];
        
    
    
}


//**********************Below is SFTP Logic***********************************



//Starts the SFTP Session to download firmware .BIN file
-(void)StartSFTPSession{
    
    
    
   if(dtdev.connstate==CONN_CONNECTED){
        
    NSString *deviceModel;
    NSString *SFTPDirectoryLookUp;
    NSString *hostIP = @"your-IP:22"; //SFTP Host
    NSString *user = @"Test";
    NSString *userPW = @"test";
    
    NSLog(@"SFTP Session Called");
    
    if (fwUpdateTarget == TARGET_LINEA){
       
        NSString *firstModelName = [dtdev.deviceModel stringByReplacingOccurrencesOfString:@"PM" withString:@"AM"];
        NSString *secondModelName = [[dtdev.deviceName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
        
        deviceModel = [NSString stringWithFormat:@"%@ %@", secondModelName, firstModelName];
        SFTPDirectoryLookUp = [NSString stringWithFormat:@"ls /SFTP/%@%@", secondModelName, firstModelName];
        
        
    }else if (fwUpdateTarget == TARGET_CODE){
        
        deviceModel = [self getBarcodeEngine];
        SFTPDirectoryLookUp = [NSString stringWithFormat:@"ls /SFTP/%@", deviceModel];
        
    }
    
    
    NMSSHSession *session = [NMSSHSession connectToHost:hostIP
                                           withUsername:user];
    
    if (session.isConnected) {
        [session authenticateByPassword:userPW];
        
        if (session.isAuthorized) {
            NSLog(@"Authentication succeeded");
            
            NSError *error = nil;
            
            NSString *file = [session.channel execute:SFTPDirectoryLookUp error:&error];
            
            
            NSLog(@"Files in Directory: %@", file);
            
            
          //  NSString *SFTPRootDirectory = [NSString stringWithFormat:@"/SFTP/%@/%@",deviceModel, file];
            NSString *SFTPRootDirectory = [NSString stringWithFormat:@"/SFTP/%@/%@",deviceModel, file];
            
            NMSFTP *sftp;
            sftp = [NMSFTP connectWithSession:session];
           _downloadFirmwareFile = [sftp contentsAtPath:SFTPRootDirectory];
            //int progress;
           //_downloadFirmwareFile = [sftp contentsAtPath:SFTPRootDirectory progress:progress];
           
            
            if (_downloadFirmwareFile != nil){
            [self startDownLoadFirmwareFlash];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!",nil)
                                                                message:NSLocalizedString(@"Unable to Download Firmware! ",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
                AudioServicesPlaySystemSound (systemSoundID3);
                [alert show];

            }
            
        }
    }else{
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!",nil)
                                                       message:NSLocalizedString(@"Not Able to Autheticate to Server!",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        AudioServicesPlaySystemSound (systemSoundID3);
       [alert show];
    }
     
   }else{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!",nil)
                                                    message:NSLocalizedString(@"Sled Is Not Connected",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        AudioServicesPlaySystemSound (systemSoundID3);
    [alert show];
   }
}

//Create File Directory for new Firmware file from SFTP
-(void)CreateFileDirectory{
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FirmwareFiles"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
}

//Check iPod File Directory for Firmware File
-(void)CheckIfFirmwareFileExsits{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FirmwareFiles"];
    path = [path stringByAppendingPathComponent:@"LINEAPro5_NBCM_01.05.63.00.BIN"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"Firmware File Found");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SFTP File",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Firmware Downloaded",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSLog(@"Firmware File Not Found");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SFTP File",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Firmware Did Not Download",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];

    }
    
    
    
    
}


//Flash Firmware check from SFTP need to combaind and make only one method
-(void)firmwareUpdateThreadSFTP:(NSData *)file{
    
    @autoreleasepool {
        
        
        NSError *error=nil;
        
        BOOL idleTimerDisabled_Old=[UIApplication sharedApplication].idleTimerDisabled;
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        
        if(fwUpdateTarget==TARGET_LINEA)
        {
            //[linea updateFirmwareData:[NSData dataWithContentsOfFile:file] error:nil];
            //In case authentication key is present in the Linea, we need to authenticate with it first, before firmware update is allowed
            //For the sample here I'm using the field "Authentication key" in the crypto settings as data and generally ignoring the result of the
            //authentication operation, firmware update will just fail if authentication have failed
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //last used decryption key is stored in preferences
            NSString *authenticationKey=[prefs objectForKey:@"AuthenticationKey"];
            
            if(authenticationKey==nil || authenticationKey.length!=32)
                authenticationKey=@"11111111111111111111111111111111"; //sample default
            
            
            [dtdev cryptoAuthenticateiPod:[authenticationKey dataUsingEncoding:NSASCIIStringEncoding] error:nil];
            [dtdev updateFirmwareData:file error:&error];
            
        }
        
        
        if(fwUpdateTarget==TARGET_EMSR)
        {
            [dtdev emsrUpdateFirmware:file error:&error];
        }
        
        if(fwUpdateTarget==TARGET_BARCODE)
        {
            
            if([dtdev getSupportedFeature:FEAT_BARCODE error:nil]==BARCODE_NEWLAND)
            {
                //[progressViewController performSelectorOnMainThread:@selector(updateText:) withObject:@"Updating engine...\nPlease wait!" waitUntilDone:NO];
                
                [dtdev barcodeNewlandUpdateFirmware:file error:&error];
                //[linea barcodeCodeUpdateFirmware:[self.firmwareFile lastPathComponent] data:[NSData dataWithContentsOfFile:self.firmwareFile] error:&error];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NO Barcode Engine Firmware",nil)
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"There is no barcode Firmware For this Scanner!",nil)]
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: idleTimerDisabled_Old];
        [self performSelectorOnMainThread:@selector(firmwareUpdateEnd:) withObject:error waitUntilDone:FALSE];
        
    }
}

//Flash SLED firmware from SFTP
-(void)startDownLoadFirmwareFlash{
    
    AudioServicesPlaySystemSound (systemSoundID);
    [self.view setUserInteractionEnabled:FALSE];
    
    self.threadProgressView.hidden = FALSE;
    [NSThread detachNewThreadSelector:@selector(firmwareUpdateThreadSFTP:) toTarget:self withObject:_downloadFirmwareFile];
    
    
}


//***************************Below is all Zebra Logic************************


-(void)testPickUpKioskPrinter{
 
    [self turnActivitySpinnerOn];
    
     NSString *newStoreNumber = [[HostData alloc] getDNSServers];
    
   GoogleFactory *googleAnalytics=[GoogleFactory alloc];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    bool success=[self checkOvrideForQA];
    if(success){
        
        NSLog(@"Checking Overide Info in testPickUpKioskPrinter");
        newStoreNumber=[self getQAStoreNumber:defaults];
        
    }
    
    if(newStoreNumber == nil){
        
        
       [googleAnalytics sendErrorMPUTestPrintEvent];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Pick UP Print Test:Error",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Store Number Not Found.\nCheck Network Connection",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];

        
    }else{
        
        BOOL printerSuccess = [[RestHandler alloc] sendMPUTestPrint:newStoreNumber];
        
        if(printerSuccess){
            
            [googleAnalytics sendMPUTestPrintEvent];
            
            NSLog(@"Pick Up Test Print returned 200");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Print Test Success",nil)message:[NSString stringWithFormat:NSLocalizedString(@"Test Print Succesfully Sent",nil)]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
       
        }else{
            
            [googleAnalytics sendErrorMPUTestPrintEvent];
            NSLog(@"Pick UP Test Print Error");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Pick UP Print Test:Error",nil)
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"Error Sending Test Print\nCheck Network Connection",nil)]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
   
    }
    
    [self turnActivitySpinnerOFF];
    
}


// Send SNC Printer Test Print
-(void)testZebraPrinter:(NSString*)barcode{
    
    [self turnActivitySpinnerOn];
    
    if(AppState==ZEBRA_PRINTER && (AppState!=DATA_UPDATE && AppState!=SCANNER_MSR)){
    
    NSString *newStoreNumber = [[HostData alloc] getDNSServers];
   
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    bool success=[self checkOvrideForQA];
    if(success){
        
        newStoreNumber=[self getQAStoreNumber:defaults];
        barcode=[defaults objectForKey:@"zebra_barcode"];
        
    }
    
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];
    
    if(newStoreNumber==nil){
        
       [googleAnalytics sendErrorSNCTestPrintEvent];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Printer:Error",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Store Number Not Found. Check Network Connection",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        
        
    }else{
        
        BOOL printerSuccess = [[RestHandler alloc] sendZebraTestPrint:newStoreNumber zebraSN:barcode];
        
        if(printerSuccess){
            
           [googleAnalytics sendSNCTestPrintEvent];
            
            NSLog(@"Zebra Test Print returned 200");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Test Print",nil)message:[NSString stringWithFormat:NSLocalizedString(@"Test Print Succesfully Sent",nil)]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            
            [googleAnalytics sendErrorSNCTestPrintEvent];
            
            NSLog(@"Zebra Test Print Error");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Printer:Error",nil)
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"SNC Printer is Offline\nOr out of Range",nil)]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            
            }
        
        
        }
    
    }
    
    [self turnActivitySpinnerOFF];
}


// *************************Below is all IPC Logic*******************************





//Sled Delegate Method that is called when the sled is connecting/connected or disconnects
-(void)connectionState:(int)state {
    NSError *error;
    
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            
            self.SledConnectedLabel.text = @"Sled is not connected";
            self.SledConnectedLabel.textColor = [UIColor whiteColor];
            self.SledConnectedLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:15];
            _SledConnectedLabel.backgroundColor = [UIColor redColor];
            
            break;
        case CONN_CONNECTED:
            //set defaults's
            
            _SledConnectedLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:15];
            _SledConnectedLabel.text = @"Sled Connected";
            _SledConnectedLabel.textColor = [UIColor whiteColor];
            _SledConnectedLabel.backgroundColor = [UIColor greenColor];
            CALayer * l1 = [_SledConnectedLabel layer];
            [l1 setMasksToBounds:YES];
            [l1 setCornerRadius:16.0];
            
            // You can even add a border
            [l1 setBorderWidth:5.0];
            [l1 setBorderColor:[[UIColor whiteColor] CGColor]];
            
            settings_values[SET_BEEP]=TRUE;
            
            //read settings
            int value;
            if([dtdev barcodeGetScanButtonMode:&value error:&error])
                settings_values[SET_ENABLE_SCAN_BUTTON]=(value==BUTTON_ENABLED);
            else
                settings_values[SET_ENABLE_SCAN_BUTTON]=FALSE;
            
            
            settings_values[SET_AUTOCHARGING]=[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoCharging"];
            settings_values[SET_ENGINE_ON]=[[NSUserDefaults standardUserDefaults] boolForKey:@"BarcodeEngineOn"];
            
            if(![dtdev barcodeGetScanMode:&scanMode error:&error]){
                scanMode=0;
            
            }
            
            
            break;
            
            
    }
    if(AppState==IHELD_INFO){
        [self createiHeldDataArray];
    }
    
    [self.tableView reloadData];
    
}

//IPC Delegate Method that gets call after a barcode scan
/*-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype{
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];

    
    switch (AppState){
        case 1:
        {
            lastBarcode = [NSString stringWithFormat:@"Scan Data: %@", barcode];
            lastBarcodeType = [NSString stringWithFormat:@"Barcode Type: %@", isotype];
            
            [googleAnalytics sendIPCScanTestEvent];
            
            [self.tableView reloadData];
        }
            break;
        case 5:
        {
            [self testZebraPrinter:barcode];
            break;
        }
        default:
            break;
    }
    
    
    
    
}*/

//IPC Delegate Method that gets call after a barcode scan
-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];
   
    switch (AppState){
        case 1:
        {
            AppState = DATA_UPDATE;
            lastBarcode = [NSString stringWithFormat:@"Scan Data: %@", barcode];
            NSString *temp = [dtdev barcodeType2Text:type];
            lastBarcodeType = [NSString stringWithFormat:@"Barcode Type: %@", temp];
            
            [googleAnalytics sendIPCScanTestEvent];
            
            [_tableView reloadData];
        }
            break;
        case 5:
        {
    
            [self testZebraPrinter:barcode];
        }
            break;
        default:
            break;
   }
    
    
    
}

//IPC Delegate Method that gets call after a MSR swipe
-(void)magneticCardRawData:(NSData *)tracks {
    //NSLog(@"raw data: %@",[self toHexString:(void *)[tracks bytes] length:[tracks length]]);
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];
    
    if (AppState == SCANNER_MSR){
        
        AppState = DATA_UPDATE;
        if (tracks !=nil){
            msrState = @"MSR is Working";
            int sound[]={2700,150,5400,150};
            [dtdev playSound:100 beepData:sound length:sizeof(sound) error:nil];
            
            [googleAnalytics sendIPCMSRTestEvent];
            
        }else{
            msrState = @"MSR is Not Working";
            
            [googleAnalytics sendErrorIPCMSRTestEvent];
        }
        [self.tableView reloadData];
    }
    
}

-(void)magneticCardEncryptedData:(int)encryption tracks:(int)tracks data:(NSData *)data {
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];
    
    if (AppState == SCANNER_MSR){
        
        AppState = DATA_UPDATE;
        if (data !=nil){
            msrState = @"MSR is Working";
            //int sound[]={2700,150,5400,150};
            int sound [] = {2730,150,65000,20,2730,150};
            [dtdev playSound:100 beepData:sound length:sizeof(sound) error:nil];
            
            [googleAnalytics sendIPCMSRTestEvent] ;
            
        }else{
            msrState = @"MSR is Not Working";
            
            [googleAnalytics sendErrorIPCMSRTestEvent];

        }
        [self.tableView reloadData];
    }
    
}

//Gets the firmware file name. Need to flash firmware & to
-(NSString *)getLineaFirmwareFileName{
    NSLog(@"getLineaFirmwareFileName");
    
    
    
    
    
    NSMutableString *s=[[NSMutableString alloc] init];
    NSError *error;
    NSString *name=[[dtdev.deviceName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    NSString *path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Firmware"];
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    
    int lastVer=0;
    NSString *lastPath;
    for(int i=0;i<[files count];i++)
    {
        NSString *file=[[files objectAtIndex:i] lastPathComponent];
        
        if([[file lowercaseString] hasSuffix:@".bin"])
        {
            if([[file lowercaseString] rangeOfString:name].location!=NSNotFound)
            {
                NSData *data=[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:file] options:nil error:&error];
                NSDictionary *info=[dtdev getFirmwareFileInformation:data error:&error];
                if(info)
                {
                    NSLog(@"file: %@, name=%@, model=%@",file,[info objectForKey:@"deviceName"],[info objectForKey:@"deviceModel"]);
                    [s appendFormat:@"file: %@, name=%@, model=%@\n",file,[info objectForKey:@"deviceName"],[info objectForKey:@"deviceModel"]];
                }
                if(info && [[info objectForKey:@"deviceName"] isEqualToString:dtdev.deviceName] && [self isDeviceModelEqual:[info objectForKey:@"deviceModel"]]/*[[info objectForKey:@"deviceModel"] isEqualToString:dtdev.deviceModel] */&& [[info objectForKey:@"firmwareRevisionNumber"] intValue]>lastVer)
                {
                    lastPath=[path stringByAppendingPathComponent:file];
                    lastVer=[[info objectForKey:@"firmwareRevisionNumber"] intValue];
                }
            }
        }
    }
    
    NSLog(@"Firmware update called");
    
    
    if(lastVer>0)
        return lastPath;
    return nil;
}

-(bool)isDeviceModelEqual:(NSString *)model
{
    NSString *deviceModel=[dtdev.deviceModel stringByReplacingOccurrencesOfString:@"PM" withString:@"AM"];
    
    if(model.length!=deviceModel.length)
        return false;
    
    for(int i=0;i<model.length;i+=2)
    {
        NSString *feat=[model substringWithRange:NSMakeRange(i,2)];
        if([deviceModel rangeOfString:feat].length==0)
            return false;
    }
    return true;
}


//Catches the user input from the alater before the firmware flash
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        AudioServicesPlaySystemSound (systemSoundID);
        [self.view setUserInteractionEnabled:FALSE];
        
        self.threadProgressView.hidden = FALSE;
        [NSThread detachNewThreadSelector:@selector(firmwareUpdateThread:) toTarget:self withObject:firmwareFile];
        
        
    }
}


//Starts the firemare update for the target device. Must be within the same view of the current object
-(void)firmwareUpdateThread:(NSString *)file{
    
   
    @autoreleasepool {
        
       GoogleFactory *googleAnalytics=[GoogleFactory alloc];
        
        NSError *error=nil;
        
        BOOL idleTimerDisabled_Old=[UIApplication sharedApplication].idleTimerDisabled;
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        
        if(fwUpdateTarget==TARGET_LINEA)
        {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //last used decryption key is stored in preferences
            NSString *authenticationKey=[prefs objectForKey:@"AuthenticationKey"];
            
            if(authenticationKey==nil || authenticationKey.length!=32)
                authenticationKey=@"11111111111111111111111111111111"; //sample default
            
            
            [dtdev cryptoAuthenticateiPod:[authenticationKey dataUsingEncoding:NSASCIIStringEncoding] error:nil];
            
            [googleAnalytics sendFirmwareFlashEvent];
            
            [dtdev updateFirmwareData:[NSData dataWithContentsOfFile:file] error:&error];
            
        }
        
        
        if(fwUpdateTarget==TARGET_EMSR)
        {
            [dtdev emsrUpdateFirmware:[NSData dataWithContentsOfFile:file] error:&error];
        }
        
        if(fwUpdateTarget==TARGET_BARCODE)
        {
            
            if([dtdev getSupportedFeature:FEAT_BARCODE error:nil]==BARCODE_NEWLAND)
            {
                [googleAnalytics sendFirmwareEngineFlashEvent];
                [dtdev barcodeNewlandUpdateFirmware:[NSData dataWithContentsOfFile:file] error:&error];
                
            }else {
                
                [googleAnalytics sendErrorFirmwareEngineFlashEvent];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NO Barcode Engine Firmware",nil)
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"There is no barcode Firmware For this Scanner!",nil)]
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: idleTimerDisabled_Old];
        [self performSelectorOnMainThread:@selector(firmwareUpdateEnd:) withObject:error waitUntilDone:FALSE];
        
    }
}

//checks for the firmware file before updating
-(void)checkForLineaFirmwareUpdate{
    
 
    
    self.firmwareFile=[self getLineaFirmwareFileName];
    if(self.firmwareFile==nil)
    {
        
         GoogleFactory *googleAnalytics=[GoogleFactory alloc];
         [googleAnalytics sendErrorFirmwareFlashEvent];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Firmware Update",nil)
                                                        message:NSLocalizedString(@"No firmware for this device model present",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];
    }else {
        NSDictionary *info=[dtdev getFirmwareFileInformation:[NSData dataWithContentsOfFile:self.firmwareFile] error:nil];
        
        if(info && [[info objectForKey:@"deviceName"] isEqualToString:dtdev.deviceName] && [[info objectForKey:@"deviceModel"] isEqualToString:dtdev.deviceModel])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Firmware Update",nil)
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"Linea ver: %@\nAvailable: %@\n\nDo you want to update firmware?\n\nDO NOT DISCONNECT LINEA DURING FIRMWARE UPDATE!",nil),[dtdev firmwareRevision],[info objectForKey:@"firmwareRevision"]]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"Update",nil), nil];
            
            [alert show];
        }else {
            
            GoogleFactory *googleAnalytics=[GoogleFactory alloc];
            [googleAnalytics sendErrorFirmwareFlashEvent];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Firmware Update",nil)
                                                            message:NSLocalizedString(@"No firmware for this device model present",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


//Checks for the scanner engine firmware before updating
/*-(void)checkForNewlandFirmwareUpdate{
    //engine may be dead and still able to update just fine so ignore errors trying to query the info
    NSError *error;
    NSData *r;
    
    NSString *ident=@"Engine query failed";
    NSString *engine=@"";
    
    r=[dtdev barcodeNewlandQuery:[@"3G" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
    if(r)
    {
        NSString *ver=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
        
        r=[dtdev barcodeNewlandQuery:[@"3H030" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
        if(r)
        {
            engine=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
            if([engine rangeOfString:@"EB"].location!=NSNotFound)
                engine=@"EM3070";
            if([engine rangeOfString:@"ES"].location!=NSNotFound)
                engine=@"EM3096";
            if([engine rangeOfString:@"E3"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"0300"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"EW"].location!=NSNotFound)
                engine=@"EM3090";
            
            ident=[NSString stringWithFormat:@"Engine: %@\nVersion: %@\n",engine,ver];
        }
    }
    
    if(![ident isEqual:@"Engine query failed"]){
        
        if([self getFilesWithPrefix:[@"newland_" stringByAppendingString:engine] orPrefix:@"" extension:@".bin"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Firmware Update",nil)
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"%@\n\nDo you want to update firmware?\n\nDO NOT DISCONNECT DEVICE DURING FIRMWARE UPDATE!",nil),ident]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
            for (NSString *file in firmwareFiles)
                self.firmwareFile = file;
            [alert addButtonWithTitle:[[self.firmwareFile lastPathComponent] substringFromIndex:@"newland_".length]];
            
            [alert show];
            
            
            
        }
        
    }else
        
        [self displayAlert:@"Scanner Error" message:[NSString stringWithFormat:@"%@\n\n Cannot Connect to the\nScanner Engine ",ident]];
    
    
} */

-(void)checkForNewlandFirmwareUpdate;
{
    //engine may be dead and still able to update just fine so ignore errors trying to query the info
    NSError *error;
    NSData *r;
    
    NSString *ident=@"Engine query failed";
    NSString *engine=@"";
    
    r=[dtdev barcodeNewlandQuery:[@"3G" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
    if(r)
    {
        NSString *ver=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
        
        r=[dtdev barcodeNewlandQuery:[@"3H030" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
        if(r)
        {
            engine=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
            if([engine rangeOfString:@"EB"].location!=NSNotFound)
                engine=@"EM3070";
            if([engine rangeOfString:@"ES"].location!=NSNotFound)
                engine=@"EM3096";
            if([engine rangeOfString:@"E3"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"0300"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"EW"].location!=NSNotFound)
                engine=@"EM3090";
            
            ident=[NSString stringWithFormat:@"Engine: %@\nVersion: %@\n",engine,ver];
        }
    }
    
    if([self getFilesWithPrefix:[@"newland_" stringByAppendingString:engine] orPrefix:@"" extension:@".bin"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Firmware Update",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"%@\n\nDo you want to update firmware?\n\nDO NOT DISCONNECT DEVICE DURING FIRMWARE UPDATE!",nil),ident]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
        for (NSString *file in firmwareFiles)
            self.firmwareFile = file;
        [alert addButtonWithTitle:[[self.firmwareFile lastPathComponent] substringFromIndex:@"newland_".length]];
        
        [alert show];
    }else
        [self displayAlert:@"Scanner Error" message:[NSString stringWithFormat:@"%@\n\n Cannot Connect to the\nScanner Engine ",ident]];
}

//Find the firmeare file for the target device
-(BOOL)getFilesWithPrefix:(NSString *)prefix orPrefix:(NSString *)otherPrefix extension:(NSString *)extension
{
    prefix=[prefix lowercaseString];
    otherPrefix=[otherPrefix lowercaseString];
    
    NSString *path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Firmware"];
    
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    firmwareFiles=[NSMutableArray array];
    
    for(int i=0;i<[files count];i++)
    {
        NSString *file=[[files objectAtIndex:i] lastPathComponent];
        if(([[file lowercaseString] hasPrefix:prefix] || [[file lowercaseString] hasPrefix:otherPrefix]) && [[file lowercaseString] hasSuffix:extension])
        {
            [firmwareFiles addObject:[path stringByAppendingPathComponent:[files objectAtIndex:i]]];
        }
    }
    return firmwareFiles.count!=0;
}

//General UIalert called in multiple methods/fucntions
-(void)displayAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
}


//Called once the firmeare
-(void)firmwareUpdateEnd:(NSError *)error
{
    
    AudioServicesPlaySystemSound (systemSoundID2);
    
    [self.view setUserInteractionEnabled:TRUE];
    self.threadProgressView.hidden = TRUE;
    if(error)
        [self displayAlert:NSLocalizedString(@"Firmware Update",nil) message:[NSString stringWithFormat:NSLocalizedString(@"Firmware updated failed with error:%@",nil),error.localizedDescription]];
    if(fwUpdateTarget==TARGET_BARCODE){
        
        [self setToSingleScanMode];
    }
}


//Updates sled firmware install progress bar
-(void)firmwareUpdateDisplayProgress{
    
    
    switch (progressPhase)
    {
        case UPDATE_INIT:
            [_threadProgressView setProgress:(float)progressPercent/100];
            _SledConnectedLabel.text = @"Initializing Update";
            break;
        case UPDATE_ERASE:
            [_threadProgressView setProgress:(float)progressPercent/100];
            _SledConnectedLabel.text = @"Erasing Flash";
            break;
        case UPDATE_WRITE:
            [_threadProgressView setProgress:(float)progressPercent/100];
            _SledConnectedLabel.text = [NSString stringWithFormat:@"Writing Firmware %i%%",progressPercent];
            break;
        case UPDATE_COMPLETING:
            [_threadProgressView setProgress:(float)progressPercent/100];
            _SledConnectedLabel.text = @"Completing Update";
            break;
        case UPDATE_FINISH:
            [_threadProgressView setProgress:(float)progressPercent/100];
            _SledConnectedLabel.text = @"Done!";
            break;
    }
}

//Called when you update any firmware
-(void)firmwareUpdateProgress:(int)phase percent:(int)percent
{
    NSLog(@"firmwareUpdateProgress Called");
    
    
    progressPhase=phase;
    progressPercent=percent;
    [self performSelectorOnMainThread:@selector(firmwareUpdateDisplayProgress) withObject:nil waitUntilDone:FALSE];
    
}



-(NSString*)getBarcodeEngine{
    //engine may be dead and still able to update just fine so ignore errors trying to query the info
    NSError *error;
    NSData *r;
    
    NSString *ident=@"Engine Query Failed";
    NSString *engine=@"";
    
    r=[dtdev barcodeNewlandQuery:[@"3G" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
    if(r)
    {
        NSString *ver=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
        
        r=[dtdev barcodeNewlandQuery:[@"3H030" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
        if(r)
        {
            engine=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
            if([engine rangeOfString:@"EB"].location!=NSNotFound)
                engine=@"EM3070";
            if([engine rangeOfString:@"ES"].location!=NSNotFound)
                engine=@"EM3096";
            if([engine rangeOfString:@"E3"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"0300"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"EW"].location!=NSNotFound)
                engine=@"EM3090";
            
            ident=[NSString stringWithFormat:@"Engine: %@\nVersion: %@\n",engine,ver];
        }
    }
    return engine;
}

//Gets the scanner engine version for the UI
-(NSString*)getBarcodeFirmwareVersion{
    //engine may be dead and still able to update just fine so ignore errors trying to query the info
    NSError *error;
    NSData *r;
    
    NSString *ident=@"Engine Query Failed";
    NSString *engine=@"";
    
    r=[dtdev barcodeNewlandQuery:[@"3G" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
    if(r)
    {
        NSString *ver=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
        
        r=[dtdev barcodeNewlandQuery:[@"3H030" dataUsingEncoding:NSASCIIStringEncoding] error:&error];
        if(r)
        {
            engine=[[NSString alloc] initWithData:r encoding:NSASCIIStringEncoding];
            if([engine rangeOfString:@"EB"].location!=NSNotFound)
                engine=@"EM3070";
            if([engine rangeOfString:@"ES"].location!=NSNotFound)
                engine=@"EM3096";
            if([engine rangeOfString:@"E3"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"0300"].location!=NSNotFound)
                engine=@"EM3000";
            if([engine rangeOfString:@"EW"].location!=NSNotFound)
                engine=@"EM3090";
            
            ident=[NSString stringWithFormat:@"Version: %@\n",ver];
        }
    }
    return ident;
}

-(void)setToSingleScanMode{
    
    NSError *error;
    scanMode=0;
    
    bool scannerMode = [dtdev barcodeSetScanMode:MODE_SINGLE_SCAN error:&error];
    
    if(scannerMode==false){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Scanner Error",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Error Setting Scan Mode: %@",&error)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Scanner Success",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Scanner Set to Single Scan Mode",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

-(void)restScannerToDefaults{
    
    [self turnActivitySpinnerOn];
    
    GoogleFactory *googleAnalytics=[GoogleFactory alloc];
    
    NSError *error;
    
    bool success = [dtdev barcodeEngineResetToDefaults:&error];
    
    if(success){
        
        
        [googleAnalytics sendEngineResetEvent];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Scanner Success",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Scanner set to Defaults",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];

    }else{
        
        
        [googleAnalytics sendErrorEngineResetEvent];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Scanner Error",nil)
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Could Not Set to Defaults",nil)]
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil];
        [alert show];

    }
    
    [self turnActivitySpinnerOFF];
}




@end
