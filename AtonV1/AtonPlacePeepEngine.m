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

}

-(void) placePeep1:(int) gamePhaseEnum {    
    
    NSMutableArray *templeArray = para.templeArray;
    NSMutableArray *playerArray = para.playerArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    int activePlayerEnum = roundResult.secondPlayerEnum;
    int activePlayerMaxTempleEnum = roundResult.secondTemple;
    AtonPlayer *activePlayer = [playerArray objectAtIndex:activePlayerEnum];
    AtonPlayer *secondPlayer = [playerArray objectAtIndex:roundResult.secondPlayerEnum];
    
    if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
        double animationTime = [ai placePeeps:activePlayerEnum:roundResult.secondPlaceNum:roundResult.secondTemple];

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
        [TempleUtility changeSlotBoundaryColor:para.templeArray:activePlayerEnum];
        NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:para.atonRoundResult.secondTemple: OCCUPIED_EMPTY];
        int arrayNum = [eligibleSlotArray count];
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"|No Available Space\n to Place Peep\n";
            // NOTE: different here
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            
        } else if (arrayNum <= para.atonRoundResult.secondPlaceNum) {
            // [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray];
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
            para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
        } else {
            [activePlayer displayMenu:ACTION_PLACE:activePlayerEnum];
            
        }
    }
}

-(void) disableTempleSlotForInteraction {
    [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
}
@end
