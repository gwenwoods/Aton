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

@synthesize para;


-(id)initializeWithParameters:(AtonGameParameters*) parameter {
	if (self) {
        para = parameter;
    }
    return self;
}


-(void) run {
    
    int gamePhaseEnum = para.gamePhaseEnum;
    NSMutableArray *playerArray = [para playerArray];
    NSMutableArray *templeArray = [para templeArray];
    AtonGameManager *gameManager = [para gameManager];
    
    if (gamePhaseEnum == GAME_PHASE_DISTRIBUTE_CARD) {
        [para.atonRoundResult reset];
        for (int i=0; i< [playerArray count]; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player resetCard];
            [player distributeCards];
        }
        
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Player Red:\n\n Lay your cards" afterDelay:3.0];
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed openCardsForArrange];   
        

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed closeCards]; 
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Player Blue:\n\n Lay your cards" afterDelay:0.75];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        AtonPlayer *playerBlue = [playerArray objectAtIndex:1];
        [playerBlue openCardsForArrange];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
        AtonPlayer *playerBlue = [playerArray objectAtIndex:1];
        [playerBlue closeCards]; 
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Compare Results" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_COMPARE) {
        for (int i=0; i<2; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player openCards];
        }

        para.atonRoundResult = [self computeRoundResult:playerArray:para.atonRoundResult];
        NSString* msg = @"Card 1 Result:\n\n";
        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        
        if (cardOneWinnerEnum == PLAYER_NONE) {
            msg = [msg stringByAppendingString:@"tie"];
            
        } else {
            AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
            NSString* cardOneWinnerName = [cardOneWinner playerName];
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            msg = [msg stringByAppendingString:cardOneWinnerName];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"\n wins %i points", cardOneWinningScore]];
            
        }
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
        
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {

        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        if (cardOneWinnerEnum != PLAYER_NONE) {
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
            [invocation setArgument:&cardOneWinnerEnum atIndex:2];
            [invocation setArgument:&cardOneWinningScore atIndex:3];
            
            [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DELAY_TIME invocation:invocation repeats:NO];
        }
        
        NSString *msg = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        if (para.atonRoundResult.firstRemoveNum == 0) {
            NSString* msg = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
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
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        
        if ([eligibleSlotArray count] == 0) {
            NSString *msg = @"No available peeps to remove\n\n";
            NSString *msg1 = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            msg = [msg stringByAppendingString:msg1];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
        } else if (arrayNum < [para.atonRoundResult getFirstRemovePositiveNum]) {
            for (int i=0; i<[eligibleSlotArray count]; i++) {
                TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
                TempleSlot *deathSlot = [TempleUtility findFirstAvailableDeathSpot:templeArray];
                // TODO: check nil for deathSlot
                [deathSlot placePeep:[selectedSlot occupiedEnum]];
                [selectedSlot removePeep];
            }
            NSString *msg = @"All eligible peeps removed\n\n";
            NSString *msg1 = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            msg = [msg stringByAppendingString:msg1];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        }
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        if (para.atonRoundResult.secondRemoveNum == 0) {
            NSString* msg = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            return;
        }
        
        int targetPlayerEnum = [para.atonRoundResult getSecondRemoveTargetEnum];
        int occupiedEnum = OCCUPIED_RED;
        if (targetPlayerEnum == PLAYER_BLUE) {
            occupiedEnum = OCCUPIED_BLUE;
        }

        // TODO: change back to max temple
        NSMutableArray *eligibleSlotArray = [TempleUtility enableEligibleTempleSlotInteraction:templeArray:TEMPLE_4: occupiedEnum];
        int arrayNum = [eligibleSlotArray count];
        // TODO: need to take care of the case:
        if ([eligibleSlotArray count] == 0) {
            NSString *msg = @"No available peep to remove\n\n";
            NSString *msg1 = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            msg = [msg stringByAppendingString:msg1];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
        } else if (arrayNum < [para.atonRoundResult getSecondRemovePositiveNum]) {
            for (int i=0; i<[eligibleSlotArray count]; i++) {
                TempleSlot *selectedSlot = [eligibleSlotArray objectAtIndex:i];
                TempleSlot *deathSlot = [TempleUtility findFirstAvailableDeathSpot:templeArray];
                // TODO: check nil for deathSlot
                [deathSlot placePeep:[selectedSlot occupiedEnum]];
                [selectedSlot removePeep];
            }
            NSString *msg = @"All eligible peeps removed\n\n";
            NSString *msg1 = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            msg = [msg stringByAppendingString:msg1];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        }
        
    } else if (gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if (gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_SCORE) {
       // [TempleUtility clearDeathTemple:templeArray];
       // NSMutableArray *templeScoreArray = [TempleUtility computeAllTempleScore:templeArray];
       // TempleScoreResult *result_t1 = [TempleUtility computeScoreTemple1:[templeArray objectAtIndex:TEMPLE_1]];
        TempleScoreResult *result_t1 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:0];
        NSString *msg = [result_t1 getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION) {
        TempleScoreResult *result_t1 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:0];
        float animationTime = [self templeScoreAnimation:result_t1];

        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:1];
        NSString *msg = [result_t2 getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION) {
        TempleScoreResult *result_t2 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:1];
        float animationTime = [self templeScoreAnimation:result_t2];
        
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:2];
        NSString *msg = [result_t3 getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION) {
        TempleScoreResult *result_t3 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:2];
        float animationTime = [self templeScoreAnimation:result_t3];
        
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:3];
        NSString *msg = [result_t4 getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION) {
        TempleScoreResult *result_t4 = [para.atonRoundResult.templeScoreResultArray objectAtIndex:3];
        float animationTime = [self templeScoreAnimation:result_t4];

        TempleScoreResult *result_greyBonus = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_GREY_BONUS];
        NSString *msg = [result_greyBonus getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
    
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION) {
        TempleScoreResult *result_greyBonus = [para.atonRoundResult.templeScoreResultArray objectAtIndex:4];
        float animationTime = [self templeScoreAnimation:result_greyBonus];
        
        TempleScoreResult *result_orangeBonusForRed = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
        NSString *msg = [result_orangeBonusForRed getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION) {
        TempleScoreResult *result_orangeBonusForRed = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_RED];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForRed];
        
        TempleScoreResult *result_orangeBonusForBlue = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        NSString *msg = [result_orangeBonusForBlue getWinningMessage];
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:animationTime];
        
    } else if (gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION) {
        TempleScoreResult *result_orangeBonusForBlue = [para.atonRoundResult.templeScoreResultArray objectAtIndex:SCORE_ORANGE_BONUS_BLUE];
        float animationTime = [self templeScoreAnimation:result_orangeBonusForBlue];
        
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"round ... end.." afterDelay:animationTime];
        
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
    
  //  int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
    NSMutableArray *playerArray = [para playerArray];
    NSMutableArray *scarabArray = [para scarabArray];
    AtonPlayer *cardOneWinner = [playerArray objectAtIndex:playerEnum];
    int oldScore = [cardOneWinner score];
   // int newScore = [points intValue];
    
    ScoreScarab *oldScarab = [scarabArray objectAtIndex:oldScore];
    ScoreScarab *newScarab = [scarabArray objectAtIndex:newScore];
    
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
    if (playerEnum != PLAYER_NONE && winningScore > 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
        [invocation setArgument:&playerEnum atIndex:2];
        [invocation setArgument:&winningScore atIndex:3];
        
        [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DELAY_TIME invocation:invocation repeats:NO];
    }
    
    
    float animationTime = SCARAB_MOVING_TIME * winningScore + ANIMATION_DELAY_TIME;
    return animationTime;
}
@end
