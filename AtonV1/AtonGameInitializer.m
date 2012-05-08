//
//  AtonGameInitializer.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameInitializer.h"

@implementation AtonGameInitializer


static float SCARAB_WIDTH = 40;
static float SCARAB_HEIGHT = 44;

+(AtonGameParameters*) initializeNewGame:(UIViewController*) controller:(NSString*) redName: (NSString*) blueName{
    
    //----------------------
    // initialize players
    AtonPlayer *redPlayer = [[AtonPlayer alloc] initializeWithParameters:0:redName:controller];
    AtonPlayer *bluePlayer = [[AtonPlayer alloc] initializeWithParameters:1:blueName:controller];
    
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    [playerArray addObject:redPlayer];
    [playerArray addObject:bluePlayer];
    
    //------------------------
    // initialize temples
    AtonTemple *temple0 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_DEATH:CGPointMake(280, 648) :controller.view];
    AtonTemple *temple1 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_1:CGPointMake(286, 132) :controller.view];
    AtonTemple *temple2 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_2:CGPointMake(534, 132) :controller.view];
    AtonTemple *temple3 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_3:CGPointMake(286, 410) :controller.view];
    AtonTemple *temple4 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_4:CGPointMake(534, 410) :controller.view];
    
    NSMutableArray *templeArray = [[NSMutableArray alloc] init];
    [templeArray addObject:temple0];
    [templeArray addObject:temple1];
    [templeArray addObject:temple2];
    [templeArray addObject:temple3];
    [templeArray addObject:temple4];
    
    
    //--------------------------
    // initialize game manager
    AtonGameManager *gameManager = [[AtonGameManager alloc] initializeWithParameters:controller];

    //------------------------
    // initialize score scarab array
    NSMutableArray *scarabArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=15; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(218.0, 722.0 - i*47.5, SCARAB_WIDTH, SCARAB_HEIGHT)];
        [controller.view addSubview:iv];
        ScoreScarab *scarab = [[ScoreScarab alloc] initializeWithParameters:i :iv];
        [scarabArray addObject:scarab];
    }
    

    for (int i=16; i<=25; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(266.0 + (i-16)*50.4, 8, SCARAB_WIDTH, SCARAB_HEIGHT)];
        [controller.view addSubview:iv];
        ScoreScarab *scarab = [[ScoreScarab alloc] initializeWithParameters:i :iv];
        [scarabArray addObject:scarab];
    }
    
    for (int i=26; i<=41; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(768.0, 8.0 + (i-26)*47.5, SCARAB_WIDTH, SCARAB_HEIGHT)];
        [controller.view addSubview:iv];
        ScoreScarab *scarab = [[ScoreScarab alloc] initializeWithParameters:i :iv];
        [scarabArray addObject:scarab];
    }
    
    
    //-----------------------
    // create Aton parameters
    NSURL *urlDeath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/whip_deathTemple.aiff", [[NSBundle mainBundle] resourcePath]]];
	AVAudioPlayer *audioToDeath = [[AVAudioPlayer alloc] initWithContentsOfURL:urlDeath error:nil];
	audioToDeath.numberOfLoops = 0;
    audioToDeath.volume = 0.25;
    [audioToDeath prepareToPlay];
    
    AtonGameParameters *atonParameters = [[AtonGameParameters alloc] initializeWithParameters:playerArray :templeArray: scarabArray: gameManager:audioToDeath];
    
    
    return  atonParameters;
}

/*
-(int) shuffleCardArray {
    int *cardIntArray;
    cardIntArray = malloc(sizeof(int) * 10);

    
    for (int i=0; i<40; i++) {
        cardIntArray[i] = i+1;
    }
  
    
} */
@end
