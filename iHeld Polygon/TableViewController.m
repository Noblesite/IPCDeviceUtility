//
//  TableViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import "LdapLoginViewController.h"
#import "LdapUserViewController.h"


@interface TableViewController ()

@end

@implementation TableViewController

@synthesize scanMode;
@synthesize cTextState;


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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the Colors for the UI
    [self setColorscheme];
    
    //Setup Connection to the Sled
    dtdev=[DTDevices sharedDevice];
    [dtdev addDelegate:self];
    [dtdev connect];
    
   
    //instince rec for scroll
    cTextState = 0;
    
    
    // Builds all the info label info in each cell
    [self buildTitleDiscriptImageArray];

    //Setup the navigation bar
    [self setupNavBar];
    

    // Set Table view cell seperators
    self.tableView.separatorColor = [UIColor whiteColor];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSLog(@"Table cell Del called");
    return _Title.count;
}

//Setup the Table Cell View based on Connection to the Sled
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    static NSString *CellIdentifer = @"TabelViewCell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableView.backgroundColor = [UIColor lightGrayColor];
    
   
    
    // Configure the cell text front & color...
    cell.TitleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:20];
    cell.DescriptionLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    cell.TitleLabel.textColor = [UIColor whiteColor];
    cell.DescriptionLabel.textColor = [UIColor whiteColor];
    
    
    //Check if the sled is connected to the iPod
    BOOL isSledConnected = [self isSledConnected];
    
    
    //Create the Cells if the sled is NOT connected
    if(isSledConnected){
        
    int row = [indexPath row];
    UIView *bgColorView = [[UIView alloc] init];
    
        
    //If not connected
   switch (indexPath.row) {
        case 0:
           //iHeld info View
           cell.backgroundColor = _iHeldColor;
            [bgColorView setBackgroundColor:_iHeldSelectColor];
            [cell setSelectedBackgroundView:bgColorView];
            cell.TitleLabel.text = _Title[row];
            cell.DescriptionLabel.text = _Description[row];
            cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

            break;
       case 1 :
           //Self Help View
           cell.backgroundColor = _selfHelpColor;
           [bgColorView setBackgroundColor:_selfHelpSelectColor];
           [cell setSelectedBackgroundView:bgColorView];
           cell.userInteractionEnabled = YES;
           cell.TitleLabel.text = _Title[row];
           cell.DescriptionLabel.text = _Description[row];
           cell.ThumImage.image = [UIImage imageNamed: _Images[row]];
           
           break;
       case 2 :
           //Scanner & MSR Test View
            cell.backgroundColor = _scannerMsrTestSelectColor; // set selected color when no scanner connected
            cell.DescriptionLabel.text = @"Sled Not Connected!";
            cell.userInteractionEnabled = NO;
            cell.TitleLabel.text = _Title[row];
            cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

            break;
        case 3 :
           //Sled Maint View
            cell.backgroundColor = _sledMaintSelectColor; // set selected color when no scanner connected
            cell.DescriptionLabel.text = @"Sled Not Connected!";
            cell.userInteractionEnabled = NO; //JP - Set for Deugging
            cell.TitleLabel.text = _Title[row];
            cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

            break;
       case 4 :
           //Test Zebra View
           cell.backgroundColor = _zebraPrinterColor;
           [bgColorView setBackgroundColor:_zebraPrinterSelectColor];
           [cell setSelectedBackgroundView:bgColorView];
           cell.userInteractionEnabled = YES;
           cell.TitleLabel.text = _Title[row];
           cell.DescriptionLabel.text = _Description[row];
           cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

           break;
       
           
    }
    
 
        
    //Create the cells if the sled IS Connected
    }else{
        
        int row = [indexPath row];
        UIView *bgColorView = [[UIView alloc] init];
        
        switch (indexPath.row) {
            case 0:
                //iHeld info view
                cell.backgroundColor = _iHeldColor;
                [bgColorView setBackgroundColor:_iHeldSelectColor];
                [cell setSelectedBackgroundView:bgColorView];
                cell.userInteractionEnabled = YES;
                cell.TitleLabel.text = _Title[row];
                cell.DescriptionLabel.text = _Description[row];
                cell.ThumImage.image = [UIImage imageNamed: _Images[row]];
                
                break;
            case 1 :
                //Scanner MSR Test View
                cell.backgroundColor = _scannerMsrTestColor;
                [bgColorView setBackgroundColor:_scannerMsrTestSelectColor];
                [cell setSelectedBackgroundView:bgColorView];
                cell.DescriptionLabel.text = _Description[row];
                cell.userInteractionEnabled = YES;
                cell.TitleLabel.text = _Title[row];
                cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

                break;

            case 2 :
                //Sled Maint view
                cell.backgroundColor = _sledMaintColor;
                [bgColorView setBackgroundColor:_sledMaintSelectColor];
                [cell setSelectedBackgroundView:bgColorView];
                cell.userInteractionEnabled = YES;
                cell.TitleLabel.text = _Title[row];
                cell.DescriptionLabel.text = _Description[row];
                cell.ThumImage.image = [UIImage imageNamed: _Images[row]];
                
                break;
            case 3 :
                //Zebra View
                cell.backgroundColor = _zebraPrinterColor;
                [bgColorView setBackgroundColor:_zebraPrinterSelectColor];
                [cell setSelectedBackgroundView:bgColorView];
                cell.userInteractionEnabled = YES;
                cell.TitleLabel.text = _Title[row];
                cell.DescriptionLabel.text = _Description[row];
                cell.ThumImage.image = [UIImage imageNamed: _Images[row]];

                break;
            
            default:
                
                break;
        }
        
        [bgColorView removeFromSuperview];
        
        
    }
    
    //cTextState is 1 when the rec is captured for the scrolling text 0 if it's not been set.
    //Without scrolling text will spawn all over the label area
    if(cTextState!= 1){
        
        [UIView animateKeyframesWithDuration:8 delay:0 options:UIViewKeyframeAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
            
            cell.DescriptionLabel.frame=CGRectMake(0-(self.view.frame.size.width), cell.DescriptionLabel.frame.origin.y, cell.DescriptionLabel.frame.size.width, cell.DescriptionLabel.frame.size.height);
            cellRecStart = cell.DescriptionLabel.frame;
            cTextState = 1;
            
        } completion:nil];
    }else{
        
        [UIView animateKeyframesWithDuration:8 delay:0 options:UIViewKeyframeAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
            
            cell.DescriptionLabel.frame = cellRecStart;
            cTextState = 1;
            
        } completion:nil];
        
    }

    
    return cell;
    
}


