//
//  AtonGameEngine.h
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "AtonGameParameters.h"
#import "AtonRoundResult.h"
#import "TempleUtility.h"
#import "AtonMessageMaster.h"
#import "AbstractExecutor.h"
#import "AtonArrangeCardsExecutor.h"
#import "AtonRemovePeepExecutor.h"
#import "AtonPlacePeepExecutor.h"
#import "AtonAIEasy.h"
#import "AtonGameManager.h"
#import "GameData.h"

@interface AtonGameEngine:NSObject<GKMatchDelegate> {
    
    AtonMessageMaster *messageMaster;
  //  AtonGameManager *gameManager;
    AtonAI *ai;
  //  BOOL useAI;
    AtonPlacePeepExecutor *placePeepEngine;
    AtonRemovePeepExecutor *removePeepEngine;
    AtonArrangeCardsExecutor *arrangeCardExecutor;
}

-(id)initializeWithParameters:(AtonGameParameters*) parameter:(UIViewController*) controller:(AVAudioPlayer*) atonAudioPlayGame:(AVAudioPlayer*) atonAudioChime;
-(void) run;
-(void) playerDoneAction;

//-(void) imageFly:(UIImageView*) begin:(UIImageView*) end;
@property(strong, nonatomic) AtonGameParameters *para;
@property(strong, nonatomic) AtonGameManager *gameManager;
@property(nonatomic) BOOL useAI;

@end
