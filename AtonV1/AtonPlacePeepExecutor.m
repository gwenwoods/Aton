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
static float AUTO_ADVANCE_WAITING_TIME = 2.0;


-(id)initWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self = [super init]) {
        para = atonParameter;
        gameManager = atonGameManager;
        messageMaster = atonMessageMaster;
        useAI = atonParameter.useAI;
        ai = atonAI;
    }
    return self;
}


-(void) placePeep:(int) gamePhaseEnum {    
    
    NSLog(@"in place peep");
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
    
    NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
    int arrayNum = [eligibleSlotArray count];
    if ([eligibleSlotArray count] == 0) {
        NSLog(@"in place peep - A");
        [TempleUtility disableAllTempleSlotInteraction:templeArray];
        NSString *msg = [messageMaster getMessageForEnum:MSG_NO_SQUARE_TO_PLACE];

        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            gameManager.messagePlayerEnum = roundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            if(para.localPlayerEnum != para.atonRoundResult.firstPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay: MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            gameManager.messagePlayerEnum = roundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay: MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
            
    } else if (arrayNum <= activePlayerPlaceNum) {
        NSLog(@"in place peep - B");
        int occupiedEnum = OCCUPIED_RED;
        if (activePlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
        }
        for (int i=0; i < [eligibleSlotArray count]; i++) {
            TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
            [selectedSlot placePeep:occupiedEnum];
        }
        [TempleUtility disableAllTempleSlotInteraction:templeArray];
            
        NSString *msg = [messageMaster getMessageForEnum:MSG_ALL_SQUARE_FILLED];
        if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            gameManager.messagePlayerEnum = roundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_NONE;
            if(para.localPlayerEnum != para.atonRoundResult.firstPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay: MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            gameManager.messagePlayerEnum = roundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_NONE;
            if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay: MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
        }
    } else {
        NSLog(@"in place peep -- C");
        [TempleUtility enableActiveTemplesFlame:templeArray:activePlayerEnum:activePlayerMaxTempleEnum];
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            double animationTime = [ai placePeeps:activePlayerEnum:activePlayerPlaceNum:activePlayerMaxTempleEnum];
                
            // to remove the slot black boundary and flame
            [self performSelector:@selector(disableTempleSlotForInteractionAndFlame) withObject:nil afterDelay:animationTime];
                
            if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
                NSLog(@"in place peep -- C1");
                gameManager.messagePlayerEnum = roundResult.secondPlayerEnum;
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:(animationTime + AFTER_PEEP_DELAY_TIME)];
                    
            } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
                [self performSelector:@selector(checkRoundEnd) withObject:nil afterDelay:(animationTime + MESSAGE_DELAY_TIME)];
                NSLog(@"in place peep -- C2");
            } else {
                // code should never reach here.
                NSLog(@"AtonPlacePeepEngine:placePeep -> useAI");
            }
                
        } else {
            if (para.onlineMode && para.onlinePara.localPlayerEnum != activePlayerEnum) {
                //para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_PLACE;
                if (para.placePeepData != nil) {
                    NSLog(@"in place peep -- D1");
                    if (para.placePeepData.gamePhaseEnum.intValue == GAME_PHASE_FIRST_PLACE_PEEP) {
                        NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.placePeepData.liteSlotArray];
                        [self performSelector:@selector(remotePlacePeeps1:) withObject:allSelectedSlots afterDelay:MESSAGE_DELAY_TIME*2];
                        
                        
                    } else if(para.placePeepData.gamePhaseEnum.intValue == GAME_PHASE_SECOND_PLACE_PEEP) {
                         NSLog(@"in place peep -- D2");
                        NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.placePeepData.liteSlotArray];
                        [self performSelector:@selector(remotePlacePeeps2:) withObject:allSelectedSlots afterDelay:MESSAGE_DELAY_TIME*2];
                        
                    }
                } else {
                    para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_PLACE;
                }
                return;

            } 
            [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: OCCUPIED_EMPTY];
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
    
    if ([gameManager gameOverConditionSuper] != nil) {
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_DEAD_KINGDOM_FULL] afterDelay: AFTER_PEEP_DELAY_TIME];
        
    } else {
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_TURN_END] afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }
}

-(void) remotePlacePeeps1:(NSMutableArray*) allSelectedSlots {

    int occupiedEnum = OCCUPIED_RED;
    if (para.atonRoundResult.firstPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        [selectedSlot placePeep:occupiedEnum];
    }
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
    if ([gameManager gameOverConditionSuper] != nil) {
        // TODO: Q? do we need this if ?
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else {
        NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
        gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        
        if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_PEEP;
            NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
            [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay: MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
        }
    }
    para.placePeepData = nil;
}

-(void) remotePlacePeeps2:(NSMutableArray*) allSelectedSlots {

    para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_PEEP;
    
    int occupiedEnum = OCCUPIED_RED;
    if (para.atonRoundResult.secondPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        [selectedSlot placePeep:occupiedEnum];
    }
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
    
    if ([gameManager gameOverConditionSuper] != nil) {
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_DEAD_KINGDOM_FULL] afterDelay:AFTER_PEEP_DELAY_TIME];
    } else {
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_TURN_END] afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }
    para.placePeepData = nil;
}

-(void) autoAdvanceGameEnum:(NSNumber*) startGamePhaseEnum {
    NSLog(@"in auto advance - place");
    if(startGamePhaseEnum.intValue == GAME_PHASE_FIRST_PLACE_NONE ) {
        // BRANCH PHASE
        NSLog(@"call engine run 1 - place");
        gameManager.gamePhaseView.hidden = YES;
        [executorDelegate engineRun];
    } else if(startGamePhaseEnum.intValue == GAME_PHASE_SECOND_PLACE_NONE ) {
        // BRANCH PHASE
        NSLog(@"call engine run 2 - place");
        gameManager.gamePhaseView.hidden = YES;
        [executorDelegate engineRun];
    } else if(startGamePhaseEnum.intValue == GAME_PHASE_FIRST_PLACE_PEEP) {
        para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_PEEP;
        gameManager.gamePhaseView.hidden = YES;
        [executorDelegate engineRun];
    }
}
@end
