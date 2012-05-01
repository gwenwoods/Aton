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

@interface StartMenuViewController : UIViewController<myDelegate, playerViewDelegate>
{
    IBOutlet UIImageView *playIV, *rulesIV, *creditsIV;
    IBOutlet UIImageView *playAnkhIV, *rulesAnkhIV, *creditsAnkhIV;
    //BOOL longPress;
    AVAudioPlayer *audioPlayerEnterPlay, *audioPlayerOpen;
   // float openMusicTime;
}

-(IBAction) toPlayerView:(id)sender;
- (void)clickedButton:(BoardViewController *)subcontroller;
- (void)clickedButton1:(PlayerViewController *)subcontroller;


@end
