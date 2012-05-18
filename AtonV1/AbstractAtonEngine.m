//
//  AbstractAtonEngine.m
//  AtonV1
//
//  Created by Wen Lin on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractAtonEngine.h"

@implementation AbstractAtonEngine



-(NSString*) gameOverConditionSuper {
    
    
    NSString *msg;
    
    //  if ([TempleUtility isYellowFull:para.templeArray]) {
    if ([TempleUtility findColorFullWinner:para1.templeArray:YELLOW] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para1.templeArray:YELLOW];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"All Yellow Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findColorFullWinner:para1.templeArray:GREEN]!= PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para1.templeArray:GREEN];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"All Green Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_1] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_1];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 1 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_2] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_2];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 2 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_3] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_3];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 3 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_4] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para1.templeArray:TEMPLE_2];
        AtonPlayer *winner = [para1.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 4 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    }
    
    NSMutableArray *playerArray = para1.playerArray;
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    if (redScore >= 40 && blueScore >= 40) {
        msg = @"";
        msg = [msg stringByAppendingString:@"Both players reaches 40 points|"];
        
    } else if (redScore >= 40) {
        AtonPlayer *winner = [para1.playerArray objectAtIndex:PLAYER_RED];
        msg = @"";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@"\n reaches 40 points and wins|"];
        
    } else if (blueScore >= 40) {
        AtonPlayer *winner = [para1.playerArray objectAtIndex:PLAYER_BLUE];
        msg = @"";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@"\n reaches 40 points and wins|"];
        
    }
    
    if (msg != nil) {
        msg = [msg stringByAppendingString:[self gameOverResultMsg]];
    }
    
    return msg;
}

-(NSString*) gameOverResultMsg {
    
    NSMutableArray *playerArray = para1.playerArray;
    NSString *msg = @"Game Over\n";
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Red: %i \n", redScore]];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Blue: %i \n", blueScore]];
    return msg;
}

@end
