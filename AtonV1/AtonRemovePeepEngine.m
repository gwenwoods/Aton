//
//  AtonRemovePeepEngine.m
//  AtonV1
//
//  Created by Wen Lin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonRemovePeepEngine.h"

@implementation AtonRemovePeepEngine

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

-(void) removePeep:(int) gamePhaseEnum {
    
    NSMutableArray *templeArray = para.templeArray;
    NSMutableArray *playerArray = para.playerArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    AtonPlayer *firstPlayer = [playerArray objectAtIndex:roundResult.firstPlayerEnum];
    
    if (useAI == YES && roundResult.firstPlayerEnum == PLAYER_BLUE) {
        [ai removePeepsToDeathTemple:[para.atonRoundResult getFirstRemoveTargetEnum]:[roundResult getFirstRemovePositiveNum]:roundResult.firstTemple];
        NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
        para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    } else {
        [TempleUtility changeSlotBoundaryColor:para.templeArray:roundResult.firstPlayerEnum];
        if (para.atonRoundResult.firstRemoveNum == 0) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            para.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
        }
        
        int targetPlayerEnum = [para.atonRoundResult getFirstRemoveTargetEnum];
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }
        
        NSMutableArray *eligibleSlotArray =
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray:roundResult.firstTemple: occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"|No Available Peeps\n to Remove\n";
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            
        } else if (arrayNum <= [para.atonRoundResult getFirstRemovePositiveNum]) {
            [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray:para.audioToDeath];
            NSString *msg = @"|All Eligible\n Peeps Removed\n";
            para.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
        } else {
            [firstPlayer displayMenu:ACTION_REMOVE:roundResult.firstRemoveNum];
        } 
    }
}
@end