//Prepare what data we want to send to the next view controller based on which cell was touched/App state
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    int row = [indexPath row];
    
    
   /* NSMutableArray *allControllers = [self.navigationController.viewControllers mutableCopy];
    [allControllers removeObjectAtIndex:allControllers.count - 2];
    [self.navigationController setViewControllers:allControllers animated:NO];*/
    
  /*  NSMutableArray *allControllers = [self.navigationController.viewControllers mutableCopy];
    
    NSArray *allControllersCopy = [allControllers copy];
    
    for (id object in allControllersCopy) {
        if ([object isKindOfClass:[DetailViewController class]])
            [allControllers removeObject:object];
    } */
   
    
  // [self dismissViewControllerAnimated:YES completion:nil];
    //set the segue if the Sled is not connected
    if(dtdev.connstate!=CONN_CONNECTED){
        
        switch (indexPath.row) {
            case 0:
                //prep to move to iHeld Info
                if([[segue identifier] isEqualToString:@"ShowDetails"]){
                    
                    [self upDateAuthTime];
                    
                    DetailViewController *detailViewController = [segue destinationViewController];
                    
                    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                    
                    int row = [indexPath row];
                    
                    NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                    detailViewController.DetailModual = tempArray;
                    detailViewController.backGroundColor = _iHeldColor;
                    detailViewController.selectColor = _iHeldSelectColor;
                    //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
                }
                break;
            case 1:
                // Prep to Self Help
                if([[segue identifier] isEqualToString:@"ShowDetails"]){
                    
                    [self upDateAuthTime];
                    
                    DetailViewController *detailViewController = [segue destinationViewController];
                    
                    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                    
                    int row = [indexPath row];
                    
                    NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                    detailViewController.DetailModual = tempArray;
                    detailViewController.backGroundColor = _selfHelpColor;
                    detailViewController.selectColor = _selfHelpSelectColor;
                    //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
                }
                break;
            case 4:
                //prep to move to Zebra
                if([[segue identifier] isEqualToString:@"ShowDetails"]){
                    
                    [self upDateAuthTime];
                    
                    DetailViewController *detailViewController = [segue destinationViewController];
                    
                    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                    
                    int row = [indexPath row];
                    
                    NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                    detailViewController.DetailModual = tempArray;
                    detailViewController.backGroundColor = _zebraPrinterColor;
                    detailViewController.selectColor = _zebraPrinterSelectColor;
                    //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
                }
                break;
           

        }
   
    }else{
        //set the segue if the sled IS connected
        switch (indexPath.row) {
        case 0:
            //prep to move to iHeld Info
            if([[segue identifier] isEqualToString:@"ShowDetails"]){
                
                [self upDateAuthTime];
                
                DetailViewController *detailViewController = [segue destinationViewController];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                
                int row = [indexPath row];
                
                NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                detailViewController.DetailModual = tempArray;
                detailViewController.backGroundColor = _iHeldColor;
                detailViewController.selectColor = _iHeldSelectColor;
                //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
            }
            break;
        case 1:
            // Prep to move to Scanner MSR Test
            if([[segue identifier] isEqualToString:@"ShowDetails"]){
                
                [self upDateAuthTime];
                
                DetailViewController *detailViewController = [segue destinationViewController];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                
                int row = [indexPath row];
                
                NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                detailViewController.DetailModual = tempArray;
                detailViewController.backGroundColor = _scannerMsrTestColor;
                detailViewController.selectColor = _scannerMsrTestSelectColor;
                //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
            }
            break;
        case 2:
            // Prep to move to Sled Maint
            if([[segue identifier] isEqualToString:@"ShowDetails"]){
                
                [self upDateAuthTime];
                
                DetailViewController *detailViewController = [segue destinationViewController];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                
                int row = [indexPath row];
                
                NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                detailViewController.DetailModual = tempArray;
                detailViewController.backGroundColor = _sledMaintColor;
                detailViewController.selectColor = _sledMaintSelectColor;
                //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
            }
            break;
        case 3:
            // Prep to move to Zebra
            if([[segue identifier] isEqualToString:@"ShowDetails"]){
                
                [self upDateAuthTime];
                
                DetailViewController *detailViewController = [segue destinationViewController];
                
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                
                int row = [indexPath row];
                
                NSArray *tempArray = @[_Title[row], _Description[row], _Images[row],];
                detailViewController.DetailModual = tempArray;
                detailViewController.backGroundColor = _zebraPrinterColor;
                detailViewController.selectColor = _zebraPrinterSelectColor;
                //detailViewController.DetailModual = @[_Title[row], _Description[row], _Images[row]];
            }
            break;
        }
    }
    
}

