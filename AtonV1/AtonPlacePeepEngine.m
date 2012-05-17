//
//  AtonPlacePeepEngine.m
//  AtonV1
//
//  Created by Wen Lin on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonPlacePeepEngine.h"

@implementation AtonPlacePeepEngine

static double AFTER_PEEP_DELAY_TIME = 2.0;
static float MESSAGE_DELAY_TIME = 0.2;


-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para = atonParameter;
        messageMaster = atonMessageMaster;
        useAI = para.useAI;
        ai = atonAI;
    }
    return self;
}

/*
-(void) placePeep {
    
    AtonRoundResult *roundResult = para.atonRoundResult;
    NSMutableArray *templeArray = para.templeArray;
    NSMutableArray *playerArray = para.playerArray;
    AtonPlayer *firstPlayer = [playerArray objectAtIndex:roundResult.firstPlayerEnum];
    
    if (useAI == YES && roundResult.firstPlayerEnum == PLAYER_BLUE) {
        double animationTime = [ai placePeeps:roundResult.firstPlayerEnum:roundResult.firstPlaceNum:roundResult.firstTemple];
        [self performSelector:@selector(disableTempleSlotForInteraction) withObject:nil afterDelay:animationTime];
        NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
        para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:(animationTime + AFTER_PEEP_DELAY_TIME)];
    } else {
        [TempleUtility changeSlotBoundaryColor:para.templeArray:roundResult.firstPlayerEnum];
        
        NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:para.atonRoundResult.firstTemple: OCCUPIED_EMPTY];
        int arrayNum = [eligibleSlotArray count];
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"|No Available Space\n to Place Peep\n";
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            
        } else if (arrayNum <= para.atonRoundResult.firstPlaceNum) {
            
            int occupiedEnum = OCCUPIED_RED;
            if (roundResult.firstPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            for (int i=0; i < [eligibleSlotArray count]; i++) {
                TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
                [selectedSlot placePeep:occupiedEnum];
            }
            [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
            
            NSString *msg = @"|All Eligible Spaces\n Filled With Peeps\n";
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
        } else {
            [firstPlayer displayMenu:ACTION_PLACE:roundResult.firstPlaceNum];
        }
        
    }

}*/


-(void) placePeep:(int) gamePhaseEnum {    
    
    NSMutableArray *templeArray = para.templeArray;
    NSMutableArray *playerArray = para.playerArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    int activePlayerEnum = roundResult.firstPlayerEnum;
    int activePlayerMaxTempleEnum = roundResult.firstTemple;
    int activePlayerPlaceNum = roundResult.firstPlaceNum;
    
    if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        activePlayerEnum = roundResult.secondPlayerEnum;
        activePlayerMaxTempleEnum = roundResult.secondTemple;
        activePlayerPlaceNum = roundResult.secondPlaceNum;
    }
    
    AtonPlayer *activePlayer = [playerArray objectAtIndex:activePlayerEnum];
    
    [TempleUtility changeSlotBoundaryColor:para.templeArray:activePlayerEnum];
    NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
    int arrayNum = [eligibleSlotArray count];
    if ([eligibleSlotArray count] == 0) {
        [TempleUtility disableAllTempleSlotInteraction:templeArray];
        NSString *msg = @"|No Available Space\n to Place Peep\n";

        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
            
    } else if (arrayNum <= activePlayerPlaceNum) {

        int occupiedEnum = OCCUPIED_RED;
        if (roundResult.secondPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
        }
        for (int i=0; i < [eligibleSlotArray count]; i++) {
            TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
            [selectedSlot placePeep:occupiedEnum];
        }
        [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
            
        NSString *msg = @"|All Eligible Spaces\n Filled With Peeps\n";
        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
    } else {
            
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            double animationTime = [ai placePeeps:activePlayerEnum:activePlayerPlaceNum:activePlayerMaxTempleEnum];
                
            // to remove the slot black boundary
            [self performSelector:@selector(disableTempleSlotForInteraction) withObject:nil afterDelay:animationTime];
                
            if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
                para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
                [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:(animationTime + AFTER_PEEP_DELAY_TIME)];
                    
            } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
                [self performSelector:@selector(checkRoundEnd) withObject:nil afterDelay:animationTime];
                    
            } else {
                // code should never reach here.
                NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
            }
                
        } else {
            [activePlayer displayMenu:ACTION_PLACE:activePlayerPlaceNum];
        }
            
    }
    
}


-(void) disableTempleSlotForInteraction {
    [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
}

-(void) checkRoundEnd {
    
    [self disableTempleSlotForInteraction];
    if ([self gameOverCondition] != nil) {
        [para.gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverCondition] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        //   [TempleUtility clearDeathTemple:[para templeArray]];
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        para.gameManager.messagePlayerEnum = PLAYER_NONE;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Death Temple Full\n Scoring Phase Begin" afterDelay: AFTER_PEEP_DELAY_TIME];
        //[self run];
    } else {
        para.gameManager.messagePlayerEnum = PLAYER_NONE;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }
    
}


-(NSString*) gameOverCondition {
    
    
    NSString *msg;
    
    //  if ([TempleUtility isYellowFull:para.templeArray]) {
    if ([TempleUtility findColorFullWinner:para.templeArray:YELLOW] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para.templeArray:YELLOW];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"All Yellow Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findColorFullWinner:para.templeArray:GREEN]!= PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para.templeArray:GREEN];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"All Green Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_1] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_1];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 1 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_2] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_2];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 2 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_3] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_3];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 3 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_4] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_2];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 4 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" Wins|"];
        
    }
    
    NSMutableArray *playerArray = para.playerArray;
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    if (redScore >= 40 && blueScore >= 40) {
        msg = @"";
        msg = [msg stringByAppendingString:@"Both players reaches 40 points|"];
        
    } else if (redScore >= 40) {
        AtonPlayer *winner = [para.playerArray objectAtIndex:PLAYER_RED];
        msg = @"";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@"\n reaches 40 points and wins|"];
        
    } else if (blueScore >= 40) {
        AtonPlayer *winner = [para.playerArray objectAtIndex:PLAYER_BLUE];
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
    
    NSMutableArray *playerArray = para.playerArray;
    NSString *msg = @"Game Over\n";
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Red: %i \n", redScore]];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Blue: %i \n", blueScore]];
    return msg;
}

@end
