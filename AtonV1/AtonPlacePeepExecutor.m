//
//  AtonPlacePeepExecutor.m
//  AtonV1
//
//  Created by Wen Lin on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonPlacePeepExecutor.h"

@implementation AtonPlacePeepExecutor

static double AFTER_PEEP_DELAY_TIME = 2.0;
static float MESSAGE_DELAY_TIME = 0.2;


-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para1 = atonParameter;
        gameManager = atonGameManager;
        messageMaster = atonMessageMaster;
        useAI = atonParameter.useAI;
        ai = atonAI;
    }
    return self;
}


-(void) placePeep:(int) gamePhaseEnum {    
    
    NSMutableArray *templeArray = para1.templeArray;
    NSMutableArray *playerArray = para1.playerArray;
    AtonRoundResult *roundResult = para1.atonRoundResult;
    
    int activePlayerEnum = roundResult.firstPlayerEnum;
    int activePlayerMaxTempleEnum = roundResult.firstTemple;
    int activePlayerPlaceNum = roundResult.firstPlaceNum;
    
    if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        activePlayerEnum = roundResult.secondPlayerEnum;
        activePlayerMaxTempleEnum = roundResult.secondTemple;
        activePlayerPlaceNum = roundResult.secondPlaceNum;
    }
    
    AtonPlayer *activePlayer = [playerArray objectAtIndex:activePlayerEnum];
    int firstPlayerEnum = para1.atonRoundResult.firstPlayerEnum;
  //  AtonGameManager *gameManager  = para1.gameManager;
   // int secondPlayerEnum = para1.atonRoundResult.secondPlayerEnum;
    // TODO: should not enable interaction here
    
    NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
    int arrayNum = [eligibleSlotArray count];
    if ([eligibleSlotArray count] == 0) {
        [TempleUtility disableAllTempleSlotInteraction:templeArray];
        NSString *msg = @"|No Available Space\n to Place Peep\n";

        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            gameManager.messagePlayerEnum = firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para1.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            gameManager.messagePlayerEnum = para1.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para1.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
            
    } else if (arrayNum <= activePlayerPlaceNum) {

        int occupiedEnum = OCCUPIED_RED;
        if (activePlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
        }
        for (int i=0; i < [eligibleSlotArray count]; i++) {
            TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
            [selectedSlot placePeep:occupiedEnum];
        }
        [TempleUtility disableAllTempleSlotInteraction:[para1 templeArray]];
            
        NSString *msg = @"|All Eligible Spaces\n Filled With Peeps\n";
        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            gameManager.messagePlayerEnum = para1.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para1.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            gameManager.messagePlayerEnum = para1.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para1.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
    } else {
        [TempleUtility enableActiveTemplesFlame:para1.templeArray:activePlayerEnum:activePlayerMaxTempleEnum];
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            double animationTime = [ai placePeeps:activePlayerEnum:activePlayerPlaceNum:activePlayerMaxTempleEnum];
                
            // to remove the slot black boundary and flame
            [self performSelector:@selector(disableTempleSlotForInteractionAndFlame) withObject:nil afterDelay:animationTime];
                
            if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
                gameManager.messagePlayerEnum = para1.atonRoundResult.secondPlayerEnum;
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:(animationTime + AFTER_PEEP_DELAY_TIME)];
                    
            } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
                [self performSelector:@selector(checkRoundEnd) withObject:nil afterDelay:(animationTime + MESSAGE_DELAY_TIME)];
                    
            } else {
                // code should never reach here.
                NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
            }
                
        } else {
             [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
            [activePlayer displayMenu:ACTION_PLACE:activePlayerPlaceNum];
        }
            
    }
    
}


-(void) disableTempleSlotForInteractionAndFlame {
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para1 templeArray]];
}

-(void) disableActiveTemplesFlame {
    [TempleUtility disableTemplesFlame:[para1 templeArray]];
}

-(void) checkRoundEnd {
    
  //  [self disableTempleSlotForInteractionAndFlame];
    if ([self gameOverConditionSuper] != nil) {
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para1 templeArray]]) {
        //   [TempleUtility clearDeathTemple:[para templeArray]];
        para1.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para1 templeArray]];
        
        para1.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Death Temple Full\n Scoring Phase Begin" afterDelay: AFTER_PEEP_DELAY_TIME];
        //[self run];
    } else {
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }
    
}


@end
