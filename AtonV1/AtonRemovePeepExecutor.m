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
static float AUTO_ADVANCE_WAITING_TIME = 2.0;


-(id)initWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
    if (self = [super init]) {
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
    

    if (activePlayerRemoveNum == 0) {
        
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            if(para.onlineMode && para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
            return;
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            if(para.onlineMode && para.localPlayerEnum != para.atonRoundResult.firstPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
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
        NSString *msg = [messageMaster getMessageForEnum:MSG_NO_PEEP_TO_REMOVE];
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            if(para.onlineMode && para.localPlayerEnum != activePlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
            if(para.onlineMode && para.localPlayerEnum != activePlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }


            
    } else if (arrayNum < targetPositiveRemoveNum) {
        [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray:para.audioToDeath];
        NSString *msg = [messageMaster getMessageForEnum:MSG_ALL_PEEPS_REMOVED];
        if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
            if(para.onlineMode && para.localPlayerEnum != activePlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
            if(para.onlineMode && para.localPlayerEnum != activePlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }

        

    } else if (arrayNum == targetPositiveRemoveNum) {
        double animationTime = [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray:para.audioToDeath];
      //  NSString *msg = @"|All Eligible\n Peeps Removed\n";
       if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
           //[TempleUtility disableTemplesFlame:[para templeArray]];
           NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
           gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
           [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime + MESSAGE_DELAY_TIME];
           if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
               NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
               [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:animationTime + MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
           }
        
        } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            //[TempleUtility disableTemplesFlame:[para templeArray]];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime + MESSAGE_DELAY_TIME];
            if(para.localPlayerEnum != para.atonRoundResult.firstPlayerEnum) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:animationTime + MESSAGE_DELAY_TIME + AUTO_ADVANCE_WAITING_TIME];
            }
            
        } else {
            // code should never reach here.
            NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
        }
        
        
        
    } else {
        
        [TempleUtility enableActiveTemplesFlame:para.templeArray:activePlayerEnum:activePlayerMaxTempleEnum];
        
        if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
            double animationTime = [ai removePeepsToDeathTemple:targetPlayerEnum:activePlayerRemoveNum:activePlayerMaxTempleEnum];
            if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
                gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime + MESSAGE_DELAY_TIME];
                
            } else if (gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
                NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
                gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime + MESSAGE_DELAY_TIME];
                
            } else {
                // code should never reach here.
                NSLog(@"AtonPlacePeepEngine:removePeep -> useAI");
            }


        } else {
            if (para.onlineMode && para.onlinePara.localPlayerEnum != activePlayerEnum) {
                NSLog(@"remove - D");
              //  para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_REMOVE;
                if (para.removePeepData != nil) {
                     NSLog(@"remove - E");
                    if (para.removePeepData.gamePhaseEnum.intValue == GAME_PHASE_FIRST_REMOVE_PEEP) {
                         NSLog(@"remove - F");
                        NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.removePeepData.liteSlotArray];
                        [self performSelector:@selector(remoteRemovePeeps1:) withObject:allSelectedSlots afterDelay:2.0];
                        para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_PEEP;
                     /*   if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
                            NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                            [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
                        }*/
                        
                    } else if(para.removePeepData.gamePhaseEnum.intValue == GAME_PHASE_SECOND_REMOVE_PEEP) {
                         NSLog(@"remove - G");
                        NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.removePeepData.liteSlotArray];
                        [self performSelector:@selector(remoteRemovePeeps2:) withObject:allSelectedSlots afterDelay:2.0];
                        para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_PEEP;
                    /*    if(para.localPlayerEnum != para.atonRoundResult.secondPlayerEnum) {
                            NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                            [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
                        }*/
                    }
                } else {
                    para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_REMOVE;
                }
                
                return;

            }
            [TempleUtility enableEligibleTempleSlotInteraction:templeArray:activePlayerMaxTempleEnum: occupiedEnum];
            [activePlayer displayMenu:ACTION_REMOVE:activePlayerRemoveNum];
        }
    } 
}

