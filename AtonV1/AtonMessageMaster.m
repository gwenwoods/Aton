//
//  AtonMessageMaster.m
//  AtonV1
//
//  Created by Wen Lin on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonMessageMaster.h"

@implementation AtonMessageMaster
@synthesize para;

-(id)initializeWithParameters:(AtonGameParameters*) parameter {
	if (self) {
        para = parameter;

    }
    return self;
}


-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum {
    NSString* msg = @"";
    
    NSMutableArray *playerArray = para.playerArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    int firstPlayerEnum = roundResult.firstPlayerEnum;
    int firstTemple = roundResult.firstTemple;
    int firstRemoveNum = roundResult.firstRemoveNum;
    int firstPlaceNum = roundResult.firstPlaceNum;
    int secondPlayerEnum = roundResult.secondPlayerEnum;
    int secondTemple = roundResult.secondTemple;
    int secondRemoveNum = roundResult.secondRemoveNum;
    int secondPlaceNum = roundResult.secondPlaceNum;
    
    if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:firstPlayerEnum];
        msg = [msg stringByAppendingString:@"Card 2 Result:|"];
        msg = [msg stringByAppendingString:player.playerName];
        
        int number = firstRemoveNum;
        NSString* targetColor = [self getRemoveTargetColor:firstPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n remove %i ", number]];
        if (number > 0) {
            msg = [msg stringByAppendingString:targetColor];
        }
        
        msg = [msg stringByAppendingString:@"Peep"];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        
        if (number > 0) {
            msg = [msg stringByAppendingString:[self getAllowedTempleString:firstTemple]];
        }
        
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:@"Card 2 Result|"];
        msg = [msg stringByAppendingString:player.playerName];
        int number = secondRemoveNum;
        NSString* targetColor = [self getRemoveTargetColor:secondPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n remove %i ", number]];
        if (number > 0) {
            msg = [msg stringByAppendingString:targetColor];
        }
        
        msg = [msg stringByAppendingString:@"Peep"];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        
        if (number > 0) {
            msg = [msg stringByAppendingString:[self getAllowedTempleString:secondTemple]];
        }
        
        
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        AtonPlayer *player = [playerArray objectAtIndex:firstPlayerEnum];
        msg = [msg stringByAppendingString:@"Card 4 Result|"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:firstPlayerEnum];
        int number = firstPlaceNum;
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n place %i ", number]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep"];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        msg = [msg stringByAppendingString:[self getAllowedTempleString:firstTemple]];
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:@"Card 4 Result|"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:secondPlayerEnum];
        int number = secondPlaceNum;
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n place %i ", number]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep"];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        msg = [msg stringByAppendingString:[self getAllowedTempleString:secondTemple]];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        
        AtonPlayer *player = [playerArray objectAtIndex:firstPlayerEnum];
        msg = [msg stringByAppendingString:@"Round End|"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:firstPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep from each temple"];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:@"Round End|"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:secondPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep from each temple"];
    }
    
    return  msg;
    
} 

-(int) getFirstRemoveTargetEnum {
    
    if (para.atonRoundResult.firstRemoveNum < 0) {
        return para.atonRoundResult.firstPlayerEnum;
    }  else {
        return para.atonRoundResult.secondPlayerEnum;
    }
}

-(int) getSecondRemoveTargetEnum {
    
    if (para.atonRoundResult.secondRemoveNum < 0) {
        return para.atonRoundResult.secondPlayerEnum;
    }  else {
        return para.atonRoundResult.firstPlayerEnum;
    }
}

-(int) getFirstRemovePositiveNum {
    if (para.atonRoundResult.firstRemoveNum >= 0) {
        return para.atonRoundResult.firstRemoveNum;
    } else {
        return para.atonRoundResult.firstRemoveNum * (-1);
    }
}

-(int) getSecondRemovePositiveNum {
    if (para.atonRoundResult.secondRemoveNum >= 0) {
        return para.atonRoundResult.secondRemoveNum;
    } else {
        return para.atonRoundResult.secondRemoveNum * (-1);
    }
}


-(NSString*) getPlayerColor:(int) playerEnum {
    if (playerEnum == 0) {
        return @"Red ";
    } else {
        return @"Blue ";
    }
}

-(NSString*) getRemoveTargetColor:(int) playerEnum:(int) removeNum {
    if (playerEnum == 0) {
        if (removeNum > 0) {
            return @"Blue ";
        } else {
            return @"Red ";
        }
    } else {
        if (removeNum > 0) {
            return @"Red ";
        } else {
            return @"Blue ";
        }
    }
}

-(NSString*) getAllowedTempleString:(int) templeEnum {
    if (templeEnum == TEMPLE_1) {
        return @"\n in Temple 1";
        
    } else if (templeEnum == TEMPLE_2) {
        return @"\n in Temple 1 and 2";
        
    } else if (templeEnum == TEMPLE_3) {
        return @"\n in Temple 1, 2 and 3";
        
    }
    
    return @"\n in any Temple";
} 

-(NSString*) getMessageForTempleScoreResult:(TempleScoreResult*) result {
    
    NSString *msg = result.resultName;
    msg = [msg stringByAppendingString:@"|"];
    if (result.winningPlayerEnum == PLAYER_NONE) {
        msg = [msg stringByAppendingString:@"|Tie\n"];
        return msg;
    }
    
    AtonPlayer* winningPlayer = [para.playerArray objectAtIndex:result.winningPlayerEnum];
    NSString* playerName = winningPlayer.playerName;

    msg = [msg stringByAppendingString:playerName];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n wins %i point", result.winningScore]];
    if (result.winningScore > 1) {
        msg = [msg stringByAppendingString:@"s"];
    }
    return  msg;
}
@end
