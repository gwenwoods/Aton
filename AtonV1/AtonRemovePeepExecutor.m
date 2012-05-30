//
//  AtonRemovePeepExecutor.m
//  AtonV1
//
//  Created by Wen Lin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonRemovePeepExecutor.h"

@implementation AtonRemovePeepExecutor

static double AFTER_PEEP_DELAY_TIME = 2.0;
static float MESSAGE_DELAY_TIME = 0.2;

-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para = atonParameter;
        gameManager = atonGameManager;
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
    
    int activePlayerEnum = roundResult.firstPlayerEnum;
    int activePlayerMaxTempleEnum = roundResult.firstTemple;
    int activePlayerRemoveNum = roundResult.firstRemoveNum;
    int targetPlayerEnum = [roundResult getFirstRemoveTargetEnum];
    int targetPositiveRemoveNum = [roundResult getFirstRemovePositiveNum];
    
    if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        activePlayerEnum = roundResult.secondPlayerEnum;
        activePlayerMaxTempleEnum = roundResult.secondTemple;
        activePlayerRemoveNum = roundResult.secondRemoveNum;
        targetPlayerEnum = [roundResult getSecondRemoveTargetEnum];
        targetPositiveRemoveNum = [roundResult getSecondRemovePositiveNum];
    }
    
    AtonPlayer *activePlayer = [playerArray objectAtIndex:activePlayerEnum];

    //AtonPlayer *firstPlayer = [playerArray objectAtIndex:roundResult.firstPlayerEnum];
    
    
    
    if (activePlayerRemoveNum == 0) {
        
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }


    }
        
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
        
    NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:activePlayerMaxTempleEnum:occupiedEnum];
    int arrayNum = [eligibleSlotArray count];
        
    if ([eligibleSlotArray count] == 0) {
        //[TempleUtility disableAllTempleSlotInteraction:templeArray];
        NSString *msg = @"|No Available Peeps\n to Remove\n";
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }


            
    } else if (arrayNum < targetPositiveRemoveNum) {
        [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray:para.audioToDeath];
        NSString *msg = @"|All Eligible\n Peeps Removed\n";
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }

        

    } else if (arrayNum == targetPositiveRemoveNum) {
        [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray:para.audioToDeath];
      //  NSString *msg = @"|All Eligible\n Peeps Removed\n";
       if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
           
           [TempleUtility disableTemplesFlame:[para templeArray]];
           
           NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
           gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
           [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
          //  gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
          //  [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
          //  para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            [TempleUtility disableTemplesFlame:[para templeArray]];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
          //  gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
          //  [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
          //  para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }
        
        
        
    } else {
        [TempleUtility enableActiveTemplesFlame:para.templeArray:activePlayerEnum:activePlayerMaxTempleEnum];
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            [ai removePeepsToDeathTemple:targetPlayerEnum:activePlayerRemoveNum:activePlayerMaxTempleEnum];
            if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
                gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
                
            } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
                gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
                
            } else {
                // code should never reach here.
                NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
            }


        } else {
           // NSMutableArray *eligibleSlotArray =
           // [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: occupiedEnum];
             [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: occupiedEnum];
            [activePlayer displayMenu:ACTION_REMOVE:activePlayerRemoveNum];
        }
            
    } 
}
@end
