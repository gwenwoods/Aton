//
//  AtonGameEngine.m
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameEngine.h"

@implementation AtonGameEngine

static float MESSAGE_DELAY_TIME = 0.5;
static float ANIMATION_DELAY_TIME = 0.2;
static float SCARAB_MOVING_TIME = 0.5;
static int AFTER_PEEP_DELAY_TIME = 2.0;
static float AUTO_ADVANCE_WAITING_TIME = 2.0;

@synthesize para;
@synthesize gameManager, messageMaster;
@synthesize useAI;

static NSString *CARD_1_RESULT = @"Cartouche 1 Result|";
static NSString *SCORING_PHASE_END = @"Scoring Phase Ends";

-(id)initializeWithParameters:(AtonGameParameters*) parameter:(UIViewController*) controller:(AVAudioPlayer*) atonAudioPlayGame:(AVAudioPlayer*) atonAudioChime {
	if (self) {
        para = parameter;
        gameManager = [[AtonGameManager alloc] initializeWithParameters:para:controller:atonAudioPlayGame:atonAudioChime];
        messageMaster = [[AtonMessageMaster alloc] initializeWithParameters:para];
        useAI = para.useAI;
        ai = [[AtonAIEasy alloc] initializeWithParameters:para];
        placePeepEngine = [[AtonPlacePeepExecutor alloc] initializeWithParameters:para:gameManager:messageMaster:ai];
        removePeepEngine = [[AtonRemovePeepExecutor alloc] initWithParameters:para:gameManager:messageMaster:ai];
        removePeepEngine.executorDelegate = self;
        arrangeCardExecutor = [[AtonArrangeCardsExecutor alloc] initializeWithParameters:para:gameManager:messageMaster:ai];
    }
    return self;
}


