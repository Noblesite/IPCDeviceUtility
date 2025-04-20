//
//  InfoViewController.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 3/14/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController{
    int AppState;
}

@property int *appState;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *warning1;
@property (strong, nonatomic) IBOutlet UILabel *warning2;

@end
