//
//  LdapLoginViewController.h

//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import <UIKit/UIView.h>
#import "LdapUserViewController.h"

// Declaring the interface
@interface LdapLoginViewController : UIViewController<UITextFieldDelegate> {
	
	//Type qualifier used by Interface Builder to synchronize actions. 
	IBOutlet UITextField *useridField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *loginButton;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	IBOutlet UILabel *msgField;	
        
   
	
	NSMutableString *msgText;	
	NSMutableString *currentElementValue;
	NSString *faultCodeField;
	NSMutableString *userId;
	NSMutableString *pw;
}

// specifies properties for the above declared objects
// retain - prevents deallocation until manually released by the programmer
// nonatomic - allows unsynchronized access to the objects (objects are not locked when accessed)
@property (nonatomic, retain) UITextField *useridField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;
@property (nonatomic, retain) UILabel *msgField;
@property (nonatomic, retain) NSMutableString *currentElementValue;
@property (nonatomic, retain) NSString *faultCodeField;
@property (nonatomic, retain) NSMutableString *userId;
@property (nonatomic, retain) NSMutableString *pw;
@property (strong, nonatomic) IBOutlet UIImageView *loginImage;
@property (nonatomic, strong) NSMutableDictionary *ldapUsrInfo;
@property (nonatomic, strong) NSArray *mngJobCodes;

-(void)backButton:(UIBarButtonItem*) sender;


// defined action on the ldapwebview
-(IBAction) login: (id)sender;




@end
