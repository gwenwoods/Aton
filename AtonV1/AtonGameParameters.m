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
@synthesize gameManager;
@synthesize gamePhaseEnum;
@synthesize atonRoundResult;
@synthesize audioToDeath;
@synthesize useAI;


-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray:(NSMutableArray*) atonScarabArray:(AtonGameManager*) atonGameManager:(AVAudioPlayer*) audio {
    
    if (self) {
        playerArray = atonPlayerArray;
        templeArray = atonTempleArray;
        scarabArray = atonScarabArray;
        gameManager = atonGameManager;
        atonRoundResult = [[AtonRoundResult alloc] initializeWithParameters:playerArray];
        audioToDeath = audio;
        useAI = YES;
        
    }
    return self;
}

@end
