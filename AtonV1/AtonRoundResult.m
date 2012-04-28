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
@synthesize firstTemple, secondTemple;
@synthesize cardOneWinnerEnum, cardOneWinningScore;
@synthesize templeScoreResultArray;


-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray {
	if (self) {
        playerArray = atonPlayerArray;
    }
    return self;
}

/*-(void) reset {

}*/

-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum {
    
    NSString* msg = @"";
    
    if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        AtonPlayer *player = [playerArray objectAtIndex:firstPlayerEnum];
        msg = [msg stringByAppendingString:@"Card 2 Result:\n\n"];
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
        msg = [msg stringByAppendingString:@"Card 2 Result:\n\n"];
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
        msg = [msg stringByAppendingString:@"Card 4 Result:\n\n"];
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
        msg = [msg stringByAppendingString:@"Card 4 Result:\n\n"];
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
        msg = [msg stringByAppendingString:@"Round End Result:\n\n"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:firstPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep from each temple"];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        
        AtonPlayer *player = [playerArray objectAtIndex:secondPlayerEnum];
        msg = [msg stringByAppendingString:@"Round End Result:\n\n"];
        msg = [msg stringByAppendingString:player.playerName];
        
        NSString* playerColor = [self getPlayerColor:secondPlayerEnum];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n Remove 1 "]];
        msg = [msg stringByAppendingString:playerColor];
        msg = [msg stringByAppendingString:@"Peep from each temple"];
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
@end
