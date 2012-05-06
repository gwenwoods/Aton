//
//  StartMenuViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayerViewController.h"
#import "RuleViewController.h"
#import "CreditViewController.h"

#import "BoardViewController.h"

@interface StartMenuViewController : UIViewController<PlayerViewDelegate, RuleViewDelegate, CreditViewDelegate>
{
    IBOutlet UIImageView *playIV, *rulesIV, *creditsIV;
    IBOutlet UIImageView *playAnkhIV, *rulesAnkhIV, *creditsAnkhIV;

    AVAudioPlayer *audioPlayerEnterPlay, *audioPlayerOpen;
}

-(IBAction) toPlayerView:(id)sender;
//- (void)clickedButton:(BoardViewController *)subcontroller;
- (void)dismissPlayerViewWithAnimation:(PlayerViewController *)subcontroller;
- (void)dismissRuleViewWithAnimation:(RuleViewController *)subcontroller;
- (void)dismissCreditViewWithAnimation:(CreditViewController *)subcontroller;
- (void)fadeVolumeDown:(AVAudioPlayer *)aPlayer;

@property(nonatomic, strong) PlayerViewController *playerViewScreen;
@property(nonatomic, strong) CreditViewController *creditViewScreen;
@property(nonatomic, strong) RuleViewController *ruleViewScreen;

@property(nonatomic, strong) AVAudioPlayer *audioPlayerOpen;

@end
