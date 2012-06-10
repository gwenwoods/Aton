//
//  OnlineViewController.h
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

@interface OnlineViewController : UIViewController<GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    GKMatch *match;
    BOOL matchStarted;
    NSMutableDictionary *playersDict;
    UITextField *textField;
    UILabel *label;
    UIButton *sendMessageButton;
}

@property (strong, nonatomic) GKMatch *match;
@end
