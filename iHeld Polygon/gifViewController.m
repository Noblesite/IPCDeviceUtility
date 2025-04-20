//
//  gifViewController.m
//  iHeld Polygon
//
//  Created by Jonathon Poe on 2/7/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import "gifViewController.h"

@interface gifViewController ()

@end

@implementation gifViewController

#define SLED_REST 0
#define SLED_POWER 1



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Top Modern as created using Fon" size:21]}];
    
    UIBarButtonItem *NewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:NewBackButton];
    
    _infoLabel.font = [UIFont fontWithName:@"Top Modern as created using Fon" size:14];
    _infoLabel.textColor = [UIColor whiteColor];
    
    if ([_passedAppState  isEqual: @"Power"]){
        
        AppState = SLED_POWER;
        _infoLabel.text = @"Press The Button As Shown to Check the Charge Level";
         self.navigationController.title = @"Sled Power";
        
    }
    
    if ([_passedAppState isEqualToString:@"Reset"]){
        
        AppState = SLED_REST;
        _infoLabel.text = @"Press the Power Button & Scan Button At The Same Time Till the Sled Beeps Then let Go";
         self.navigationController.title = @"Sled Reset";
    }
   
    _infoLabel.backgroundColor = _selectGroundColor;
    self.view.backgroundColor = _backGroundColor;
    
    [self setVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setVideo{
    
    if (AppState == SLED_REST){
    
         NSLog(@"Sled Rest called using PNG files");
        
        NSArray *animationFrames = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"sledreset-1.jpg"],
                                    [UIImage imageNamed:@"sledreset-2.jpg"],
                                    [UIImage imageNamed:@"sledreset-3.jpg"],
                                    [UIImage imageNamed:@"sledreset-4.jpg"],
                                    [UIImage imageNamed:@"sledreset-5.jpg"],
                                    [UIImage imageNamed:@"sledreset-6.jpg"],
                                    [UIImage imageNamed:@"sledreset-7.jpg"],
                                    [UIImage imageNamed:@"sledreset-8.jpg"],
                                    [UIImage imageNamed:@"sledreset-9.jpg"],
                                    [UIImage imageNamed:@"sledreset-10.jpg"],
                                    [UIImage imageNamed:@"sledreset-11.jpg"],
                                    [UIImage imageNamed:@"sledreset-12.jpg"],
                                    [UIImage imageNamed:@"sledreset-13.jpg"],
                                    [UIImage imageNamed:@"sledreset-14.jpg"],
                                    [UIImage imageNamed:@"sledreset-15.jpg"],
                                    [UIImage imageNamed:@"sledreset-16.jpg"],
                                    [UIImage imageNamed:@"sledreset-17.jpg"],
                                    [UIImage imageNamed:@"sledreset-18.jpg"],
                                    [UIImage imageNamed:@"sledreset-19.jpg"],
                                    [UIImage imageNamed:@"sledreset-20.jpg"],
                                    [UIImage imageNamed:@"sledreset-21.jpg"],
                                    [UIImage imageNamed:@"sledreset-22.jpg"],
                                    [UIImage imageNamed:@"sledreset-23.jpg"],
                                    [UIImage imageNamed:@"sledreset-24.jpg"],
                                    [UIImage imageNamed:@"sledreset-25.jpg"],
                                    [UIImage imageNamed:@"sledreset-26.jpg"],
                                    [UIImage imageNamed:@"sledreset-27.jpg"],
                                    [UIImage imageNamed:@"sledreset-28.jpg"],
                                    [UIImage imageNamed:@"sledreset-29.jpg"],
                                    [UIImage imageNamed:@"sledreset-30.jpg"],
                                    [UIImage imageNamed:@"sledreset-31.jpg"],
                                    [UIImage imageNamed:@"sledreset-32.jpg"],
                                    [UIImage imageNamed:@"sledreset-33.jpg"],
                                    [UIImage imageNamed:@"sledreset-34.jpg"],
                                    [UIImage imageNamed:@"sledreset-35.jpg"],
                                    [UIImage imageNamed:@"sledreset-36.jpg"],
                                    [UIImage imageNamed:@"sledreset-37.jpg"],
                                    [UIImage imageNamed:@"sledreset-38.jpg"],
                                    [UIImage imageNamed:@"sledreset-39.jpg"],
                                    [UIImage imageNamed:@"sledreset-40.jpg"],
                                    [UIImage imageNamed:@"sledreset-41.jpg"],
                                    [UIImage imageNamed:@"sledreset-42.jpg"],
                                    [UIImage imageNamed:@"sledreset-43.jpg"],
                                    [UIImage imageNamed:@"sledreset-44.jpg"],
                                    [UIImage imageNamed:@"sledreset-45.jpg"],
                                    [UIImage imageNamed:@"sledreset-46.jpg"],
                                    [UIImage imageNamed:@"sledreset-47.jpg"],
                                    [UIImage imageNamed:@"sledreset-48.jpg"],
                                    [UIImage imageNamed:@"sledreset-49.jpg"],
                                    [UIImage imageNamed:@"sledreset-50.jpg"],
                                    nil];
        
        // _gifImage.image = [UIImage animatedImageWithImages:animationFrames duration:10];
        
        //[_gifImage startAnimating];
        _gifImage.animationImages = animationFrames;
        
        
        _gifImage.animationDuration = 3.0f;
        _gifImage.animationRepeatCount = INFINITY;
        [_gifImage startAnimating];
        //[self.view addSubview: _gifImage];
 
    }
    
    if (AppState == SLED_POWER){
        
        NSLog(@"SetVid: Called for Sled Power using JPG files");
        
      
        NSArray *animationFrames = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"BL1.jpg"],
                                    [UIImage imageNamed:@"BL2.jpg"],
                                    [UIImage imageNamed:@"BL3.jpg"],
                                    [UIImage imageNamed:@"BL4.jpg"],
                                    [UIImage imageNamed:@"BL5.jpg"],
                                    [UIImage imageNamed:@"BL6.jpg"],
                                    [UIImage imageNamed:@"BL7.jpg"],
                                    [UIImage imageNamed:@"BL8.jpg"],
                                    [UIImage imageNamed:@"BL9.jpg"],
                                    [UIImage imageNamed:@"BL10.jpg"],
                                    [UIImage imageNamed:@"BL11.jpg"],
                                    [UIImage imageNamed:@"BL12.jpg"],
                                    [UIImage imageNamed:@"BL13.jpg"],
                                    [UIImage imageNamed:@"BL14.jpg"],
                                    [UIImage imageNamed:@"BL15.jpg"],
                                    [UIImage imageNamed:@"BL16.jpg"],
                                    [UIImage imageNamed:@"BL17.jpg"],
                                    [UIImage imageNamed:@"BL18.jpg"],
                                    [UIImage imageNamed:@"BL19.jpg"],
                                    [UIImage imageNamed:@"BL20.jpg"],
                                    [UIImage imageNamed:@"BL21.jpg"],
                                    [UIImage imageNamed:@"BL22.jpg"],
                                    [UIImage imageNamed:@"BL23.jpg"],
                                    [UIImage imageNamed:@"BL24.jpg"],
                                    [UIImage imageNamed:@"BL25.jpg"],
                                    [UIImage imageNamed:@"BL26.jpg"],
                                    [UIImage imageNamed:@"BL27.jpg"],
                                    [UIImage imageNamed:@"BL28.jpg"],
                                    [UIImage imageNamed:@"BL29.jpg"],
                                    [UIImage imageNamed:@"BL30.jpg"],
                                    [UIImage imageNamed:@"BL31.jpg"],
                                    [UIImage imageNamed:@"BL32.jpg"],
                                    [UIImage imageNamed:@"BL33.jpg"],
                                    [UIImage imageNamed:@"BL34.jpg"],
                                    [UIImage imageNamed:@"BL35.jpg"],
                                    [UIImage imageNamed:@"BL36.jpg"],
                                    [UIImage imageNamed:@"BL37.jpg"],
                                    [UIImage imageNamed:@"BL38.jpg"],
                                    [UIImage imageNamed:@"BL39.jpg"],
                                    [UIImage imageNamed:@"BL40.jpg"],
                                    [UIImage imageNamed:@"BL41.jpg"],
                                    [UIImage imageNamed:@"BL42.jpg"],
                                    [UIImage imageNamed:@"BL43.jpg"],
                                    
                                    nil];
        
        // _gifImage.image = [UIImage animatedImageWithImages:animationFrames duration:10];
        
        //[_gifImage startAnimating];
        _gifImage.animationImages = animationFrames;
        
        
        _gifImage.animationDuration = 3.0f;
        _gifImage.animationRepeatCount = INFINITY;
        [_gifImage startAnimating];
        //[self.view addSubview: _gifImage];

        
        
        
        
    }
    
    
    
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
