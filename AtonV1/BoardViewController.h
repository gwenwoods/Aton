//
//  BoardViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AtonGameInitializer.h"
#import "AtonTouchBeganUtility.h"
#import "AtonTouchMovedUtility.h"
#import "AtonTouchEndUtility.h"
#import "AtonTouchElement.h"
#import "AtonGameEngine.h"
#import "AtonAIEasy.h"

#import "AtonTemple.h"
#import "OnlineParameters.h"

@class BoardViewController;

@protocol BoardViewDelegate
-(void)dismissBoardViewWithoutAnimation:(BoardViewController*) subController;
@end

@interface BoardViewController : UIViewController {
    AVAudioPlayer *audioPlayer;
    CGPoint touchLocation;
   // id<myDelegate> delegate1;
    __unsafe_unretained id delegateBoardView;
   // id delegate1;
 //   NSString *playerRedName, *playerBlueName;
    AVAudioPlayer *audioPlacePeep, *audioPlayGame, *audioTap, *audioChime;
    BOOL useAI, onlineMode;
    int localPlayerEnum;
    
    OnlineParameters *onlinePara;
  
}

- (IBAction) toMenu:(id)sender;
- (IBAction) doneAction:(id)sender;
- (IBAction) exchangeCards:(id)sender;
- (IBAction) exchangeCardsYes:(id)sender;
- (IBAction) exchangeCardsNo:(id)sender;
- (IBAction) quitYes:(id)sender;
- (IBAction) quitNo:(id)sender;
- (id)initWithNibNameAndPara:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil red:(NSString*)redName blue:(NSString*) blueName:(BOOL) useAtonAI;
- (id)initWithOnlinePara:(OnlineParameters*) onlinePara;
//@property(strong, nonatomic) AtonPlayer *redPlayer, *bluePlayer;
@property(strong, nonatomic) AtonGameEngine *atonGameEngine;
@property(strong, nonatomic) AtonGameParameters *atonParameters;
@property(strong, nonatomic) AtonTouchElement *touchElement;
@property(strong, nonatomic) NSString *playerRedName, *playerBlueName;

@property(strong, nonatomic) AtonTemple* temple1;
@property(nonatomic, assign) id<BoardViewDelegate> delegateBoardView;

//NSString *data;
//-(NSString *)getData;


@end