-(void) run {
    
    int gamePhaseEnum = para.gamePhaseEnum;
    NSMutableArray *playerArray = para.playerArray;
   // NSMutableArray *templeArray = para.templeArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    AtonPlayer *playerRed = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *playerBlue = [playerArray objectAtIndex:PLAYER_BLUE];
    
    AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
    
    int localPlayerEnum = para.localPlayerEnum;
    BOOL onlineMode = para.onlineMode;

    if (gamePhaseEnum == GAME_PHASE_DISTRIBUTE_CARD) {

        for (int i=0; i< [playerArray count]; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player resetCard];
            [player distributeCards];
        }
        
        if (onlineMode) {
            if (localPlayerEnum == PLAYER_RED) {
                NSString *msg = @"|";
                msg = [msg stringByAppendingString:playerRed.playerName];
                msg = [msg stringByAppendingString:[messageMaster getMessageForEnum:MSG_PLAYER_ARRANGE_CARD]];
                gameManager.messagePlayerEnum = PLAYER_RED;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:3.0];
            } else {
                NSString *msg = @"|";
                msg = [msg stringByAppendingString:playerBlue.playerName];
                msg = [msg stringByAppendingString:[messageMaster getMessageForEnum:MSG_PLAYER_ARRANGE_CARD]];
                gameManager.messagePlayerEnum = PLAYER_BLUE;
                para.gamePhaseEnum = GAME_PHASE_RED_CLOSE_CARD;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:3.0];
                
            }
        } else {
            NSString *msg = @"|";
            msg = [msg stringByAppendingString:playerRed.playerName];
            msg = [msg stringByAppendingString:[messageMaster getMessageForEnum:MSG_PLAYER_ARRANGE_CARD]];
            gameManager.messagePlayerEnum = PLAYER_RED;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:3.0];
        }
            
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        [playerRed openCardsForArrange];   

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        [playerRed closeCards]; 
        
        if (onlineMode) {
            gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
        } else if (useAI == YES) {
            int* newCardArray = malloc(sizeof(int)*4);
            newCardArray = [playerBlue getCardNumberArray];
            double animationTime = 0.0;
            if ((newCardArray[0] + newCardArray[1] + newCardArray[2] + newCardArray[3]) <= 6) {
                if(playerBlue.exchangeCardsButton.hidden == NO) {
                   playerBlue.scrollExchangeIV.image = [UIImage imageNamed:@"scrollDown_blank.png"];
                   [playerBlue resetCard];
                   [playerBlue distributeCards];
                   animationTime = 3.0;
                    playerBlue.exchangeCardsButton.hidden = YES;
                }
            }
            newCardArray = [arrangeCardExecutor arrangeCard:[playerBlue getCardNumberArray]];
            [playerBlue setCardNumberArray:newCardArray];
            para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0 + animationTime];
        } else {
            NSString *msg = @"|";
            msg = [msg stringByAppendingString:playerBlue.playerName];
            msg = [msg stringByAppendingString:[messageMaster getMessageForEnum:MSG_PLAYER_ARRANGE_CARD]];
            gameManager.messagePlayerEnum = PLAYER_BLUE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        }
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        [playerBlue openCardsForArrange];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
        [playerBlue closeCards];
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_COMPARE) {
        for (int i=0; i<2; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player openCards];
        }

        roundResult = [self computeRoundResult:playerArray:roundResult];
        NSString* msg = CARD_1_RESULT;
        int cardOneWinnerEnum = roundResult.cardOneWinnerEnum;
        
        if (cardOneWinnerEnum == PLAYER_NONE) {
            msg = [msg stringByAppendingString:[messageMaster getMessageForEnum:MSG_TIE]];
            
        } else {
            AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
            NSString* cardOneWinnerName = [cardOneWinner playerName];
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            msg = [msg stringByAppendingString:cardOneWinnerName];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n\n Wins %i points\n\n", cardOneWinningScore]];
            
        }
        gameManager.messagePlayerEnum = cardOneWinnerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {

        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        
        int winnerOriginalScore = 0;
        int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
        if (cardOneWinnerEnum != PLAYER_NONE) {
            winnerOriginalScore = [[playerArray objectAtIndex:cardOneWinnerEnum] getScore];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
            [invocation setArgument:&cardOneWinnerEnum atIndex:2];
            [invocation setArgument:&cardOneWinningScore atIndex:3];
            
            [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DELAY_TIME invocation:invocation repeats:NO];
        }
        float animationTime = cardOneWinningScore * SCARAB_MOVING_TIME + ANIMATION_DELAY_TIME;
        
        int winnerFinalScore = winnerOriginalScore + cardOneWinningScore;
        if (winnerFinalScore >= 40) {
          
            [self performSelector:@selector(showFinalResult) withObject:nil afterDelay:animationTime + ANIMATION_DELAY_TIME];
        } else {
            NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
            if(localPlayerEnum != para.atonRoundResult.firstPlayerEnum) {
                NSLog(@"In compare result");
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:animationTime + AUTO_ADVANCE_WAITING_TIME];
            }
        }

        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        [removePeepEngine removePeep:GAME_PHASE_FIRST_REMOVE_PEEP];
       
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        [removePeepEngine removePeep:GAME_PHASE_SECOND_REMOVE_PEEP];
                    
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [placePeepEngine placePeep: GAME_PHASE_FIRST_PLACE_PEEP];
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [placePeepEngine placePeep: GAME_PHASE_SECOND_PLACE_PEEP];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING) {
        [TempleUtility clearDeathTemple:[para templeArray]];
        TempleScoreResult *result_t1 = [roundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_1];
        NSString *msg = [messageMaster getMessageForTempleScoreResult:result_t1];
        gameManager.messagePlayerEnum = result_t1.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
    } 

    else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION) {
        TempleScoreResult *result_t1 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_1];
        float animationTime = [self templeScoreAnimation:result_t1];

        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_2];
        NSString *msg = [messageMaster getMessageForTempleScoreResult:result_t2];
        gameManager.messagePlayerEnum = result_t2.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION) {
        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_2];
        float animationTime = [self templeScoreAnimation:result_t2];
        
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_3];
         NSString *msg = [messageMaster getMessageForTempleScoreResult:result_t3];
        gameManager.messagePlayerEnum = result_t3.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION) {
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_3];
        float animationTime = [self templeScoreAnimation:result_t3];
        
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_4];
         NSString *msg = [messageMaster getMessageForTempleScoreResult:result_t4];
        gameManager.messagePlayerEnum = result_t4.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION) {
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_4];
        float animationTime = [self templeScoreAnimation:result_t4];

        TempleScoreResult *result_greyBonus = [roundResult.templeScoreResultArray objectAtIndex:SCORE_GREY_BONUS];
        NSString *msg = [messageMaster getMessageForTempleScoreResult:result_greyBonus];
        gameManager.messagePlayerEnum = result_greyBonus.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION) {
        TempleScoreResult *result_greyBonus = [roundResult.templeScoreResultArray objectAtIndex:SCORE_GREY_BONUS];
        float animationTime = [self templeScoreAnimation:result_greyBonus];
        
        TempleScoreResult *result_orangeBonusForRed = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
       // NSString *msg = [messageMaster getMessageForTempleScoreResult:result_orangeBonusForRed];
        gameManager.messagePlayerEnum = result_orangeBonusForRed.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForTempleScoreResult:result_orangeBonusForRed] afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION) {
        TempleScoreResult *result_orangeBonusForRed = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForRed];
        
        TempleScoreResult *result_orangeBonusForBlue = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        NSString *msg = [messageMaster getMessageForTempleScoreResult:result_orangeBonusForBlue];
        gameManager.messagePlayerEnum = result_orangeBonusForBlue.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION) {
        TempleScoreResult *result_orangeBonusForBlue = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForBlue];
        NSString *msg = SCORING_PHASE_END;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    }  else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING_END) {

        if ([gameManager gameOverConditionSuper] != nil) {
            [gameManager performSelector:@selector(showFinalResultView:) withObject:[gameManager gameOverConditionSuper] afterDelay:MESSAGE_DELAY_TIME];
            
        } else {
            
            int higherScorePlayer = PLAYER_RED;
            
            roundResult.higherScorePlayer = PLAYER_RED;
            roundResult.lowerScorePlayer = PLAYER_BLUE;
            if([bluePlayer getScore] > [redPlayer getScore]) {
                higherScorePlayer = PLAYER_BLUE;
                roundResult.lowerScorePlayer = PLAYER_RED;
                roundResult.higherScorePlayer = PLAYER_BLUE;
               // Add Tie case - random decide
            } else if ([bluePlayer getScore] == [redPlayer getScore]) {
                int randomFirst = rand()%2;
                int randomSecond = (randomFirst + 1)%2;
                roundResult.higherScorePlayer = randomFirst;
                roundResult.lowerScorePlayer = randomSecond;
            }
            
            gameManager.messagePlayerEnum = roundResult.higherScorePlayer;
            NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        }
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
         [removePeepEngine removeOneFromEachTemple:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
 /*       [TempleUtility enableActiveTemplesFlame:para.templeArray:roundResult.higherScorePlayer:4];
        if (useAI == YES && roundResult.higherScorePlayer == PLAYER_BLUE) {
            double animationTime = [ai removeOnePeepFromEachTemple:roundResult.higherScorePlayer];
            
            gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay: animationTime + AFTER_PEEP_DELAY_TIME];
        } else {
            
            int targetPlayerEnum = [roundResult higherScorePlayer];
            int occupiedEnum = OCCUPIED_RED;
            if (targetPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }

            [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];
            NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray :TEMPLE_4:occupiedEnum];
            int arrayNum = [eligibleSlotArray count];
            if (arrayNum == 0) {
                gameManager.messagePlayerEnum = roundResult.higherScorePlayer;
                NSString *msg = [messageMaster getMessageForEnum:MSG_NO_PEEP_TO_REMOVE];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
                
            } else if (arrayNum <= 4) {
                [TempleUtility removePeepsToSupply:templeArray:eligibleSlotArray];
                gameManager.messagePlayerEnum = roundResult.higherScorePlayer;
                NSString *msg = [messageMaster getMessageForEnum:MSG_ALL_PEEPS_REMOVED];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
                
            } else {
                [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
                [[playerArray objectAtIndex:roundResult.higherScorePlayer] displayMenu:ACTION_REMOVE:-4];
            }
            
        }*/
        
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        [removePeepEngine removeOneFromEachTemple:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
   /*     [TempleUtility enableActiveTemplesFlame:para.templeArray:roundResult.lowerScorePlayer:4];
        if (useAI == YES && roundResult.lowerScorePlayer == PLAYER_BLUE) {
            double animationTime = [ai removeOnePeepFromEachTemple:roundResult.lowerScorePlayer];
            
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN] afterDelay:animationTime + AFTER_PEEP_DELAY_TIME];
        } else {
            int maxTemple = roundResult.firstTemple;
            if (roundResult.lowerScorePlayer == roundResult.secondPlayerEnum) {
                maxTemple = roundResult.secondTemple;
            }
            int targetPlayerEnum = [para.atonRoundResult lowerScorePlayer];
            int occupiedEnum = OCCUPIED_RED;
            if (targetPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }

            [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];

            NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:TEMPLE_4: occupiedEnum];
            int arrayNum = [eligibleSlotArray count];
            if (arrayNum == 0) {
                gameManager.messagePlayerEnum = roundResult.lowerScorePlayer;
                NSString *msg = [messageMaster getMessageForEnum:MSG_NO_PEEP_TO_REMOVE];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
                
            } else if (arrayNum <= 4) {
                [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];
                gameManager.messagePlayerEnum = roundResult.lowerScorePlayer;
                NSString *msg = [messageMaster getMessageForEnum:MSG_ALL_PEEPS_REMOVED];
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
                
            } else {
                [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
                [[playerArray objectAtIndex:roundResult.lowerScorePlayer] displayMenu:ACTION_REMOVE:-4];
            }
        } */

        
       
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
        gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_SECOND_REMOVE_PEEP;
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
        gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_FIRST_PLACE_PEEP;
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
        gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_PRE_SECOND_REMOVE_4;
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN];
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_DISTRIBUTE_CARD;
        
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
        gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_SECOND_PLACE_PEEP;
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_NONE) {
        // BRANCH PHASE
        // check death temple here:
        // if full -> scoring
        // if not -> distribute card
        [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
        if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
            //   [TempleUtility clearDeathTemple:[para templeArray]];
            para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
            
            para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_DEAD_KINGDOM_FULL] afterDelay:AFTER_PEEP_DELAY_TIME];
        } else {
            if ([gameManager gameOverConditionSuper] != nil) {
                // To see if any temple is filled by one player
                // which will cause the game to finish
                NSString *msg = [gameManager gameOverConditionSuper];
                [gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            } else {
                para.gamePhaseEnum = GAME_PHASE_PRE_DISTRIBUTE_CARD;
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_TURN_END] afterDelay:AFTER_PEEP_DELAY_TIME];
            }
        }
    }
}