//Deleget Method on touch of Login Button to move to LDAP storyboard for
//Login or logout
-(void) LdapLogIn:(UIBarButtonItem*) sender {
    NSLog(@"Ldap Action Called");
    
    BOOL success = [self checkLdapInfoDefaults];
    
    if(success){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"ldapInfo"]];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LdapLoginView" bundle:nil];
        LdapUserViewController *ldapUserViewController = [sb instantiateViewControllerWithIdentifier:@"loginDetail"];
        ldapUserViewController.userInfo = ldapUsrInfo;
        ldapUserViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self showViewController:ldapUserViewController sender:NULL];
   
    }else{
        
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LdapLoginView" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LdapNav"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
    }
}

//check to see if the user is Autheticated
-(BOOL)checkLdapInfoDefaults{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"ldapInfo"]];
    
    NSMutableDictionary *sledMaintWrng = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"NSDefaultsScanWarning"]];
    
    if(ldapUsrInfo == NULL){
        
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
                
                [sledMaintWrng setObject:@"YES" forKey:@"scanWarning"];
                [defaults setObject:sledMaintWrng forKey:@"NSDefaultsScanWarning"];
                [defaults synchronize];
                NSLog(@"**Set Scanner Warrning to YES**");

            return NO;
        }
    }
}
//Check conneciton state of the sled
-(BOOL)isSledConnected{
    
    if(dtdev.connstate!=CONN_CONNECTED)
    {
        return YES;
    }else{
        return NO;
    }
    
}

//Delegate Method that gets called each time the sled connects/connecting or disconnects
-(void)connectionState:(int)state {
    NSError *error;
    
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            
            break;
        case CONN_CONNECTED:
            //set defaults's
            
            settings_values[SET_BEEP]=TRUE;
            
            //read settings
            int value;
            if([dtdev barcodeGetScanButtonMode:&value error:&error])
                settings_values[SET_ENABLE_SCAN_BUTTON]=(value==BUTTON_ENABLED);
            else
                settings_values[SET_ENABLE_SCAN_BUTTON]=FALSE;
            
            
            settings_values[SET_AUTOCHARGING]=[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoCharging"];
            settings_values[SET_ENGINE_ON]=[[NSUserDefaults standardUserDefaults] boolForKey:@"BarcodeEngineOn"];
            
            if(![dtdev barcodeGetScanMode:&scanMode error:&error])
                scanMode=0;
            
           
            break;
            
            
    }
    
    [self buildTitleDiscriptImageArray];
    [self.tableView reloadData];
    
}