-(void) removeOneFromEachTemple:(int) gamePhaseEnum {
    
    NSMutableArray *templeArray = para.templeArray;
    NSMutableArray *playerArray = para.playerArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    int activePlayerEnum = roundResult.higherScorePlayer;
    if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        activePlayerEnum = roundResult.lowerScorePlayer;
    }
    
    [TempleUtility enableActiveTemplesFlame:para.templeArray:activePlayerEnum:4];
    if (useAI == YES && activePlayerEnum == PLAYER_BLUE) {
        double animationTime = [ai removeOnePeepFromEachTemple:activePlayerEnum];
        
        if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
            gameManager.messagePlayerEnum = roundResult.lowerScorePlayer;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay: animationTime + MESSAGE_DELAY_TIME];
        } else {            
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN] afterDelay:animationTime + MESSAGE_DELAY_TIME];
        }
        
    } else {
        
        int targetPlayerEnum = activePlayerEnum;
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }
        
        [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];
        NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray :TEMPLE_4:occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        
        if (arrayNum == 0) {
            gameManager.messagePlayerEnum = activePlayerEnum;
            NSString *msg = [messageMaster getMessageForEnum:MSG_NO_PEEP_TO_REMOVE];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            
            para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
            if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
            }
            
        } else if (arrayNum <= 4) {
            // TODO: add animation and black edge slot here
            [TempleUtility removePeepsToSupply:templeArray:eligibleSlotArray];
            
            gameManager.messagePlayerEnum = activePlayerEnum;
            NSString *msg = [messageMaster getMessageForEnum:MSG_ALL_PEEPS_REMOVED];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            
            para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
            if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
               para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
            }
            
        } else {
            
            if (para.onlineMode && para.onlinePara.localPlayerEnum != activePlayerEnum) {
                para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_REMOVE_4;
                if (para.firstRemove4Data != nil && para.firstRemove4Data.gamePhaseEnum.intValue == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
                    NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.firstRemove4Data.liteSlotArray];
                    [self performSelector:@selector(remoteFirstRemove4:) withObject:allSelectedSlots afterDelay:2.0];
                    para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4;
                        
                } else if(para.secondRemove4Data != nil && para.secondRemove4Data.gamePhaseEnum.intValue == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
                        NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:para.secondRemove4Data.liteSlotArray];
                    [self performSelector:@selector(remoteSecondRemove4:) withObject:allSelectedSlots afterDelay:2.0];
                    para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4;

                    
                }

                return;
            }
            
            [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
            [[playerArray objectAtIndex:activePlayerEnum] displayMenu:ACTION_REMOVE:-4];
        }
    }
}

-(void) remoteRemovePeeps1:(NSMutableArray*) allSelectedSlots {
    NSLog(@"in remove peep 1");
    [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    
    NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
    gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
    [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.removePeepData = nil;
    
}

-(void) remoteRemovePeeps2:(NSMutableArray*) allSelectedSlots {

    NSLog(@"in remove peep 2");
    [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    
    NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
    gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
    [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.removePeepData = nil;
}


-(void) remoteFirstRemove4:(NSMutableArray*) allSelectedSlots {
    
    [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
    
    [TempleUtility disableTemplesFlame:[para templeArray]];
    gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
    NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
    [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.firstRemove4Data = nil;
}

-(void) remoteSecondRemove4:(NSMutableArray*) allSelectedSlots {
    
    [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    gameManager.messagePlayerEnum = PLAYER_NONE;
    [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN] afterDelay:AFTER_PEEP_DELAY_TIME];
    para.secondRemove4Data = nil;
    
}

-(void) autoAdvanceGameEnum:(NSNumber*) startGamePhaseEnum {
    NSLog(@"in auto advance - remove");
    if(startGamePhaseEnum.intValue == GAME_PHASE_FIRST_REMOVE_NONE ) {
        if (para.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_NONE ) {
            // BRANCH PHASE
            NSLog(@"call engine run 1");
            gameManager.gamePhaseView.hidden = YES;
            [executorDelegate engineRun];
        }
       
    } else if(startGamePhaseEnum.intValue == GAME_PHASE_SECOND_REMOVE_NONE ) {
        if (para.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_NONE ) {
            // BRANCH PHASE
            NSLog(@"call engine run 2");
            gameManager.gamePhaseView.hidden = YES;
            [executorDelegate engineRun];
        }
       
    } else if(startGamePhaseEnum.intValue == GAME_PHASE_FIRST_REMOVE_PEEP ) {
        if (para.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP ) {
            // BRANCH PHASE
            NSLog(@"call engine run 3");
            gameManager.gamePhaseView.hidden = YES;
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_PEEP;
            [executorDelegate engineRun];
        }
        
    } else if(startGamePhaseEnum.intValue == GAME_PHASE_SECOND_REMOVE_PEEP ) {
        if (para.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP ) {
            // BRANCH PHASE
            NSLog(@"call engine run 4");
            gameManager.gamePhaseView.hidden = YES;
            para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_PEEP;
            [executorDelegate engineRun];
        }
        
    }
}
@end
