//
//  AtonGameInitializer.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameInitializer.h"

@implementation AtonGameInitializer

+(AtonGameParameters*) initializeNewGame:(UIViewController*) controller {
    
    //----------------------
    // initialize players
    AtonPlayer *redPlayer = [[AtonPlayer alloc] initializeWithParameters:0 :nil:controller];
    AtonPlayer *bluePlayer = [[AtonPlayer alloc] initializeWithParameters:1 :nil:controller];
    
    int redStartNumArray[] = {1,2,3,4};
    [redPlayer initilizeCardElement:redStartNumArray];
    
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    [playerArray addObject:redPlayer];
    [playerArray addObject:bluePlayer];
    
    //------------------------
    // initialize temples
    AtonTemple *temple1 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_1:CGPointMake(236, 144) :controller.view];
    AtonTemple *temple2 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_2:CGPointMake(486, 144) :controller.view];
    AtonTemple *temple3 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_3:CGPointMake(236, 422) :controller.view];
    AtonTemple *temple4 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_4:CGPointMake(486, 422) :controller.view];
    
    NSMutableArray *templeArray = [[NSMutableArray alloc] init];
    [templeArray addObject:temple1];
    [templeArray addObject:temple2];
    [templeArray addObject:temple3];
    [templeArray addObject:temple4];
    
    
    //--------------------------
    // initialize game manager
    AtonGameManager *gameManager = [[AtonGameManager alloc] initializeWithParameters:controller.view];
    
    //-----------------------
    // create Aton parameters
    AtonGameParameters *atonParameters = [[AtonGameParameters alloc] initializeWithParameters:playerArray :templeArray:gameManager];
    
    return  atonParameters;
}

@end
