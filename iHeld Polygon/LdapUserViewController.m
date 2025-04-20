//
//  LdapUserViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "LdapUserViewController.h"

@interface LdapUserViewController ()

@end

@implementation LdapUserViewController

@synthesize userInfo;
@synthesize mngJobCodes;

- (void)viewDidLoad {
    
   
    [super viewDidLoad];
   
    
    self.navigationController.title = @"Device Utility";

     NSLog(@"LdapUserViewController has been called");
     NSLog(@"Passed User Info in Dict: %@", userInfo);
        
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];
    

    CALayer * l1 = [_userNameLabel layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:16.0];
    
    CALayer * l2 = [_successLabel layer];
    [l2 setMasksToBounds:YES];
    [l2 setCornerRadius:16.0];
    
        
   

    _successLabel.backgroundColor = [UIColor colorWithRed:21.0/255 green:72.0/255 blue:37.0/255 alpha:1];
    _userNameLabel.backgroundColor = [UIColor colorWithRed:21.0/255 green:72.0/255 blue:37.0/255 alpha:1];
    _logOutInfoLabel.backgroundColor = [UIColor colorWithRed:27.0/255 green:48.0/255 blue:89.0/255 alpha:1];
    _userNameLabel.font =  [UIFont fontWithName:@"Top Modern as created using Fon" size:16];
    _successLabel.font =  [UIFont fontWithName:@"Top Modern as created using Fon" size:18];
    _logOutInfoLabel.font =  [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    _logOutInfoLabel.textColor = [UIColor whiteColor];
    _userNameLabel.textColor = [UIColor whiteColor];
    _successLabel.textColor = [UIColor whiteColor];
    _userImage.image = [UIImage imageNamed:@"ldapCheck.png" ];
    _userImage.contentMode = UIViewContentModeScaleAspectFit;
    _successLabel.text = @"Welcome!";
   NSString *firstName = [userInfo objectForKey:@"firstName"];
   NSString *lastName = [userInfo objectForKey:@"lastName"];
   _userNameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    _logOutInfoLabel.text = @"Admin Rights Granted. Remote & Scanner Update Available. Auto Logout After 15 Minutes of Inactivity!";
    _logOutButton.titleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:13];
    
    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton:)];
    NewBackButton.tintColor = [UIColor whiteColor];
    
    [[self navigationItem] setLeftBarButtonItem:NewBackButton];
    
    [NewBackButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Top Modern as created using Fon" size:16.0],
                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                    } forState:UIControlStateNormal];

   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)setUpTheView{
    
    
    _userNameLabel.font =  [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
     _successLabel.font =  [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    _userNameLabel.textColor = [UIColor whiteColor];
    _successLabel.textColor = [UIColor whiteColor];
    _userNameLabel.tintColor = [UIColor whiteColor];
    _successLabel.tintColor = [UIColor whiteColor];
     _userImage.image = [UIImage imageNamed:@"ldapBackGround.png" ];
    _successLabel.text = @"Success! Thank You for Loging In!";
   NSString *firstName = [userInfo objectForKey:@"firstName"];
   NSString *lastName = [userInfo objectForKey:@"lastName"];
   _userNameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton:)];
    NewBackButton.tintColor = [UIColor whiteColor];
    
    [[self navigationItem] setLeftBarButtonItem:NewBackButton];

    self.navigationController.title = @"Device Utility";

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];

    NSLog(@"Passed User Info in Dict: %@", userInfo);
    
    
    
    
}


-(void)backButton:(UIBarButtonItem*) sender{
    NSLog(@"Reload TableView");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NavStory"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)logOutButton:(id)sender {
    
    NSUserDefaults *tempDefault = [NSUserDefaults standardUserDefaults];
    [tempDefault removeObjectForKey:@"ldapInfo"];
    
    NSLog(@"Reload TableView");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NavStory"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}



// You should also declare an iVar to store your text


// and implement it in your .m file like this
-(id)initWithUser:(NSMutableDictionary *)sentUserInfo
{
    NSLog(@"InitWithUser info called");
    self = [super init];
    if (self)
    {
        userInfo = sentUserInfo;
    }
    return self;
}

//check to see if the user is Autheticated
-(BOOL)checkLdapInfoDefaults{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ldapUsrInfo = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"ldapInfo"]];
    
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
        
        if( timeDiffrence < authTimeOut && [autheticated  isEqual: @"YES"]){
            NSLog(@"Authetication approved:CheckLDAP");
            return YES;
        }else{
            NSLog(@"Autthenticaiton not approved:CheckLDAP");
            return NO;
        }
    }
}

//check info in Ldap Dict
-(BOOL)checkLdapInfoDictionary{
    
    
    
       if(userInfo == NULL){
        NSLog(@"No info in ldapUserInfo for checkLDAPInfo");
        return NO;
    }else{
        // check time and authication value
        NSLog(@"LDAP info found in NSUserDefaults");
        
        NSString *autheticated = [userInfo objectForKey:@"Autheticated"];
        NSString *authTime = [userInfo objectForKey:@"AuthTime"];
        
        
        
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
        
        if( timeDiffrence < authTimeOut && [autheticated  isEqual: @"YES"]){
            NSLog(@"Authetication approved:CheckLDAP");
            return YES;
        }else{
            NSLog(@"Autthenticaiton not approved:CheckLDAP");
            return NO;
        }
    }
}


//Eval the job code and unit number for app Auth & Save NSUserDefaults info
-(BOOL)checkJobCode:(NSMutableDictionary*)userDictionary{
    
    NSString *userJobCodes = [userDictionary objectForKey:@"jobCodeList"];
    NSString *uniteNumber = [userDictionary objectForKey:@"uniteNumber"];
    
    
    BOOL approvedJob = [mngJobCodes containsObject: userJobCodes];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *authTime = [timeFormat stringFromDate:currentTime];
    NSLog(@"Authetication Time: %@", authTime);
    
    if (approvedJob){
        
        return YES;
        
    }else{ if([uniteNumber  isEqual: @"00491"])
        
        return YES;
    }
    
    return NO;
}


@end
