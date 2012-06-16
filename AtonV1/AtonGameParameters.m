//
//  AtonGameParameters.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameParameters.h"

@implementation AtonGameParameters

@synthesize playerArray, templeArray, scarabArray;
//@synthesize gameManager;
@synthesize gamePhaseEnum, localPlayerEnum;
@synthesize atonRoundResult;
@synthesize audioToDeath;
@synthesize useAI, onlineMode;
@synthesize onlinePara;
@synthesize arrangeCardData, removePeepData, placePeepData, firstRemove4Data, secondRemove4Data;


-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray:(NSMutableArray*) atonScarabArray:(AVAudioPlayer*) audio {
    
    if (self) {
        playerArray = atonPlayerArray;
        templeArray = atonTempleArray;
        scarabArray = atonScarabArray;
     //   gameManager = atonGameManager;
        atonRoundResult = [[AtonRoundResult alloc] initializeWithParameters:playerArray];
        audioToDeath = audio;
        useAI = YES;
        
    }
    return self;
}

@end
