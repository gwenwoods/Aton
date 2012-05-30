//
//  AtonGameEngine.m
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameEngine.h"

@implementation AtonGameEngine

static float MESSAGE_DELAY_TIME = 0.2;
static float ANIMATION_DELAY_TIME = 0.2;
static float SCARAB_MOVING_TIME = 0.5;
static int AFTER_PEEP_DELAY_TIME = 2.0;

@synthesize para;
@synthesize gameManager;
@synthesize useAI;

-(id)initializeWithParameters:(AtonGameParameters*) parameter:(UIViewController*) controller:(AVAudioPlayer*) atonAudioPlayGame:(AVAudioPlayer*) atonAudioChime {
	if (self) {
        para = parameter;
        gameManager = [[AtonGameManager alloc] initializeWithParameters:controller:atonAudioPlayGame:atonAudioChime];
        messageMaster = [[AtonMessageMaster alloc] initializeWithParameters:para];
        useAI = para.useAI;
        ai = [[AtonAIEasy alloc] initializeWithParameters:para.templeArray:para.audioToDeath];
        placePeepEngine = [[AtonPlacePeepExecutor alloc] initializeWithParameters:para:gameManager:messageMaster:ai];
        removePeepEngine = [[AtonRemovePeepExecutor alloc] initializeWithParameters:para:gameManager:messageMaster:ai];
        arrangeCardExecutor = [[AtonArrangeCardsExecutor alloc] initializeWithParameters:para:gameManager:messageMaster:ai];
    }
    return self;
}


