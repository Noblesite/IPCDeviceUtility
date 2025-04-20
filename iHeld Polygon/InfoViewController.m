//
//  InfoViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 3/14/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.font=[UIFont fontWithName:@"Top Modern as created using Fon" size:30];
    _infoLabel.textColor=[UIColor whiteColor];
    _infoLabel.font=[UIFont fontWithName:@"Top Modern as created using Fon" size:16];
    //_infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    _infoLabel.numberOfLines=0;
    _warning1.textColor=[UIColor whiteColor];
    _warning1.font=[UIFont fontWithName:@"Top Modern as created using Fon" size:37];
    _warning2.textColor=[UIColor whiteColor];
    _warning2.font=[UIFont fontWithName:@"Top Modern as created using Fon" size:37];
   
    
    _warning1.text=@"WARNING!!";
    _warning2.text=@"WARNING!!";
    
    
    
    _titleLabel.text=@"PLEASE READ";
    _infoLabel.text=[NSString stringWithFormat:@"\n SCANNER ENGINE FUNCTIONS SHOULD ONLY BE USED IF THE SCANNER IS NO LONGER WORKING!\n\nIF PERFORMED ON A WORKING SCANNER IT COULD RENDER THE SCANNER INOPERABLE!"];
    

    
    // Do any additional setup after loading the view.
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

@end