-(AtonRoundResult*) computeRoundResult:(NSMutableArray*) playerArray:(AtonRoundResult*) result {
    int *redArray = [[playerArray objectAtIndex:PLAYER_RED] getCardNumberArray];
    int *blueArray = [[playerArray objectAtIndex:PLAYER_BLUE] getCardNumberArray];
    
    //----------------------------------------
    // compare card 1
    if (redArray[0] > blueArray[0]) {
        [result setCardOneWinnerEnum:PLAYER_RED];
        [result setCardOneWinningScore:(redArray[0]-blueArray[0])*2];
        
    } else if(blueArray[0] > redArray[0]) {
        [result setCardOneWinnerEnum:PLAYER_BLUE];
        [result setCardOneWinningScore:(blueArray[0]-redArray[0])*2];
        
    } else {
        [result setCardOneWinnerEnum:PLAYER_NONE];
        
    }
    
    //----------------------------------------
    // compare card 2
    if (redArray[1] < blueArray[1] ) {
        [result setFirstPlayerEnum:PLAYER_RED];
        [result setSecondPlayerEnum:PLAYER_BLUE];
    } else if(blueArray[1] < redArray[1]) {
        [result setFirstPlayerEnum:PLAYER_BLUE];
        [result setSecondPlayerEnum:PLAYER_RED];
    } else {
        if (redArray[0] < blueArray[0] ) {
            [result setFirstPlayerEnum:PLAYER_RED];
            [result setSecondPlayerEnum:PLAYER_BLUE];
        } else if (blueArray[0] < redArray[0]) {
            [result setFirstPlayerEnum:PLAYER_BLUE];
            [result setSecondPlayerEnum:PLAYER_RED];
        } else {
            
            if (para.onlineMode) {
                [result setFirstPlayerEnum:PLAYER_RED];
                [result setSecondPlayerEnum:PLAYER_BLUE];
            } else {
                int firstPlayerEnum = time(0)%2;
                [result setFirstPlayerEnum:firstPlayerEnum];
                int secondPlayerEnum = (firstPlayerEnum+1)%2;
                [result setSecondPlayerEnum:secondPlayerEnum];
            }
            
        }
    }

    if ([result firstPlayerEnum] == PLAYER_RED) {
        [result setFirstRemoveNum:(redArray[1]-2)];
        [result setFirstPlaceNum:redArray[3]];
        [result setFirstTemple:redArray[2]];
        [result setSecondRemoveNum:(blueArray[1]-2)];
        [result setSecondPlaceNum:blueArray[3]];
        [result setSecondTemple:blueArray[2]];
    } else {
        [result setFirstRemoveNum:(blueArray[1]-2)];
        [result setFirstPlaceNum:blueArray[3]];
        [result setFirstTemple:blueArray[2]];
        [result setSecondRemoveNum:(redArray[1]-2)];
        [result setSecondPlaceNum:redArray[3]];
        [result setSecondTemple:redArray[2]];
    }
    
    return result;
}


