//
//  AtonGameEngine.h
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractAtonEngine.h"
#import "AtonGameParameters.h"
#import "AtonRoundResult.h"
#import "TempleUtility.h"
#import "AtonMessageMaster.h"
#import "AtonArrangeCardsEngine.h"
#import "AtonRemovePeepEngine.h"
#import "AtonPlacePeepEngine.h"
#import "AtonAIEasy.h"
#import "AtonGameManager.h"

@interface AtonGameEngine : AbstractAtonEngine {
    AtonMessageMaster *messageMaster;
  //  AtonGameManager *gameManager;
    AtonAI *ai;
  //  BOOL useAI;
    AtonPlacePeepEngine *placePeepEngine;
    AtonRemovePeepEngine *removePeepEngine;
    AtonArrangeCardsEngine *arrangeCardEngine;
}

-(id)initializeWithParameters:(AtonGameParameters*) parameter:(UIViewController*) controller;
-(void) run;
-(void) playerDoneAction;

-(void) imageFly:(UIImageView*) begin:(UIImageView*) end;
@property(strong, nonatomic) AtonGameParameters *para;
@property(strong, nonatomic) AtonGameManager *gameManager;
@property(nonatomic) BOOL useAI;

@end
