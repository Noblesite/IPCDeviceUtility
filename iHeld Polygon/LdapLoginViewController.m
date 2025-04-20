//  LdapLoginViewController.m
//  DeviceUtility
//
//  Created by Jonathon Poe. Scrubbed for public release.

#import "LdapLoginViewController.h"

@implementation LdapLoginViewController

@synthesize useridField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize loginIndicator;
@synthesize msgField;
@synthesize currentElementValue;
@synthesize faultCodeField;
@synthesize userId;
@synthesize pw;
@synthesize ldapUsrInfo;
@synthesize mngJobCodes;

- (void)viewDidLoad {
    mngJobCodes = @[@"ROLE_ADMIN", @"ROLE_SUPERVISOR", @"ROLE_MANAGER"];
    
    ldapUsrInfo = [NSMutableDictionary dictionaryWithDictionary:@{
        @"firstName": @"",
        @"lastName": @"",
        @"jobCodeList": @"",
        @"userId": @"",
        @"unitNumber": @"",
        @"Autheticated": @"",
        @"AuthTime": @""
    }];
    
    self.navigationController.title = @"Device Utility";
    _loginImage.image = [UIImage imageNamed:@"ldapBackGround.png"];
    _loginImage.contentMode = UIViewContentModeScaleAspectFit;

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];

    msgField.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    loginIndicator.hidden = YES;
    loginButton.titleLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    useridField.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    passwordField.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:12];
    
    UIColor *color = [UIColor lightGrayColor];
    useridField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    useridField.textColor = [UIColor blackColor];
    passwordField.textColor = [UIColor blackColor];

    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
    NewBackButton.tintColor = [UIColor whiteColor];

    [[self navigationItem] setLeftBarButtonItem:NewBackButton];

    [NewBackButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Top Modern as created using Fon" size:16.0], NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];

    [useridField setDelegate:self];
    [passwordField setDelegate:self];
    [super viewDidLoad];

    msgText = [[NSMutableString alloc] init];
}

- (NSMutableData *)postSoapEnvelope:(NSString *)userID pw:(NSString *)PW {
    NSMutableData *myMutableData;
    NSMutableString *sRequest = [[NSMutableString alloc] init];

    [sRequest appendString:@"<?xml version='1.0' encoding='UTF-8'?>"];
    [sRequest appendString:@"<soapenv:Envelope xmlns:wsa=\"http://www.w3.org/2005/08/addressing\" xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [sRequest appendString:@"<soapenv:Body>"];
    [sRequest appendString:@"<ns1:loggedOn xmlns:ns1=\"http://example.com/auth/xsd\">"];
    [sRequest appendString:@"<ns1:user xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\" />"];
    [sRequest appendString:@"<ns1:userId>"];
    [sRequest appendString:userID];
    [sRequest appendString:@"</ns1:userId>"];
    [sRequest appendString:@"<ns1:password>"];
    [sRequest appendString:PW];
    [sRequest appendString:@"</ns1:password>"];
    [sRequest appendString:@"<ns1:programName>APP</ns1:programName>"];
    [sRequest appendString:@"<ns1:terminal xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\" />"];
    [sRequest appendString:@"</ns1:loggedOn>"];
    [sRequest appendString:@"</soapenv:Body>"];
    [sRequest appendString:@"</soapenv:Envelope>"];

    NSString *ldap_url;
    NSDictionary *prefs;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/AppConfig.plist"];
    prefs = [NSDictionary dictionaryWithContentsOfFile:[path stringByExpandingTildeInPath]];

    ldap_url = [prefs objectForKey:@"production_ldap_url"];
    if ([[QASetting alloc] checkOvrideForQA]) {
        ldap_url = [prefs objectForKey:@"qa_ldap_url"];
    }

    NSURL *securityServiceURL = [NSURL URLWithString:ldap_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:securityServiceURL];

    [request addValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"\"urn:loggedOn\"" forHTTPHeaderField:@"SOAPAction"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[sRequest dataUsingEncoding:NSUTF8StringEncoding]];

    NSError *WSerror;
    NSURLResponse *WSresponse;
    NSData *tempData = [NSURLConnection sendSynchronousRequest:request returningResponse:&WSresponse error:&WSerror];
    myMutableData = [tempData mutableCopy];

    return myMutableData;
}


@end