//Update users Timeout/Authetication time if they are logged in
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

// Build the label inforamtion for the Cells
- (void)buildTitleDiscriptImageArray{
    
    BOOL isSledConnected = [self isSledConnected];
    
    
    //Create the Cells if the sled is connected
    if(isSledConnected){
        
        NSLog(@"Sled NOT Connected Array set");
        _Title = @[@"iHeld Information", @"Self Help",  @"Scanner & MSR Test", @"Sled Maintenance", @"SNC Zebra Printers",];
        
        _Description = @[@"iPod & IPC Sled Information", @"Tap Here: Sled Not Connected", @"Scan a Barcode or Swipe a Card", @"Update Sled & Scanner Firmware", @"Test SNC & MPU Printers",];
        _Images = @[@"sled.png", @"x.png", @"scanning.png", @"settings.png", @"printer.png",];
    
    }else{
        
        NSLog(@"Sled Connected Array set");
        _Title = @[@"iHeld Information", @"Scanner & MSR Test", @"Sled Maintenance", @"SNC Zebra Printers",];
        
        _Description = @[@"iPod & IPC Sled Information", @"Scan a Barcode or Swipe a Card", @"Update Sled & Scanner Firmware", @"Test SNC & MPU Printers",];
        _Images = @[@"sled.png", @"scanning.png", @"settings.png", @"printer.png",];

    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Set the color Schema here. Color will be passed from view controller to view controller
-(void)setColorscheme{
    
    NSLog(@"SetColorScheme called");
    //iHeld infoView colors
    _iHeldColor = [UIColor colorWithRed:29.0/255 green:162.0/255 blue:97.0/255 alpha:1];
    _iHeldSelectColor = [UIColor colorWithRed:21.0/255 green:72.0/255 blue:37.0/255 alpha:1];
    
    // self Help colors
    _selfHelpColor = [UIColor colorWithRed:255.0/255 green:38.0/255 blue:0.0/255 alpha:1];
    _selfHelpSelectColor = [UIColor colorWithRed:126.0/255 green:21.0/255 blue:2.0/255 alpha:1];
   
    //Scanner & MSR colors
    _scannerMsrTestColor = [UIColor colorWithRed:67.0/255 green:109.0/255 blue:245.0/255 alpha:1];
    _scannerMsrTestSelectColor = [UIColor colorWithRed:27.0/255 green:48.0/255 blue:89.0/255 alpha:1];
    
    //Sled Maint colors
    _sledMaintColor = [UIColor colorWithRed:247.0/255 green:75.0/255 blue:46.0/255 alpha:1];
    _sledMaintSelectColor = [UIColor colorWithRed:118.0/255 green:32.0/255 blue:19.0/255 alpha:1];
    
    //Zebra Colors
    _zebraPrinterColor = [UIColor colorWithRed:153.0/255 green:169.0/255 blue:186.0/255 alpha:1];
    _zebraPrinterSelectColor = [UIColor darkGrayColor];
    
    
    
}

//Allows for the cell colors to change back after touch
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



// setup the Nav Bar & Login Button
-(void)setupNavBar{
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];

    
    
    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:NewBackButton];
    
    BOOL success = [self checkLdapInfoDefaults];
    
    if(success){
        
        UIBarButtonItem *LogIn = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(LdapLogIn:)];
        [[self navigationItem] setRightBarButtonItem:LogIn];
        
        [LogIn setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Top Modern as created using Fon" size:16.0],
                                        NSForegroundColorAttributeName: [UIColor whiteColor]
                                        } forState:UIControlStateNormal];
        
    }else{
        UIBarButtonItem *LogIn = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStyleBordered target:self action:@selector(LdapLogIn:)];
        [[self navigationItem] setRightBarButtonItem:LogIn];
        
        [LogIn setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Top Modern as created using Fon" size:16.0],
                                        NSForegroundColorAttributeName: [UIColor whiteColor]
                                        } forState:UIControlStateNormal];
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [dtdev addDelegate:self];
    [dtdev connect];
    
}


@end
