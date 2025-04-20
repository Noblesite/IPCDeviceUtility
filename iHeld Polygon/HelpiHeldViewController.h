//
//  HelpiHeldViewController.h
//  iHeld Polygon
//
//  Created by Jonathon Poe on 1/24/17.
//  Copyright © 2017 Noblesite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpiHeldTableView.h"

@interface HelpiHeldViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    int AppState;
}

@property (nonatomic, strong) NSArray *HelpiHeldImages;
@property (nonatomic, strong) NSArray *HelpiHeldTitle;
@property (nonatomic, strong) NSArray *HelpiHeldDescription;
@property (strong, nonatomic) IBOutlet HelpiHeldTableView *tableView;
@property (strong, nonatomic)  HelpiHeldTableView *HelpiHeldTableView;
@property (strong, nonatomic) UIColor *backGroundColor;
@property (strong, nonatomic) UIColor *selectColor;


@end
