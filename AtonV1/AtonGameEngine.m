//
//  AtonGameEngine.m
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameEngine.h"

@implementation AtonGameEngine

static int MESSAGE_DELAY_TIME = 0.2;

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
        
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Player Red: Lay your cards" afterDelay:4.0];
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed openCardsForArrange];   
        

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed closeCards]; 
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Player Blue: Lay your cards" afterDelay:1.0];
        
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
        NSString* msg = @"Card 1 Result:\n";
        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        
        if (cardOneWinnerEnum == PLAYER_NONE) {
            msg = [msg stringByAppendingString:@"tie"];
            
        } else {
        
            AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
            NSString* cardOneWinnerName = [cardOneWinner playerName];
            int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
            msg = [msg stringByAppendingString:cardOneWinnerName];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@" wins %i points", cardOneWinningScore]];
          //  [self performSelector:@selector(assignCardOneScore) withObject:nil afterDelay:.75];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
            [invocation setArgument:&cardOneWinnerEnum atIndex:2];
            [invocation setArgument:&cardOneWinningScore atIndex:3];
            
            [NSTimer scheduledTimerWithTimeInterval:0.75 invocation:invocation repeats:NO];
            //[self performSelector:@selector(assignScoreToPlayer:) withObject:nil afterDelay:.75];
        }
        [gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:0.75];
      //  [cardOneWinner performSelector:@selector(assignScore:) withObject:msg afterDelay:0.75];
      //  [cardOneWinner assignScore:cardOneWinningScore :para.scarabArray];
        
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {
      //  [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 2 result:\n Player Blue can remove 2 Red Peeps" afterDelay:1.0];
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
            NSString *msg = @"No available peeps to remove. \n\n";
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
            NSString *msg = @"All eligible peeps removed. \n\n";
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
            NSString *msg = @"No available peeps to remove. \n\n";
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
            NSString *msg = @"All eligible peeps removed. \n\n";
            NSString *msg1 = [para.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            msg = [msg stringByAppendingString:msg1];
            [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
        }
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if(gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_1_SCORE) {
        [TempleUtility clearDeathTemple:templeArray];
        
        int playerEnum = PLAYER_RED;
        int winningScore = 10;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(assignScoreToPlayer:withWinningScore:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(assignScoreToPlayer:withWinningScore:)];
        [invocation setArgument:&playerEnum atIndex:2];
        [invocation setArgument:&winningScore atIndex:3];
        
        [NSTimer scheduledTimerWithTimeInterval:0.75 invocation:invocation repeats:NO];
        
        [para.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Player Red wins 10 score" afterDelay:0.1];
        
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

-(void) assignCardOneScore {
    int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
    NSMutableArray *playerArray = [para playerArray];
 //   NSMutableArray *scarabArray = [para scarabArray];
    AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
    
    int oldScore = [cardOneWinner score];
    int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
    int newScore = oldScore + cardOneWinningScore;
    
    if (oldScore < 15 && newScore > 15) {
        //ScoreScarab *middleScarab = [scarabArray objectAtIndex:15];
        [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:15] afterDelay:0.0];
        [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:newScore] afterDelay:(15-oldScore)*0.25 + 0.05];

    } else if (oldScore < 26 && newScore > 26) {
        //ScoreScarab *middleScarab = [scarabArray objectAtIndex:15];
        [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:26] afterDelay:0.0];
        [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:newScore] afterDelay:(26-oldScore)*0.25 + 0.01];
        
    } else {
 
        [self moveScoreAnimation:[NSNumber numberWithInt:newScore]];
    }


}

-(void) moveScoreAnimation:(NSNumber*) points {
    
    int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
    NSMutableArray *playerArray = [para playerArray];
    NSMutableArray *scarabArray = [para scarabArray];
    AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
    int oldScore = [cardOneWinner score];
    int newScore = [points intValue];
    
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
    
    [UIView animateWithDuration:0.25*moveNum
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
    
/*    for (int i=0; i< louisdorNum; i++) {
        [NSTimer scheduledTimerWithTimeInterval:(CARD_TRANSITION_TIME + i*STARTING_TIME_INTERVAL + j*louisdorNum*STARTING_TIME_INTERVAL) invocation:invocation repeats:NO];
    }*/

    
    
    if (oldScore < 15 && newScore > 15) {
        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:(15-oldScore)*0.25 + 0.05 invocation:invocation repeats:NO];
     //   [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:15] afterDelay:0.0];
     //   [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:newScore] afterDelay:(15-oldScore)*0.25 + 0.05];
        
    } else if (oldScore < 26 && newScore > 26) {
        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:(26-oldScore)*0.25 + 0.05 invocation:invocation repeats:NO];
      //  [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:26] afterDelay:0.0];
      //  [self performSelector:@selector(moveScoreAnimation:) withObject:[NSNumber numberWithInt:newScore] afterDelay:(26-oldScore)*0.25 + 0.01];
        
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation repeats:NO];
       // [self moveScoreAnimation:[NSNumber numberWithInt:newScore]];
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
    
    [UIView animateWithDuration:0.25*moveNum
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
@end
