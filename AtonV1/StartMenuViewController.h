//
//  StartMenuViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "CreditViewController.h"
#import "PlayerViewController.h"

@interface StartMenuViewController : UIViewController<PlayerViewDelegate, CreditViewDelegate>
{
    IBOutlet UIImageView *playIV, *rulesIV, *creditsIV;
    IBOutlet UIImageView *playAnkhIV, *rulesAnkhIV, *creditsAnkhIV;

    AVAudioPlayer *audioPlayerEnterPlay, *audioPlayerOpen;
}

-(IBAction) toPlayerView:(id)sender;
- (void)clickedButton:(BoardViewController *)subcontroller;
- (void)dismissPlayerViewWithAnimation:(PlayerViewController *)subcontroller;
- (void)dismissCreditViewWithAnimation:(CreditViewController *)subcontroller;
- (void)fadeVolumeDown:(AVAudioPlayer *)aPlayer;

@property(nonatomic, strong) PlayerViewController *playerViewScreen;
@property(nonatomic, strong) CreditViewController *creditViewScreen;
@property(nonatomic, strong) AVAudioPlayer *audioPlayerOpen;

@end
