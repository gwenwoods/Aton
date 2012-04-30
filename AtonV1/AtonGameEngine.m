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


-(id)initializeWithParameters:(AtonGameParameters*) parameter {
	if (self) {
        para = parameter;
        messageMaster = [[AtonMessageMaster alloc] initializeWithParameters:para];
    }
    return self;
}


-(void) run {
    
    
    
    int gamePhaseEnum = para.gamePhaseEnum;
    NSMutableArray *playerArray = para.playerArray;
    NSMutableArray *templeArray = para.templeArray;
    AtonGameManager *gameManager = para.gameManager;
    AtonRoundResult *roundResult = para.atonRoundResult;
    
    AtonPlayer *playerRed = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *playerBlue = [playerArray objectAtIndex:PLAYER_BLUE];
    
    if (gamePhaseEnum == GAME_PHASE_DISTRIBUTE_CARD) {
        for (int i=0; i< [playerArray count]; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player resetCard];
            [player distributeCards];
        }
        
        NSString *msg = playerRed.playerName;
        msg = [msg stringByAppendingString:@"\n\n Lay your cards"];
        gameManager.activePlayer = PLAYER_RED;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:3.0];    
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        [playerRed openCardsForArrange];   

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        [playerRed closeCards]; 
        NSString *msg = playerBlue.playerName;
        msg = [msg stringByAppendingString:@"\n\n Lay your cards"];
        gameManager.activePlayer = PLAYER_BLUE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        [playerBlue openCardsForArrange];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
        [playerBlue closeCards];
        gameManager.activePlayer = PLAYER_NONE;
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Compare Results" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_COMPARE) {
        for (int i=0; i<2; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player openCards];
        }

        roundResult = [self computeRoundResult:playerArray:roundResult];
        NSString* msg = @"Card 1 Result:\n\n";
        int cardOneWinnerEnum = roundResult.cardOneWinnerEnum;
        
        if (cardOneWinnerEnum == PLAYER_NONE) {
            msg = [msg stringByAppendingString:@"tie"];
            
        } else {
            AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
            NSString* cardOneWinnerName = [cardOneWinner playerName];
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            msg = [msg stringByAppendingString:cardOneWinnerName];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n wins %i points", cardOneWinningScore]];
            
        }
        gameManager.activePlayer = cardOneWinnerEnum;
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
            // GameOver
            NSString* msg = [self gameOverResultMsg];
            gameManager.activePlayer = cardOneWinnerEnum;
            [gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:animationTime];
        } else {
            NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
            [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        }

        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
         [TempleUtility changeSlotBoundaryColor:para.templeArray:[para.atonRoundResult getFirstRemoveTargetEnum]];
        if (para.atonRoundResult.firstRemoveNum == 0) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
        }
        
        int targetPlayerEnum = [para.atonRoundResult getFirstRemoveTargetEnum];
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }
        
        // TODO: change back to max temple
        NSMutableArray *eligibleSlotArray =
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray:roundResult.firstTemple: occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"\nNo available peeps to remove\n";
          //  NSString *msg1 = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
          //  msg = [msg stringByAppendingString:msg1];
          //  gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
        
        } else if (arrayNum < [para.atonRoundResult getFirstRemovePositiveNum]) {

            [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray];
            NSString *msg = @"\nAll eligible peeps removed\n";
          //  NSString *msg1 = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
         //   msg = [msg stringByAppendingString:msg1];
         //   gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_NONE;
        }
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        [TempleUtility changeSlotBoundaryColor:para.templeArray:[para.atonRoundResult getSecondRemoveTargetEnum]];
        
        if (roundResult.secondRemoveNum == 0) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
        }
        
        int targetPlayerEnum = [para.atonRoundResult getSecondRemoveTargetEnum];
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }

        // TODO: change back to max temple
        NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:para.atonRoundResult.secondTemple: occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"\nNo available peep to remove\n";
          //  NSString *msg1 = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
          //  msg = [msg stringByAppendingString:msg1];
          //  gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
        } else if (arrayNum < [para.atonRoundResult getSecondRemovePositiveNum]) {

            [TempleUtility removePeepsToDeathTemple:templeArray:eligibleSlotArray];
            NSString *msg = @"\nAll eligible peeps removed\n";
        //    NSString *msg1 = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
        //    msg = [msg stringByAppendingString:msg1];
         //   gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_NONE;
        }
        
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [TempleUtility changeSlotBoundaryColor:para.templeArray:roundResult.firstPlayerEnum];
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray:roundResult.firstTemple:OCCUPIED_EMPTY];
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [TempleUtility changeSlotBoundaryColor:para.templeArray:roundResult.secondPlayerEnum];
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray:roundResult.secondTemple:OCCUPIED_EMPTY];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING) {
        TempleScoreResult *result_t1 = [roundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_1];
        NSString *msg = [result_t1 getWinningMessage];
        gameManager.activePlayer = result_t1.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING) {
        TempleScoreResult *result_t1 = [roundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_1];
        NSString *msg = [result_t1 getWinningMessage];
        gameManager.activePlayer = result_t1.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION) {
        TempleScoreResult *result_t1 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_1];
        float animationTime = [self templeScoreAnimation:result_t1];

        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_2];
        NSString *msg = [result_t2 getWinningMessage];
        gameManager.activePlayer = result_t2.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION) {
        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_2];
        float animationTime = [self templeScoreAnimation:result_t2];
        
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_3];
        NSString *msg = [result_t3 getWinningMessage];
        gameManager.activePlayer = result_t3.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION) {
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_3];
        float animationTime = [self templeScoreAnimation:result_t3];
        
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_4];
        NSString *msg = [result_t4 getWinningMessage];
        gameManager.activePlayer = result_t4.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION) {
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_TEMPLE_4];
        float animationTime = [self templeScoreAnimation:result_t4];

        TempleScoreResult *result_greyBonus = [roundResult.templeScoreResultArray objectAtIndex:SCORE_GREY_BONUS];
        NSString *msg = [result_greyBonus getWinningMessage];
        gameManager.activePlayer = result_greyBonus.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION) {
        TempleScoreResult *result_greyBonus = [roundResult.templeScoreResultArray objectAtIndex:SCORE_GREY_BONUS];
        float animationTime = [self templeScoreAnimation:result_greyBonus];
        
        TempleScoreResult *result_orangeBonusForRed = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
        NSString *msg = [result_orangeBonusForRed getWinningMessage];
        gameManager.activePlayer = result_orangeBonusForRed.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION) {
        TempleScoreResult *result_orangeBonusForRed = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForRed];
        
        TempleScoreResult *result_orangeBonusForBlue = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        NSString *msg = [result_orangeBonusForBlue getWinningMessage];
        gameManager.activePlayer = result_orangeBonusForBlue.winningPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION) {
        TempleScoreResult *result_orangeBonusForBlue = [roundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForBlue];
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
        gameManager.activePlayer = roundResult.firstPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        
        if ([self gameOverCondition] != nil) {
            [para.gameManager performSelector:@selector(showFinalResultView:) withObject:[self gameOverCondition] afterDelay:0.0];
            
        } else {
            int targetPlayerEnum = [roundResult firstPlayerEnum];
            int occupiedEnum = OCCUPIED_RED;
            if (targetPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
            NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];

            if ([eligibleSlotArray count] == 0) {
                [TempleUtility disableAllTempleSlotInteraction:templeArray];
                NSString *msg = @"No available peep to remove\n\n";
                NSString *msg1 = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
                msg = [msg stringByAppendingString:msg1];
                gameManager.activePlayer = roundResult.secondPlayerEnum;
                [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
                
                return;
            }
        }
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        
        int targetPlayerEnum = [para.atonRoundResult secondPlayerEnum];
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }
        
        NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
        if ([eligibleSlotArray count] == 0) {
            [TempleUtility disableAllTempleSlotInteraction:templeArray];
            NSString *msg = @"No available peep to remove\n\n";
            msg = [msg stringByAppendingString:@"Scoring End"];
            gameManager.activePlayer = PLAYER_NONE;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
        }
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_NONE) {
        // BRANCH PHASE
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
        // msg = [msg stringByAppendingString:msg1];
        gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_SECOND_REMOVE_PEEP;
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_NONE) {
        NSString *msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
       // msg = [msg stringByAppendingString:msg1];
        gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.0];
        para.gamePhaseEnum = GAME_PHASE_PRE_FIRST_PLACE_PEEP;
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

