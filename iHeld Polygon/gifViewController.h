//
//  gifViewController.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 2/7/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gifViewController : UIViewController{
    int AppState;
}

@property (strong, nonatomic) NSString *gifName;
@property (strong, nonatomic) IBOutlet UIImageView *gifImage;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) UIColor *backGroundColor;
@property (strong, nonatomic) UIColor *selectGroundColor;
@property (strong, nonatomic) NSString *passedAppState;
@end
