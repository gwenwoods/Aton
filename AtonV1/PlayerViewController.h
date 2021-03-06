//
//  PlayerViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "OnlineViewController.h"
#import "GameCenterHelper.h"

@class PlayerViewController;

@protocol PlayerViewDelegate
-(void)dismissPlayerViewWithAnimation:(PlayerViewController*) subController;
-(void)dismissPlayerViewWithoutAnimation:(PlayerViewController*) subController;
@end

@interface PlayerViewController : UIViewController<OnlineViewDelegate, BoardViewDelegate, UITextFieldDelegate> {
    
    __unsafe_unretained id delegatePlayerView;
    
    UIImageView *enterNameView;
    UILabel *enterNameLb;
    UITextField *enterNameTextField;
    UIButton *redNameButton, *blueNameButton;
    BOOL updateRed, updateBlue;
    NSString *redName, *blueName;
    UIImageView *maskIV, *enterNameIconIV, *redAnimationIV, *blueAnimationIV;
    
    AVAudioPlayer *audioPlayerChime, *audioEnterName, *audioSwitch;
    float angle;
    UIImageView *rotateIV;
    
    BOOL useAI;
    UIButton *useAIButton, *playOnlineButton;
}

-(IBAction) backToMenu:(id)sender;

@property (nonatomic, assign) id<PlayerViewDelegate> delegatePlayerView;
@property (nonatomic, strong) OnlineViewController *onlineViewScreen;
@property (nonatomic, strong) BoardViewController *boardScreen;
@property (nonatomic, strong) AVAudioPlayer *audioEnterName;
@end