-(void) imageFly:(UIImageView*) begin:(UIImageView*) end {	
	
    int end_x = end.center.x;
    int end_y = end.center.y;
    
	CGMutablePathRef aPath;
	CGFloat arcTop = begin.center.y - 50;
	aPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(aPath, NULL, begin.center.x, begin.center.y);
	CGPathAddCurveToPoint(aPath, NULL, begin.center.x, arcTop, end_x, arcTop, end_x, end_y);
	
	CAKeyframeAnimation* arcAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
	[arcAnimation setDuration: 0.5];
	[arcAnimation setAutoreverses: NO];
	arcAnimation.removedOnCompletion = NO;
	arcAnimation.fillMode = kCAFillModeBoth; 
	[arcAnimation setPath: aPath];
    
	CFRelease(aPath);
	
	[begin.layer addAnimation: arcAnimation forKey: @"position"];
    
	begin.hidden = NO;
    begin.center = CGPointMake(end_x, end_y);
    
   // [begin performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.51];
    //[begin performSelector:@selector(release) withObject:nil afterDelay:0.51];
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

-(NSString*) gameOverCondition {
    
        
    NSString *msg;
    
    if ([TempleUtility isYellowFull:para.templeArray]) {
        msg = @"All Yellow Squares Full\n";
    
    } else if ([TempleUtility isGreenFull:para.templeArray]) {
        msg = @"All Green Squares Full\n";
    
    } else if ([TempleUtility isTempleFull:para.templeArray:TEMPLE_1]) {
        msg = @"Temple 1 Full\n";
    
    } else if ([TempleUtility isTempleFull:para.templeArray:TEMPLE_2]) {
        msg = @"Temple 2 Full\n";
        
    } else if ([TempleUtility isTempleFull:para.templeArray:TEMPLE_3]) {
        msg = @"Temple 3 Full\n";
        
    } else if ([TempleUtility isTempleFull:para.templeArray:TEMPLE_4]) {
        msg = @"Temple 4 Full\n";
    
    }
    
    NSMutableArray *playerArray = para.playerArray;
    if ([[playerArray objectAtIndex:PLAYER_RED] score] > 40) {
        msg = @"Player Red reaches 40 points";
        
    } else if ([[playerArray objectAtIndex:PLAYER_BLUE] score] > 40) {
        msg = @"Player Blue reaches 40 points";
        
    }
    
    if (msg != nil) {
        msg = [msg stringByAppendingString:[self gameOverResultMsg]];
    }
    
    return msg;
}

-(NSString*) gameOverResultMsg {
    
    NSMutableArray *playerArray = para.playerArray;
    NSString *msg = @"\nGame Over\n";
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Red: %i \n", redScore]];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"Player Blue: %i \n", blueScore]];
    return msg;
}

-(void) playerDoneAction {
    NSMutableArray *playerArray = [para playerArray];
    
    if (para.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        
        AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
        if ([[redPlayer emptyCardElementArray] count] < 4) {
            return;
        }
        para.gamePhaseEnum = GAME_PHASE_RED_CLOSE_CARD;
        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        
        AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
        if ([[bluePlayer emptyCardElementArray] count] < 4) {
            return;
        }
        para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
        [self run];
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != [para.atonRoundResult getFirstRemovePositiveNum]) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            para.gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != [para.atonRoundResult getSecondRemovePositiveNum]) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            para.gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run];
            
        } else {
            
            [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            para.gameManager.activePlayer = para.atonRoundResult.firstPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != para.atonRoundResult.firstPlaceNum) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
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
            [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
            para.gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([allSelectedSlots count] != para.atonRoundResult.secondPlaceNum) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
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
            [TempleUtility disableAllTempleSlotInteraction:[para templeArray]];
            if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
                [TempleUtility clearDeathTemple:[para templeArray]];
                para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
                
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
                para.gameManager.activePlayer = PLAYER_NONE;
                [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"DEATH TEMPLE Full\n Enter Scoring Phase" afterDelay:AFTER_PEEP_DELAY_TIME];
                //[self run];
            } else {
                if ([self gameOverCondition] != nil) {
                    NSString *msg = [self gameOverCondition];
                    [para.gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
                } else {
                    para.gameManager.activePlayer = PLAYER_NONE;
                    [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
                }
            }
            
        }
    } else if (para.gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[para templeArray]:allSelectedSlots] == NO) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            para.gameManager.activePlayer = para.atonRoundResult.secondPlayerEnum;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (para.gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[para templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[para templeArray]:allSelectedSlots] == NO) {
            NSString* msg = [messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [para.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[para templeArray]];
            [self run]; 
            
        } else {
            
            [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
            //  NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_DISTRIBUTE_CARD];
            para.gameManager.activePlayer = PLAYER_NONE;
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round ... end ..." afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    }

}
@end
