//
//  HelpiHeldViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 1/24/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "HelpiHeldViewController.h"
#import "HelpiHeldCell.h"
#import "gifViewController.h"

@interface HelpiHeldViewController ()

@end

@implementation HelpiHeldViewController

#define IHELD_INFO 0
#define SELF_HELP 1
#define SLED_REST 2
#define SLED_POWER 3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the App State for the View
    
    if([_HelpiHeldTitle[0]  isEqual: @"Check Date & Time"]){
        AppState = SELF_HELP;
    }else{
        AppState = IHELD_INFO;
    }
    
    
    self.navigationController.title = @"Device Utility";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];

    
    self.HelpiHeldTableView.delegate = self;
    self.HelpiHeldTableView.dataSource = self;
    self.view.backgroundColor = _backGroundColor;
    
   
    NSLog(@"HelpiHeld View Called");
    
    NSLog(@"Title Array Output: %@", _HelpiHeldTitle);
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    NSLog(@"Cell Row Count called");
    return _HelpiHeldTitle.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpiHeldCell" forIndexPath:indexPath];
    
    NSLog(@"Cell for Row at . . Called");
     HelpiHeldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpiHeldCell" forIndexPath:indexPath];
    
    tableView.backgroundColor = _backGroundColor;
    // Configure the cell...
    
    UIView *bgColorView = [[UIView alloc] init];
    int row = [indexPath row];
    
    if(AppState == SELF_HELP){
    
    cell.titleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
    cell.discripLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.discripLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.discripLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = _backGroundColor;
    cell.titleLabel.text = _HelpiHeldTitle[row];
    cell.discripLabel.text = _HelpiHeldDescription[row];
    cell.image.image = [UIImage imageNamed: _HelpiHeldImages[row]];
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [bgColorView setBackgroundColor:_selectColor];
    [cell setSelectedBackgroundView:bgColorView];
    
   
    }else{
        
        
        cell.titleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
        cell.discripLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
        cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        cell.discripLabel.adjustsFontSizeToFitWidth = YES;
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.discripLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = _backGroundColor;
        cell.titleLabel.text = _HelpiHeldTitle[row];
        cell.discripLabel.text = _HelpiHeldDescription[row];
        cell.image.image = [UIImage imageNamed: _HelpiHeldImages[row]];
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [bgColorView removeFromSuperview];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"Did Select Row Called in HelpiHeld");
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (AppState == SELF_HELP){
        
        switch (indexPath.row) {
            case 0:
                NSLog(@"Open time & Date Called");
                
                [self openDateTimeSettings];
                
                break;
            case 1:
                NSLog(@"Open WiFi Settings Called");
                
                [self openWifiSettings];
                break;
        }
        
        
        
    }
}

-(void)openDateTimeSettings{
    
    
    if([[[UIDevice currentDevice] systemVersion] integerValue] < 10 ){
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=DATE_AND_TIME"]];
   
    }
    
       if([[[UIDevice currentDevice] systemVersion] integerValue] >= 10 ){
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-prefs:root=General=DATE_AND_TIME"]];
    
       }
}

-(void)openWifiSettings{
   
     if([[[UIDevice currentDevice] systemVersion] integerValue] < 10 ){
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
     }
    
    if([[[UIDevice currentDevice] systemVersion] integerValue] >= 10 ){
        
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-prefs:root=WIFI"]];
    
    }
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"PrepairForSegue called! for GifViewConroller");
    
     if([[segue identifier] isEqualToString:@"moveToGif"]){
    
    gifViewController *gifView= [segue destinationViewController];
    
    gifView.backGroundColor = _backGroundColor;
    gifView.selectGroundColor = _selectColor;
    
    
    if(AppState == SLED_REST){
        
        
            NSLog(@"SLED_REST Segue Called");
            gifView.passedAppState = @"Reset";
        
            AppState = SELF_HELP;
        }
          
    if(AppState == SLED_POWER){
            
             NSLog(@"SLED_POWER Segue Called");
            
            gifView.passedAppState = @"Power";
        
            AppState = SELF_HELP;
        
    
        }
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    
    
    if(AppState == SELF_HELP)
    {
        if(indexPath.row == 2){
            
            AppState = SLED_REST;
            
             NSLog(@"YES Returned for Should Segue in HelpiHeld View Index 2");
            
            return YES;
        }
        
        if(indexPath.row == 3){
            
            AppState = SLED_POWER;
            
            NSLog(@"YES Returned for Should Segue in HelpiHeld View Index 3");
            
            return YES;
        }

    }
    
    NSLog(@"No Returned for Should Segue in HelpiHeld View");
    return NO;
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
  }
 */



@end