-(void) assignScoreToPlayer:(int) playerEnum withWinningScore:(int) winningScore {
    
    NSMutableArray *playerArray = para.playerArray;
    AtonPlayer *winningPlayer = [playerArray objectAtIndex:playerEnum];
    
    int oldScore = [winningPlayer getScore];
    int newScore = oldScore + winningScore;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)];
    [invocation setArgument:&playerEnum atIndex:2];
    [invocation setArgument:&newScore atIndex:3];
    
    if (oldScore < 15 && newScore > 15) {
        int cornerScore = 15;
        NSInvocation *invocation0 = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)]];
        [invocation0 setTarget:self];
        [invocation0 setSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)];
        [invocation0 setArgument:&playerEnum atIndex:2];
        [invocation0 setArgument:&cornerScore atIndex:3];

        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation0 repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:(15-oldScore)*SCARAB_MOVING_TIME + 0.05 invocation:invocation repeats:NO];
        
    } else if (oldScore < 26 && newScore > 26) {
        
        int cornerScore = 26;
        NSInvocation *invocation0 = [NSInvocation invocationWithMethodSignature:
                                     [self methodSignatureForSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)]];
        [invocation0 setTarget:self];
        [invocation0 setSelector:@selector(moveScoreForPlayerAnimation:withNewScore:)];
        [invocation0 setArgument:&playerEnum atIndex:2];
        [invocation0 setArgument:&cornerScore atIndex:3];
        
        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation0 repeats:NO];

        [NSTimer scheduledTimerWithTimeInterval:(26-oldScore)*SCARAB_MOVING_TIME + 0.05 invocation:invocation repeats:NO];
        
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation repeats:NO];

    }
}

