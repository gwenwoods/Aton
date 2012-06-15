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



@class OnlineViewController;

@protocol OnlineViewDelegate
-(void)dismissOnlineViewWithAnimation:(OnlineViewController*) subController;
-(void)dismissOnlineViewWithoutAnimation:(OnlineViewController*) subController;
@end

@interface OnlineViewController : UIViewController<GameCenterHelperDelegate, BoardViewDelegate> {
    //GKMatch *match;
  //  GKPlayer *localPlayer, *remotePlayer;
    NSString *localPlayerName, *remotePlayerName;
    int localRandomNum, remoteRandomNum;
    int localPlayerEnum;
    
    __unsafe_unretained id delegateOnlineView;
    
    int gameCenterStateEnum;
   // BOOL matchStarted;
   // NSMutableDictionary *playersDict;
   // UITextField *textField;
    UILabel *label;
    UIButton *playGameButton;
    OnlineParameters *onlinePara;
    
   // GameData *randomNumData, *removePeepData, *placePeepData, *remove4Data;
    
    
    
    
}
-(void) checkGameStart;
//@property (strong, nonatomic) GKMatch *match;
@property (nonatomic, strong) BoardViewController *boardScreen;
@property (nonatomic, assign) id<OnlineViewDelegate> delegateOnlineView; 
@property (nonatomic, strong) UIButton *playGameButton;
@property (nonatomic, strong) UILabel *label;
//@property (nonatomic, strong) GKPlayer *localPlayer, *remotePlayer;
@property (nonatomic) int localRandomNum, remoteRandomNum;

@end
