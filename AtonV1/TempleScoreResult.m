//
//  TempleScoreResult.m
//  AtonV1
//
//  Created by Wen Lin on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempleScoreResult.h"

@implementation TempleScoreResult

@synthesize templeEnum;
@synthesize resultName;
@synthesize winningPlayerEnum, winningScore;

-(NSString*) getWinningMessage {
    
    NSString *msg = resultName;
    msg = [msg stringByAppendingString:@"result: \n\n"];
    
    if (winningPlayerEnum == PLAYER_NONE) {
        msg = [msg stringByAppendingString:@"Tie"];
        return msg;
    }
    
    
    NSString* playerName = @"Player Red ";
    if (winningPlayerEnum == PLAYER_BLUE) {
        playerName = @"Player Blue ";
    }
    msg = [msg stringByAppendingString:playerName];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"wins %i point", winningScore]];
    if (winningScore > 1) {
        msg = [msg stringByAppendingString:@"s"];
    }
    return  msg;
}

@end