-(void) moveScoreForPlayerAnimation:(int) playerEnum withNewScore:(int) newScore {
    
    NSMutableArray *playerArray = [para playerArray];
    NSMutableArray *scarabArray = [para scarabArray];
    AtonPlayer *cardOneWinner = [playerArray objectAtIndex:playerEnum];
    int oldScore = [cardOneWinner getScore];
    if (oldScore >= 41) {
        [cardOneWinner updateScore:newScore];
        return;
    }
    
    ScoreScarab *oldScarab = [scarabArray objectAtIndex:oldScore];
    ScoreScarab *newScarab = [scarabArray objectAtIndex:41];
    if (newScore < 41) {
        newScarab = [scarabArray objectAtIndex:newScore];
    }
    
    
    int moveNum = newScarab.scoreValue - oldScarab.scoreValue;
    // create animation IV
    UIImageView *animationIV = [[UIImageView alloc] init];
    if ([cardOneWinner playerEnum] == PLAYER_RED) {
        animationIV.frame = oldScarab.redFrame;
        animationIV.image = oldScarab.redIV.image;
        oldScarab.redIV.hidden = YES;
    } else {
        animationIV.frame = oldScarab.blueFrame;
        animationIV.image = oldScarab.blueIV.image;
        oldScarab.blueIV.hidden = YES;
    }
    [cardOneWinner.baseView addSubview:animationIV]; 
    
    [UIView animateWithDuration:SCARAB_MOVING_TIME * moveNum
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         if ([cardOneWinner playerEnum] == PLAYER_RED) {
                             animationIV.frame = newScarab.redFrame;
                         } else {
                             animationIV.frame = newScarab.blueFrame;
                         }
                     } 
                     completion:^(BOOL finished){
                         [animationIV removeFromSuperview];
                         if ([cardOneWinner playerEnum] == PLAYER_RED) {
                             newScarab.redIV.hidden = NO;
                             [newScarab.iv bringSubviewToFront:newScarab.redIV];
                         } else {
                             newScarab.blueIV.hidden = NO;
                             [newScarab.iv bringSubviewToFront:newScarab.blueIV];
                         }
                         [cardOneWinner updateScore:newScore];
                     }];
}

