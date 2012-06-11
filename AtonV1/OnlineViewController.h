//
//  OnlineViewController.h
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "GameCenterHelper.h"
#import "OnlineParameters.h"
#import "GameData.h"

@interface OnlineViewController : UIViewController<GKMatchmakerViewControllerDelegate, GKMatchDelegate, BoardViewDelegate> {
    GKMatch *match;
    BOOL matchStarted;
    NSMutableDictionary *playersDict;
    UITextField *textField;
    UILabel *label;
    UIButton *sendMessageButton, *playGameButton;
    BOOL localOK, remoteOK;
    OnlineParameters *onlinePara;
    int remoteRandomNum, localRandomNum;
    
    GKPlayer *localPlayer, *remotePlayer;
}

@property (strong, nonatomic) GKMatch *match;
@property (nonatomic, strong) BoardViewController *boardScreen;

@end
