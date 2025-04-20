//
//  LdapUserViewController.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 4/19/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "QASetting.h"

@interface LdapUserViewController : UIViewController<UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *successLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *logOutInfoLabel;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSArray *mngJobCodes;

-(void)backButton:(UIBarButtonItem*) sender;
- (IBAction)logOutButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
-(id)initWithUser:(NSMutableDictionary *)userInfo;


@end