-(float) templeScoreAnimation:(TempleScoreResult*) result {
    
    int playerEnum = result.winningPlayerEnum;
    int winningScore = result.winningScore;
    float animationTime = 0.0;
    if (playerEnum != PLAYER_NONE && winningScore > 0) {
        
        AtonPlayer *player = [para.playerArray objectAtIndex:playerEnum];
        int playerOriginalScore = [player getScore];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
        [invocation setArgument:&playerEnum atIndex:2];
        [invocation setArgument:&winningScore atIndex:3];
        
        [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DELAY_TIME invocation:invocation repeats:NO];
        
        if (playerOriginalScore < 41) {
            animationTime = SCARAB_MOVING_TIME * winningScore + ANIMATION_DELAY_TIME;
        }
        
    }

    return animationTime;
}

-(void) checkRoundEnd {
    
    [self disableTempleSlotForInteraction];
    if ([gameManager gameOverConditionSuper] != nil) {
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        //   [TempleUtility clearDeathTemple:[para templeArray]];
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_DEAD_KINGDOM_FULL] afterDelay: AFTER_PEEP_DELAY_TIME];
        //[self run];
    } else {
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_TURN_END] afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }

}

-(void) disableTempleSlotForInteraction {
    [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
}
-(void) playerDoneAction {
    
    [TempleUtility disableAllTempleSlotInteraction:para.templeArray];
    NSMutableArray *playerArray = [para playerArray];
    
    AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
    AtonPlayer *firstPlayer = [playerArray objectAtIndex:para.atonRoundResult.firstPlayerEnum];
    AtonPlayer *secondPlayer = [playerArray objectAtIndex:para.atonRoundResult.secondPlayerEnum];
    
    if (para.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        
       // AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
        if ([[redPlayer emptyCardElementArray] count] < 4) {
            return;
        }
        para.gamePhaseEnum = GAME_PHASE_RED_CLOSE_CARD;
        [redPlayer closeMenu];
        if (para.onlineMode) {
            [redPlayer closeCards];
            
            // send data
            NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
            NSNumber *nsPlayerEnum = [NSNumber numberWithInt:PLAYER_RED];
            NSMutableArray *nsCardNumArray = [[NSMutableArray alloc] init];
            int *cardNumArray = [redPlayer getCardNumberArray];
            for (int i=0; i<4; i++) {
                [nsCardNumArray addObject:[NSNumber numberWithInt:cardNumArray[i]]];
            }
            GameData *gameData = [[GameData alloc] initWithCardArray:nsGamePhaseEnum:nsPlayerEnum:nsCardNumArray];
            [[GameCenterHelper sharedInstance] sendGameData:gameData];
            
            if (para.arrangeCardData != nil && para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
                [self setBlueCard];
               // para.arrangeCardData = nil;
                
                para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
            } else {
                // waiting for remote player ...
                para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD;
            }
        } 
        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        
      //  AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
        if ([[bluePlayer emptyCardElementArray] count] < 4) {
            return;
        }
        para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
        [bluePlayer closeMenu];
        
        if (para.onlineMode) {
            [bluePlayer closeCards];
            
            // send data
            NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
            NSNumber *nsPlayerEnum = [NSNumber numberWithInt:PLAYER_BLUE];
            NSMutableArray *nsCardNumArray = [[NSMutableArray alloc] init];
            int *cardNumArray = [bluePlayer getCardNumberArray];
            for (int i=0; i<4; i++) {
                [nsCardNumArray addObject:[NSNumber numberWithInt:cardNumArray[i]]];
            }
            GameData *gameData = [[GameData alloc] initWithCardArray:nsGamePhaseEnum:nsPlayerEnum:nsCardNumArray];
            [[GameCenterHelper sharedInstance] sendGameData:gameData];
           // [self sendGameData:gameData];
            
            
            if (para.arrangeCardData != nil && para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
                [self setRedCard];
             //   para.arrangeCardData = nil;
                para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
            } else {
                // waiting for remote player ...
                para.gamePhaseEnum = GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD;
            }
        } 

        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != [para.atonRoundResult getFirstRemovePositiveNum]) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            if (para.onlineMode) {
              //  if (localPlayerEnum == activePlayerEnum) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_FIRST_REMOVE_PEEP];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.firstPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
            [TempleUtility disableTemplesFlame:[para templeArray]];
            
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            [firstPlayer closeMenu];
            
            if(para.onlineMode) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != [para.atonRoundResult getSecondRemovePositiveNum]) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run];
            
        } else {
            
            if (para.onlineMode) {
                //  if (localPlayerEnum == activePlayerEnum) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_SECOND_REMOVE_PEEP];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.secondPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
             [TempleUtility disableTemplesFlame:[para templeArray]];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            [secondPlayer closeMenu];
            
            if(para.onlineMode) {
                NSNumber *messageGamePhaseEnum = [NSNumber numberWithInt:para.gamePhaseEnum];
                [self performSelector:@selector(autoAdvanceGameEnum:) withObject:messageGamePhaseEnum afterDelay:2.0 + AUTO_ADVANCE_WAITING_TIME];
            }
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != para.atonRoundResult.firstPlaceNum) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
        } else {
            
            if (para.onlineMode) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_FIRST_PLACE_PEEP];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.firstPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
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
                [firstPlayer closeMenu];
            }
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != para.atonRoundResult.secondPlaceNum) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
        } else {
            
            if (para.onlineMode) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_SECOND_PLACE_PEEP];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.secondPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
            
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
            [secondPlayer closeMenu];
        }
    } else if (para.gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        int currentPlayerEnum = para.atonRoundResult.higherScorePlayer;
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[para templeArray]:allSelectedSlots] == NO) {
            
            gameManager.messagePlayerEnum = currentPlayerEnum;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            if (para.onlineMode) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.firstPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
            
            [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
            
            [TempleUtility disableTemplesFlame:[para templeArray]];
            gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            [[playerArray objectAtIndex:currentPlayerEnum] closeMenu];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        int currentPlayerEnum = para.atonRoundResult.lowerScorePlayer;
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[para templeArray]:allSelectedSlots] == NO) {
            
            gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            if (para.onlineMode) {
                NSMutableArray* liteSlotArray = [TempleUtility findAllSelectedLiteSlotArray:allSelectedSlots];
                NSNumber *nsGamePhaseEnum = [NSNumber numberWithInt:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
                NSNumber *nsActivePlayerEnum = [NSNumber numberWithInt:para.atonRoundResult.secondPlayerEnum];
                GameData *gameData = [[GameData alloc] initWithSlotArray:nsGamePhaseEnum:nsActivePlayerEnum:liteSlotArray];
                [[GameCenterHelper sharedInstance] sendGameData:gameData];
            }
            
            [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
            [TempleUtility disableTemplesFlame:[para templeArray]];
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:[messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN] afterDelay:AFTER_PEEP_DELAY_TIME];
            [[playerArray objectAtIndex:currentPlayerEnum] closeMenu];
        }
        
    }

}

