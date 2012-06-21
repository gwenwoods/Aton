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

    __unsafe_unretained id delegateOnlineView;
    NSString *localPlayerName, *remotePlayerName;
    int localRandomNum, remoteRandomNum;
    int localPlayerEnum;
    
    int gameCenterStateEnum;

    UILabel *label;
    UIButton *playGameButton, *backToMainButton;
    OnlineParameters *onlinePara;
    
}
-(void) checkGameStart;

@property (nonatomic, assign) id<OnlineViewDelegate> delegateOnlineView;
@property (nonatomic, strong) BoardViewController *boardScreen;
 
@property (nonatomic, strong) UIButton *playGameButton;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic) int localRandomNum, remoteRandomNum;

@end
