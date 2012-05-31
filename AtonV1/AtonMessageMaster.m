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

static NSString *REMOVE_TEMPLE_COUNTERS = @"Remove Temple Counters|";
static NSString *CARD_2_RESULT = @"Card 2 Result|";
static NSString *CARD_4_RESULT = @"Card 4 Result|";
static NSString *RED_SPACE = @"Red ";
static NSString *BLUE_SPACE = @"Blue ";
static NSString *COUNTER = @"counter";
static NSString *REMOVE_N = @"\n\n Remove %i ";
static NSString *PLACE_N = @"\n\n Place %i ";

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
        msg = [msg stringByAppendingString:CARD_2_RESULT];
        msg = [msg stringByAppendingString:player.playerName];
        
        int number = firstRemoveNum;
        NSString* targetColor = [self getRemoveTargetColor:firstPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        
        msg = [msg stringByAppendingString:[NSString stringWithFormat:REMOVE_N, number]];
        if (number > 0) {
            msg = [msg stringByAppendingString:targetColor];
        }
        
        msg = [msg stringByAppendingString:COUNTER];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        
        if (number > 0) {
            msg = [msg stringByAppendingString:[self getAllowedTempleString:firstTemple]];
        } else {
            msg = [msg stringByAppendingString:@"\n\n"];
        }
        
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:CARD_2_RESULT];
        msg = [msg stringByAppendingString:player.playerName];
        int number = secondRemoveNum;
        NSString* targetColor = [self getRemoveTargetColor:secondPlayerEnum:number];
        if (number < 0) {
            number = number * (-1);
        }
        
        msg = [msg stringByAppendingString:[NSString stringWithFormat:REMOVE_N, number]];
        if (number > 0) {
            msg = [msg stringByAppendingString:targetColor];
        }
        
        msg = [msg stringByAppendingString:COUNTER];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        
        if (number > 0) {
            msg = [msg stringByAppendingString:[self getAllowedTempleString:secondTemple]];
        } else {
            msg = [msg stringByAppendingString:@"\n\n"];
        }
        
        
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        AtonPlayer *player = [playerArray objectAtIndex:firstPlayerEnum];
        msg = [msg stringByAppendingString:CARD_4_RESULT];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:firstPlayerEnum];
        int number = firstPlaceNum;
        msg = [msg stringByAppendingString:[NSString stringWithFormat:PLACE_N, number]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:COUNTER];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        msg = [msg stringByAppendingString:[self getAllowedTempleString:firstTemple]];
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:CARD_4_RESULT];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:secondPlayerEnum];
        int number = secondPlaceNum;
        msg = [msg stringByAppendingString:[NSString stringWithFormat:PLACE_N, number]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:COUNTER];
        if (number > 1) {
            msg = [msg stringByAppendingString:@"s"];
        }
        msg = [msg stringByAppendingString:[self getAllowedTempleString:secondTemple]];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        
        int currentPlayerEnum = para.atonRoundResult.higherScorePlayer;
        AtonPlayer *player = [playerArray objectAtIndex:currentPlayerEnum];
        msg = [msg stringByAppendingString:REMOVE_TEMPLE_COUNTERS];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:currentPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"counter\n from each Temple\n\n"];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        int currentPlayerEnum = para.atonRoundResult.lowerScorePlayer;
        AtonPlayer *player = [playerArray objectAtIndex:currentPlayerEnum];
        msg = [msg stringByAppendingString:REMOVE_TEMPLE_COUNTERS];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:currentPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"counter\n from each Temple\n\n"];
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
        return RED_SPACE;
    } else {
        return BLUE_SPACE;
    }
}

-(NSString*) getRemoveTargetColor:(int) playerEnum:(int) removeNum {
    if (playerEnum == 0) {
        if (removeNum > 0) {
            return BLUE_SPACE;
        } else {
            return RED_SPACE;
        }
    } else {
        if (removeNum > 0) {
            return RED_SPACE;
        } else {
            return BLUE_SPACE;
        }
    }
}

-(NSString*) getAllowedTempleString:(int) templeEnum {
    if (templeEnum == TEMPLE_1) {
        return @" in\n Temple 1\n";
        
    } else if (templeEnum == TEMPLE_2) {
        return @" in\n Temple 1, 2\n";
        
    } else if (templeEnum == TEMPLE_3) {
        return @" in\n Temple 1, 2, 3\n";
        
    }
    
    return @" in\n Temple 1, 2, 3, 4\n";
} 

-(NSString*) getMessageForTempleScoreResult:(TempleScoreResult*) result {
    
    NSString *msg = result.resultName;
    msg = [msg stringByAppendingString:@"|"];
    
    if (result.winningPlayerEnum == PLAYER_NONE) {
        msg = [msg stringByAppendingString:[self getMessageForEnum:MSG_TIE]];
        return msg;
    }
    
    AtonPlayer* winningPlayer = [para.playerArray objectAtIndex:result.winningPlayerEnum];
    NSString* playerName = winningPlayer.playerName;

    msg = [msg stringByAppendingString:playerName];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n\n Wins %i point", result.winningScore]];
    if (result.winningScore > 1) {
        msg = [msg stringByAppendingString:@"s"];
    }
    msg = [msg stringByAppendingString:@"\n\n"];
    return  msg;
}

+(NSString*) getTempleScoreResultName:(int) resultEnum {
    if (resultEnum == SCORE_TEMPLE_1) {
        return @"Temple 1 Score";
        
    } else if (resultEnum == SCORE_TEMPLE_2) {
        return @"Temple 2 Score";
        
    } else if (resultEnum == SCORE_TEMPLE_3) {
        return @"Temple 3 Score";
        
    } else if (resultEnum == SCORE_TEMPLE_4) {
        return @"Temple 4 Score";
        
    } else if (resultEnum == SCORE_GREY_BONUS) {
        return @"Black Square Score";
        
    } else if (resultEnum == SCORE_ORANGE_BONUS_RED) {
        return @"Orange Bonus for Red";
        
    } else if (resultEnum == SCORE_ORANGE_BONUS_BLUE) {
        return @"Orange Bonus for Blue";
        
    }
    
    // code should never reach here
    return nil;
}

-(NSString*) getMessageForEnum:(int) msgEnum {
    if (msgEnum == MSG_PLAYER_ARRANGE_CARD) {
        return @"\n\n Please arrange\n your card placements";
        
    } else if (msgEnum == MSG_COMPARE_RESULTS) {
        return @"Compare Results";
        
    } else if (msgEnum == MSG_TIE) {
        return @"TIE\n\n No player gains point";
        
    } else if (msgEnum == MSG_NO_PEEP_TO_REMOVE) {
        return @"|No available counter\n to remove\n";
        
    } else if (msgEnum == MSG_ALL_PEEPS_REMOVED) {
        return @"|All counters removed\n";
        
    }  else if (msgEnum == MSG_NO_SQUARE_TO_PLACE) {
        return @"|No available square\n to place counter\n";
        
    } else if (msgEnum == MSG_ALL_SQUARE_FILLED) {
        return @"|All available sqares\n filled with counters\n";
        
    } else if (msgEnum == MSG_DEAD_KINGDOM_FULL) {
        return @"Kingdom of the Dead is full\n\n Scoring Phase begins";
        
    } else if (msgEnum == MSG_TURN_END) {
        return @"End of Turn";
        
    } else if (msgEnum == MSG_NEW_ROUND_BEGIN) {
        return @"New Round Begins";
        
    }
    return nil;
}
@end
