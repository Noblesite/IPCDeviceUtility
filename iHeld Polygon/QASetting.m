//
//  QASetting.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 9/5/17.
//  Copyright © 2016 Noblesite Projects. All rights reserved.
//

#import "QASetting.h"

@implementation QASetting



-(bool)checkOvrideForQA{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *password=[defaults objectForKey:@"autheticate_value"];
    Boolean qaEnabled=[defaults boolForKey:@"enabled_QA"];
    
    if(qaEnabled){
        
        if([password isEqual:@"YourPassword"])
            return YES;
    }
    
    
    
    return NO;
}



@end
