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

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray:(NSMutableArray*) atonScarabArray:(AtonGameManager*) atonGameManager {
    
    if (self) {
        playerArray = atonPlayerArray;
        templeArray = atonTempleArray;
        scarabArray = atonScarabArray;
        gameManager = atonGameManager;
        atonRoundResult = [[AtonRoundResult alloc] initializeWithParameters:playerArray];
        
    }
    return self;
}

@end
