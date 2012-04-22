//
//  AtonGameEngine.m
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameEngine.h"

@implementation AtonGameEngine

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
        for (int i=0; i< [playerArray count]; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player distributeCards];
        }
        
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Player Red: Lay your cards" afterDelay:4.0];
    
    } else if(gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed openCardsForArrange];   
        

    } else if(gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
        AtonPlayer *playerRed = [playerArray objectAtIndex:0];
        [playerRed closeCards]; 
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Player Blue: Lay your cards" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        AtonPlayer *playerBlue = [playerArray objectAtIndex:1];
        [playerBlue openCardsForArrange];
        
    } else if(gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
        AtonPlayer *playerBlue = [playerArray objectAtIndex:1];
        [playerBlue closeCards]; 
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Compare Results" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_COMPARE) {
        for (int i=0; i<2; i++) {
            AtonPlayer *player = [playerArray objectAtIndex:i];
            [player openCards];
        }

        para.atonRoundResult = [self computeRoundResult:playerArray:para.atonRoundResult];
        NSString* msg = @"Card 1 Result:\n";
        int cardOneWinnerEnum = para.atonRoundResult.cardOneWinnerEnum;
        AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
        NSString* cardOneWinnerName = [cardOneWinner playerName];
        int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
        msg = [msg stringByAppendingString:cardOneWinnerName];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@" wins %i points", cardOneWinningScore]];
        [gameManager performSelector:@selector(showCommunicationView:) withObject:msg afterDelay:0.75];
      //  [cardOneWinner performSelector:@selector(assignScore:) withObject:msg afterDelay:0.75];
      //  [cardOneWinner assignScore:cardOneWinningScore :para.scarabArray];
        [self performSelector:@selector(assignCardOneScore) withObject:nil afterDelay:.75];
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 2 result:\n Player Blue can remove 2 Red Peeps" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        int occupiedEnum = OCCUPIED_RED;
        NSMutableArray *eligibleSlotArray =
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :occupiedEnum];
        
        //if ([eligibleSlotArray count]==0) {
        //    [gameManager performSelector:@selector(showCommunicationView:) withObject:@"No Red peeps to remove. Red can remove 3 Blue Peeps." afterDelay:1.0];
        //}
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_BLUE];
      //   [gameManager performSelector:@selector(showCommunicationView:) withObject:@"No Blue peeps to remove. Red can place 2 Peeps." afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
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
        [result setFirstPlaceNum:PLAYER_BLUE];
        [result setSecondPlayerEnum:PLAYER_RED];
    } else {
        if (redArray[0] < blueArray[0] ) {
            [result setFirstPlaceNum:PLAYER_RED];
            [result setSecondPlayerEnum:PLAYER_BLUE];
        } else if (blueArray[0] < redArray[0]) {
            [result setFirstPlaceNum:PLAYER_BLUE];
            [result setSecondPlayerEnum:PLAYER_RED];
        } else {
            int firstPlayerEnum = time(0)%2;
            [result setFirstPlaceNum:firstPlayerEnum];
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
    NSMutableArray *scarabArray = [para scarabArray];
    AtonPlayer *cardOneWinner = [playerArray objectAtIndex:cardOneWinnerEnum];
    
    int oldScore = [cardOneWinner score];
    int cardOneWinningScore = para.atonRoundResult.cardOneWinningScore;
    int newScore = oldScore + cardOneWinningScore;
    cardOneWinner.score = newScore;
    
    ScoreScarab *oldScarab = nil;
    if (oldScore > 0) {
        oldScarab = [scarabArray objectAtIndex:(oldScore-1)];
    }
    
    ScoreScarab *newScarab = [scarabArray objectAtIndex:(newScore-1)];

    // create animation IV
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:CGRectMake(218.0, 766.0, 40.0, 50.0)];
    if ([cardOneWinner playerEnum] == PLAYER_RED) {
        animationIV.image = newScarab.redIV.image;
    } else {
        animationIV.image = newScarab.blueIV.image;
    }

    if (oldScarab != nil) {
        if ([cardOneWinner playerEnum] == PLAYER_RED) {
            animationIV.frame = oldScarab.redFrame;
            oldScarab.redIV.hidden = YES;
            
        } else {
            animationIV.frame = oldScarab.blueFrame;
            oldScarab.blueIV.hidden = YES;
            
        }
    }
    
    [cardOneWinner.baseView addSubview:animationIV];  
    [cardOneWinner.baseView bringSubviewToFront:animationIV];
    [UIView animateWithDuration:4
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
                         } else {
                             newScarab.blueIV.hidden = NO;
                         }

                     }];

}

@end