-(void) showFinalResult {

    NSString *msg = [gameManager gameOverConditionSuper];
    [gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:0.0];
}

-(void) setBlueCard {
   
    AtonPlayer *bluePlayer = [para.playerArray objectAtIndex:PLAYER_BLUE];
    int *remoteNumberArray = malloc(sizeof(int)*4);
    NSMutableArray *nsCardArray = para.arrangeCardData.cardNumArray;
    for (int i=0; i < 4; i++) {
        remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
    }
    [bluePlayer setCardNumberArray:remoteNumberArray];
    para.arrangeCardData = nil;
}

-(void) setRedCard {
   
    AtonPlayer *redPlayer = [para.playerArray objectAtIndex:PLAYER_RED];
    int *remoteNumberArray = malloc(sizeof(int)*4);
    NSMutableArray *nsCardArray = para.arrangeCardData.cardNumArray;
    for (int i=0; i < 4; i++) {
        remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
    }
    [redPlayer setCardNumberArray:remoteNumberArray];
    para.arrangeCardData = nil;
}

-(void) autoAdvanceGameEnum:(NSNumber*) startGamePhaseEnum {
    if (para.gamePhaseEnum == startGamePhaseEnum.intValue ) {
        gameManager.gamePhaseView.hidden = YES;
        para.gamePhaseEnum++;
        [self run];
    }
}
//-(void) sendGameData:(GameData*) gameData {
    
     //[[GameCenterHelper sharedInstance] sendGameData:gameData :self];

   // GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:localRandomNum]:@"Morning"];
   /* NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
    
    GKMatch *match = para.onlinePara.match;
    NSError *error;
    [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    NSLog(@"send game data ...");*/
