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
    
    // TODO: should not enable interaction here
    
    NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
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
        [TempleUtility enableActiveTemplesFlame:para.templeArray:activePlayerEnum:activePlayerMaxTempleEnum];
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            double animationTime = [ai placePeeps:activePlayerEnum:activePlayerPlaceNum:activePlayerMaxTempleEnum];
                
            // to remove the slot black boundary and flame
            [self performSelector:@selector(disableTempleSlotForInteractionAndFlame) withObject:nil afterDelay:animationTime];
                
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
            NSMutableArray *eligibleInteractionSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
            [activePlayer displayMenu:ACTION_PLACE:activePlayerPlaceNum];
        }
            
    }
    
}


-(void) disableTempleSlotForInteractionAndFlame {
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
}

-(void) disableActiveTemplesFlame {
    [TempleUtility disableTemplesFlame:[para templeArray]];
}

-(void) checkRoundEnd {
    
    [self disableTempleSlotForInteractionAndFlame];
    if ([self gameOverConditionSuper] != nil) {
        [para.gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:0.0];
        
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


@end
