//
//  AtonGameParameters.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"
#import "AtonTemple.h"
#import "AtonGameManager.h"


enum GAME_PHASE_ENUM {
  GAME_PHASE_DISTRIBUTE_CARD, 
  GAME_PHASE_RED_LAY_CARD, GAME_PHASE_RED_CLOSE_CARD,
  GAME_PHASE_BLUE_LAY_CARD, GAME_PHASE_BLUE_CLOSE_CARD,
  GAME_PHASE_COMPARE,
  GAME_PHASE_REMOVE_PEEP, GAME_PHASE_PLACE_PEEP  
};

@interface AtonGameParameters : NSObject

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray: (AtonGameManager*) atonGameManager;

@property(strong, nonatomic) NSMutableArray *playerArray, *templeArray;
@property(strong, nonatomic) AtonGameManager *gameManager;
@property(nonatomic) int gamePhaseEnum;

@end