//}

//---------------------------------------------
//#pragma mark GKMatchDelegate
/*
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    NSLog(@"received data ... mi...");
    
    if (para.onlinePara.match != theMatch) return;
    
     NSLog(@"same match");
  //  if (gameCenterStateEnum != GAME_CENTER_WAITING_RANDOM_NUMBER) {
  //      return;
  //  }
    
    GameData *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (receivedData == nil) {
        NSLog(@"received NULL data");
    }
    if (receivedData != nil) {
        para.onlinePara.remoteGamePhaseEnum = receivedData.gamePhaseEnum.intValue;
        NSLog(@"remote game phase enum : %d ", para.onlinePara.remoteGamePhaseEnum);
        NSMutableArray *nsCardArray = receivedData.cardNumArray;
        if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
            AtonPlayer *bluePlayer = [para.playerArray objectAtIndex:PLAYER_BLUE];
            int *remoteNumberArray = malloc(sizeof(int)*4);
            for (int i=0; i < 4; i++) {
                remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
            }
            [bluePlayer setCardNumberArray:remoteNumberArray];
            
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD) {
                para.gamePhaseEnum = GAME_PHASE_COMPARE;
                [self run];
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
            AtonPlayer *redPlayer = [para.playerArray objectAtIndex:PLAYER_RED];
            int *remoteNumberArray = malloc(sizeof(int)*4);
            for (int i=0; i < 4; i++) {
                remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
            }
            [redPlayer setCardNumberArray:remoteNumberArray];
            
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD) {
                para.gamePhaseEnum = GAME_PHASE_COMPARE;
                [self run];
            }
        }
        
        
       // remoteRandomNum = [receivedData.randomNum intValue];
       // gameCenterStateEnum = GAME_CENTER_WAITING_GAME_START;
       // [self checkGameStart];
    }
}*/

/*
// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    if (para.onlinePara.match != theMatch) return;
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
           // [self lookupPlayers];
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            break;
    }                     
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    if (para.onlinePara.match != theMatch) return;
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (para.onlinePara.match != theMatch) return;
    NSLog(@"Match failed with error: %@", error.localizedDescription);
}
*/

- (void) engineRun {
    NSLog(@"delegate run");
    [self run];
}
@end
