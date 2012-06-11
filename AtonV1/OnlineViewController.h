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

enum GAME_CENTER_STATE_ENUM {
  GAME_CENTER_WAITING_LOCAL_AUTHENTICATION,
  GAME_CENTER_WAITING_FIND_MATCH,
  GAME_CENTER_WAITING_RANDOM_NUMBER,
  GAME_CENTER_WAITING_GAME_START
};

@class OnlineViewController;

@protocol OnlineViewDelegate
-(void)dismissOnlineViewWithAnimation:(OnlineViewController*) subController;
-(void)dismissOnlineViewWithoutAnimation:(OnlineViewController*) subController;
@end

@interface OnlineViewController : UIViewController<GKMatchmakerViewControllerDelegate, GKMatchDelegate, BoardViewDelegate> {
    GKMatch *match;
    GKPlayer *localPlayer, *remotePlayer;
    int localRandomNum, remoteRandomNum;
    int localPlayerEnum;
    
    __unsafe_unretained id delegateOnlineView;
    
    int gameCenterStateEnum;
   // BOOL matchStarted;
   // NSMutableDictionary *playersDict;
   // UITextField *textField;
    UILabel *label;
    UIButton *sendMessageButton, *playGameButton;
    OnlineParameters *onlinePara;
    
    
    
}

@property (strong, nonatomic) GKMatch *match;
@property (nonatomic, strong) BoardViewController *boardScreen;
@property (nonatomic, assign) id<OnlineViewDelegate> delegateOnlineView; 

@end
