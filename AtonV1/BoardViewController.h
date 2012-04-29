//
//  BoardViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <AppKit/AppKit.h>

//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreAudio/CoreAudio.h>
#import "AtonGameInitializer.h"
#import "AtonTouchBeganUtility.h"
#import "AtonTouchMovedUtility.h"
#import "AtonTouchEndUtility.h"
#import "AtonTouchElement.h"
#import "AtonGameEngine.h"

#import "AtonTemple.h"

@class BoardViewController;

@protocol myDelegate
-(void)clickedButton:(BoardViewController*) subController;
@end

@interface BoardViewController : UIViewController {
    AVAudioPlayer *audioPlayer;
    CGPoint touchLocation;
   // id<myDelegate> delegate1;
    __unsafe_unretained id delegate1;
   // id delegate1;
  
}

- (IBAction) toMenu:(id)sender;
- (IBAction) exchangeCards:(id)sender;
- (IBAction) exchangeCardsYes:(id)sender;
- (IBAction) exchangeCardsNo:(id)sender;

//@property(strong, nonatomic) AtonPlayer *redPlayer, *bluePlayer;
@property(strong, nonatomic) AtonGameEngine *atonGameEngine;
@property(strong, nonatomic) AtonGameParameters *atonParameters;
@property(strong, nonatomic) AtonTouchElement *touchElement;

@property(strong, nonatomic) AtonTemple* temple1;
@property (nonatomic, assign) id<myDelegate> delegate1;   
//NSString *data;
//-(NSString *)getData;


@end