-(void) run {
    
    int gamePhaseEnum = para.gamePhaseEnum;
    NSMutableArray *playerArray = para.playerArray;
    NSMutableArray *templeArray = para.templeArray;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    AtonPlayer *playerRed = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *playerBlue = [playerArray objectAtIndex:PLAYER_BLUE];
    
    AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];

    if (gamePhaseEnum == GAME_PHASE_DISTRIBUTE_CARD) {
        for (int i=0; i< [playerArray count]; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player resetCard];
            [player distributeCards];
        }
        
        NSString *msg = @"|";
        msg = [msg stringByAppendingString:playerRed.playerName];
        msg = [msg stringByAppendingString:@"\n\n Please Arrange\n Your Card Placements"];
        gameManager.messagePlayerEnum = PLAYER_RED;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:3.0];    
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        [playerRed openCardsForArrange];   

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        [playerRed closeCards]; 
        
        if (useAI == YES) {
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
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Compare Results" afterDelay:1.0 + animationTime];
        } else {
            NSString *msg = @"|";
            msg = [msg stringByAppendingString:playerBlue.playerName];
            msg = [msg stringByAppendingString:@"\n\n Please Arrange\n Your Card Placements"];
            gameManager.messagePlayerEnum = PLAYER_BLUE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        }
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {

        [playerBlue openCardsForArrange];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
        [playerBlue closeCards];
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Compare Results" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_COMPARE) {
        for (int i=0; i<2; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player openCards];
        }

        roundResult = [self computeRoundResult:playerArray:roundResult];
        NSString* msg = @"Card 1 Result|";
        int cardOneWinnerEnum = roundResult.cardOneWinnerEnum;
        
        if (cardOneWinnerEnum == PLAYER_NONE) {
            msg = [msg stringByAppendingString:@"TIE \n no player gains any point"];
            
        } else {
            AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
            NSString* cardOneWinnerName = [cardOneWinner playerName];
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            msg = [msg stringByAppendingString:cardOneWinnerName];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n\n Wins %i Points\n\n", cardOneWinningScore]];
            
        }
        gameManager.messagePlayerEnum = cardOneWinnerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {

        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        
        int winnerOriginalScore = 0;
        int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
        if (cardOneWinnerEnum != PLAYER_NONE) {
            winnerOriginalScore = [[playerArray objectAtIndex:cardOneWinnerEnum] score];
            
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
        NSString *msg = [messageMaster getMessageForTempleScoreResult:result_orangeBonusForRed];
        gameManager.messagePlayerEnum = result_orangeBonusForRed.winningPlayerEnum;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
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
        NSString *msg = @"Temple scoring end";
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    }  else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING_END) {

        if ([self gameOverConditionSuper] != nil) {
            [gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:MESSAGE_DELAY_TIME];
            
        } else {
            
            int higherScorePlayer = PLAYER_RED;
            
            roundResult.higherScorePlayer = PLAYER_RED;
            roundResult.lowerScorePlayer = PLAYER_BLUE;
            if(bluePlayer.score > redPlayer.score) {
                higherScorePlayer = PLAYER_BLUE;
                roundResult.lowerScorePlayer = PLAYER_RED;
                roundResult.higherScorePlayer = PLAYER_BLUE;
               // Add Tie case - random decide
            } else if (bluePlayer.score == redPlayer.score) {
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
        [TempleUtility enableActiveTemplesFlame:para.templeArray:roundResult.higherScorePlayer:4];
        if (useAI == YES && roundResult.higherScorePlayer == PLAYER_BLUE) {
            [ai removeOnePeepFromEachTemple:roundResult.higherScorePlayer];
            
            gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        } else {
            
            int targetPlayerEnum = [roundResult higherScorePlayer];
            int occupiedEnum = OCCUPIED_RED;
            if (targetPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
          //  NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
            
            NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray :TEMPLE_4:occupiedEnum];
            int arrayNum = [eligibleSlotArray count];
            if (arrayNum == 0) {
                
                [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];
                
                gameManager.messagePlayerEnum = roundResult.higherScorePlayer;
                NSString *msg = @"|No Available Peeps\n to Remove\n";
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
                
            } else if (arrayNum <= 4) {
                [TempleUtility removePeepsToSupply:templeArray:eligibleSlotArray];
                
                gameManager.messagePlayerEnum = roundResult.higherScorePlayer;
                NSString *msg = @"|All Eligible\n Peeps Removed\n";
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE;
                
            } else {
                [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
                [[playerArray objectAtIndex:roundResult.higherScorePlayer] displayMenu:ACTION_REMOVE:-4];
            }
            
        }
        
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        [TempleUtility enableActiveTemplesFlame:para.templeArray:roundResult.lowerScorePlayer:4];
        if (useAI == YES && roundResult.lowerScorePlayer == PLAYER_BLUE) {
            double animationTime = [ai removeOnePeepFromEachTemple:roundResult.lowerScorePlayer];
            
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Scoring End" afterDelay:animationTime + AFTER_PEEP_DELAY_TIME];
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

            NSMutableArray *eligibleSlotArray = [TempleUtility findEligibleTempleSlots:templeArray:TEMPLE_4: occupiedEnum];
            int arrayNum = [eligibleSlotArray count];
            if (arrayNum == 0) {
                
                [TempleUtility disableAllTempleSlotInteractionAndFlame:templeArray];
                gameManager.messagePlayerEnum = roundResult.lowerScorePlayer;
                NSString *msg = @"|No Available Peeps\n to Remove\n";
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
            } else if (arrayNum <= 4) {
                [TempleUtility removePeepsToSupply:templeArray:eligibleSlotArray];
                gameManager.messagePlayerEnum = roundResult.lowerScorePlayer;
                NSString *msg = @"|All Eligible\n Peeps Removed\n";
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE;
            } else {
                [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
                [[playerArray objectAtIndex:roundResult.lowerScorePlayer] displayMenu:ACTION_REMOVE:-4];
            }
        }

        
       
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
        NSString *msg = @"Scoring End";
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
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Death Temple Full\n Scoring Phase Begin" afterDelay:AFTER_PEEP_DELAY_TIME];
        } else {
            if ([self gameOverConditionSuper] != nil) {
                // To see if any temple is filled by one player
                // which will cause the game to finish
                NSString *msg = [self gameOverConditionSuper];
                [gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            } else {
                para.gamePhaseEnum = GAME_PHASE_PRE_DISTRIBUTE_CARD;
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
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
            int firstPlayerEnum = time(0)%2;
            [result setFirstPlayerEnum:firstPlayerEnum];
            int secondPlayerEnum = (firstPlayerEnum+1)%2;
            [result setSecondPlayerEnum:secondPlayerEnum];
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
    
    int oldScore = [winningPlayer score];
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
    int oldScore = [cardOneWinner score];
    if (oldScore >= 41) {
        cardOneWinner.score = newScore;
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
                         cardOneWinner.score = newScore;
                     }];
}

-(float) templeScoreAnimation:(TempleScoreResult*) result {
    
    int playerEnum = result.winningPlayerEnum;
    int winningScore = result.winningScore;
    float animationTime = 0.0;
    if (playerEnum != PLAYER_NONE && winningScore > 0) {
        
        AtonPlayer *player = [para.playerArray objectAtIndex:playerEnum];
        int playerOriginalScore = player.score;
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
    if ([self gameOverConditionSuper] != nil) {
        [gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        //   [TempleUtility clearDeathTemple:[para templeArray]];
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Death Temple Full\n Scoring Phase Begin" afterDelay: AFTER_PEEP_DELAY_TIME];
        //[self run];
    } else {
        gameManager.messagePlayerEnum = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
        
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
        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        
      //  AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
        if ([[bluePlayer emptyCardElementArray] count] < 4) {
            return;
        }
        para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
        [bluePlayer closeMenu];
        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != [para.atonRoundResult getFirstRemovePositiveNum]) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
             [TempleUtility disableTemplesFlame:[para templeArray]];
            
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            [firstPlayer closeMenu];
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
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
             [TempleUtility disableTemplesFlame:[para templeArray]];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
            [secondPlayer closeMenu];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != para.atonRoundResult.firstPlaceNum) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
        } else {
            int occupiedEnum = OCCUPIED_RED;
            if (para.atonRoundResult.firstPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:occupiedEnum];
            }
            [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
            if ([self gameOverConditionSuper] != nil) {
                [gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:0.0];
                
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
            int occupiedEnum = OCCUPIED_RED;
            if (para.atonRoundResult.secondPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:occupiedEnum];
            }
            [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
            
            if ([self gameOverConditionSuper] != nil) {
                [gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverConditionSuper] afterDelay:0.0];
                
            } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
             //   [TempleUtility clearDeathTemple:[para templeArray]];
                para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
                
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Death Temple Full\n Scoring Phase Begin" afterDelay:AFTER_PEEP_DELAY_TIME];
                //[self run];
            } else {
                gameManager.messagePlayerEnum = PLAYER_NONE;
                [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
             
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
            
            [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
            [TempleUtility disableTemplesFlame:[para templeArray]];
            //  NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_DISTRIBUTE_CARD];
            gameManager.messagePlayerEnum = PLAYER_NONE;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Scoring End" afterDelay:AFTER_PEEP_DELAY_TIME];
            [[playerArray objectAtIndex:currentPlayerEnum] closeMenu];
        }
        
    }

}

-(void) showFinalResult {

    NSString *msg = [self gameOverConditionSuper];
    [gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:0.0];
}

-(NSString*) gameOverConditionSuper {
    
    
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
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_4];
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
