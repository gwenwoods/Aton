//
//  StartMenuViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "PlayerViewController.h"
//#import "RuleViewController.h"
#import "RuleView1Controller.h"
#import "CreditViewController.h"

#import "BoardViewController.h"
#import "OnlineViewController.h"
#import "AnimationUtility.h"
#import "AudioUtility.h"

@interface StartMenuViewController : UIViewController<PlayerViewDelegate, RuleView1Delegate, CreditViewDelegate>
{
    IBOutlet UIImageView *playIV, *rulesIV, *creditsIV;
    IBOutlet UIImageView *playAnkhIV, *rulesAnkhIV, *creditsAnkhIV;

    AVAudioPlayer *audioPlayerEnterPlay, *audioPlayerOpen;
}

//-(IBAction) toPlayerView:(id)sender;
//- (void)clickedButton:(BoardViewController *)subcontroller;
- (void)dismissPlayerViewWithAnimation:(PlayerViewController *)subcontroller;
- (void)dismissRuleViewWithAnimation:(RuleView1Controller *)subcontroller;
- (void)dismissCreditViewWithAnimation:(CreditViewController *)subcontroller;
- (void)fadeVolumeDown:(AVAudioPlayer *)aPlayer;

@property(nonatomic, strong) PlayerViewController *playerViewScreen;
@property(nonatomic, strong) CreditViewController *creditViewScreen;
@property(nonatomic, strong) RuleView1Controller *ruleViewScreen;

@property(nonatomic, strong) AVAudioPlayer *audioPlayerOpen;

@end
