//
//  AtonGameParameters.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AtonPlayer.h"
#import "AtonTemple.h"
//#import "AtonGameManager.h"
#import "AtonRoundResult.h"
#import "ScoreScarab.h"
#import "OnlineParameters.h"
#import "GameData.h"




@interface AtonGameParameters : NSObject

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray:(NSMutableArray*) atonScarabArray:(AVAudioPlayer*) audio;

@property(strong, nonatomic) NSMutableArray *playerArray, *templeArray, *scarabArray;
//@property(strong, nonatomic) AtonGameManager *gameManager;
@property(nonatomic) int gamePhaseEnum, localPlayerEnum;
@property(strong, nonatomic) AtonRoundResult *atonRoundResult;
@property(strong, nonatomic) AVAudioPlayer *audioToDeath;
@property(nonatomic) BOOL useAI, onlineMode;    
@property(strong, nonatomic) OnlineParameters *onlinePara;
@property(strong, nonatomic) GameData *removePeepData, *placePeepData, *firstRemove4Data, *secondRemove4Data;
@end
