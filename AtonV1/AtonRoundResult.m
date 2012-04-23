//
//  AtonRoundResult.m
//  AtonV1
//
//  Created by Wen Lin on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonRoundResult.h"

@implementation AtonRoundResult

@synthesize firstPlayerEnum, secondPlayerEnum;
@synthesize firstActiveTemple, secondActiveTemple;
@synthesize firstRemoveNum, secondRemoveNum;
@synthesize firstPlaceNum, secondPlaceNum;
@synthesize firstPlaceCount, secondPlaceCount;
@synthesize firstTemple, secondTemple;
@synthesize cardOneWinnerEnum, cardOneWinningScore;

-(void) reset {
    firstPlaceCount = 0;
    secondPlaceCount = 0;
}

-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum {
    
    NSString* msg = @"";
    
    if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        msg = [msg stringByAppendingString:@"Card 2 Result:\n"];
        NSString* playerColor = [self getPlayerColor:firstPlayerEnum];
        int number = firstRemoveNum;
        NSString* targetColor = [self getTargetColor:firstPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n should remove %i ", number]];
        msg = [msg stringByAppendingString:targetColor];
        msg = [msg stringByAppendingString:@" Peep"];
        if (number > 1) {
             msg = [msg stringByAppendingString:@"s"];
        }
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        msg = [msg stringByAppendingString:@"Card 2 Result:\n"];
        NSString* playerColor = [self getPlayerColor:secondPlayerEnum];
        int number = secondRemoveNum;
        NSString* targetColor = [self getTargetColor:secondPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n should remove %i ", number]];
        msg = [msg stringByAppendingString:targetColor];
        msg = [msg stringByAppendingString:@" Peep"];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        
    }
    return  msg;
}

-(int) getFirstRemoveTargetEnum {
    
    if (firstRemoveNum < 0) {
        return firstPlayerEnum;
    }  else {
        return secondPlayerEnum;
    }
}

-(int) getSecondRemoveTargetEnum {
    
    if (secondRemoveNum < 0) {
        return secondPlayerEnum;
    }  else {
        return firstPlayerEnum;
    }
}

-(int) getFirstRemovePositiveNum {
    if (firstRemoveNum >= 0) {
        return firstRemoveNum;
    } else {
        return firstRemoveNum * (-1);
    }
}

-(int) getSecondRemovePositiveNum {
    if (secondRemoveNum >= 0) {
        return secondRemoveNum;
    } else {
        return secondRemoveNum * (-1);
    }
}


-(NSString*) getPlayerColor:(int) playerEnum {
    if (playerEnum == 0) {
        return @"Player Red";
    } else {
        return @"Player Blue";
    }
}

-(NSString*) getTargetColor:(int) playerEnum:(int) removeNum {
    if (playerEnum == 0) {
        if (removeNum > 0) {
            return @"Blue";
        } else {
            return @"Red";
        }
    } else {
        if (removeNum > 0) {
            return @"Red";
        } else {
            return @"Blue";
        }
    }
}
@end
