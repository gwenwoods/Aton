//
//  AtonTouchBeganUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchBeganUtility.h"

@implementation AtonTouchBeganUtility

+(void) checkTouch:(UIEvent *)event:(AtonTouchElement*) touchElement:(AtonGameParameters*) atonParameters: (AtonGameEngine*) engine:(AVAudioPlayer*) audioPlacePeep :(AVAudioPlayer*) audioTap{
    UITouch *touch = [[event allTouches] anyObject];
    NSMutableArray *playerArray = [atonParameters playerArray];
    NSMutableArray *templeArray = [atonParameters templeArray];
   
    
    [self checkGamePhaseView:atonParameters:engine:audioTap];
    [self playerArrangeCard:touch:touchElement:atonParameters];
    [self chooseTempleSlot:touch:templeArray:playerArray:audioPlacePeep];
}

+(void) checkGamePhaseView:(AtonGameParameters*) atonParameters:(AtonGameEngine*) engine:(AVAudioPlayer*) audioTap {

    AtonGameManager *gameManager = [engine gameManager];
   // AtonRoundResult *result = atonParameters.atonRoundResult;
    
    NSMutableArray *playArray = [atonParameters playerArray];
    AtonPlayer *redPlayer = [playArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playArray objectAtIndex:PLAYER_BLUE];
    
    if (gameManager.helpView.hidden == NO) {
        gameManager.helpView.hidden = YES;
        return;
    }
    if (gameManager.gamePhaseView.hidden == YES) {
        return;
    } else {
        [audioTap play];
        gameManager.gamePhaseView.hidden = YES;
        if (atonParameters.gamePhaseEnum == GAME_PHASE_DISTRIBUTE_CARD) {
            atonParameters.gamePhaseEnum = GAME_PHASE_RED_LAY_CARD;
            [redPlayer displayMenu:ACTION_NONE:0];
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
            atonParameters.gamePhaseEnum = GAME_PHASE_BLUE_LAY_CARD;
            [bluePlayer displayMenu:ACTION_NONE:0];
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
            atonParameters.gamePhaseEnum = GAME_PHASE_COMPARE;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_COMPARE ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_CARD_ONE_RESULT;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP ) {
            atonParameters.gamePhaseEnum = GAME_PHASE_DISTRIBUTE_CARD;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_DEATH_FULL) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_SCORING;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION;
        
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_SCORING_END;
           
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_SCORING_END) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4;
        //    [TempleUtility enableActiveTemplesFlame:atonParameters.templeArray:atonParameters.atonRoundResult.firstPlayerEnum:atonParameters.atonRoundResult.firstTemple];
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4;
         //   [TempleUtility enableActiveTemplesFlame:atonParameters.templeArray:atonParameters.atonRoundResult.secondPlayerEnum:atonParameters.atonRoundResult.secondTemple];
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
            atonParameters.gamePhaseEnum = GAME_PHASE_DISTRIBUTE_CARD;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_PRE_SECOND_REMOVE_PEEP ) {
            // BRANCH PHASE
            atonParameters.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_PRE_FIRST_PLACE_PEEP ) {
            // BRANCH PHASE
            atonParameters.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_PRE_SECOND_PLACE_PEEP ) {
            // BRANCH PHASE
            atonParameters.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_PEEP;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_PRE_SECOND_REMOVE_4 ) {
            // BRANCH PHASE
            atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4;
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE ) {
            // BRANCH PHASE
            
        } else if(atonParameters.gamePhaseEnum == GAME_PHASE_PRE_DISTRIBUTE_CARD ) {
            // BRANCH PHASE
            atonParameters.gamePhaseEnum = GAME_PHASE_DISTRIBUTE_CARD;
            
        } else {
            return;
        }
        
        
        
        [engine run];
    }
}

+(void) playerArrangeCard:(UITouch*) touch:(AtonTouchElement*) touchElement: (AtonGameParameters*) atonParameters {
    
    NSMutableArray *playerArray = [atonParameters playerArray];
    AtonPlayer *player;
    if (atonParameters.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        player = [playerArray objectAtIndex:0];
    
    } else if(atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        player = [playerArray objectAtIndex:1];
        
    }
    
    if ([touchElement fromIndex] > 0) {
        return;
    }
    
   
    
    NSMutableArray *cardElementArray = [player cardElementArray];    
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        if([touch view] == ce.iv) {
            
            // the card spot is empty
            if(ce.iv.image == nil) {
                return;
            }
            
            // if a card is available in the regular spot
            // take it to touch element
            CGPoint localLaction = [touch locationInView:ce.iv];
            [touchElement setLocalLaction:localLaction];
            [touchElement takeCardElement:ce];
            [ce taken];
            return;
        }
    }
    
    NSMutableArray *tempCardElementArray = [player tempCardElementArray];
    for (int i=0; i<[tempCardElementArray count]; i++) {
        CardElement *ce = [tempCardElementArray objectAtIndex:i];
        if([touch view] == ce.iv) {

            CGPoint localLaction = [touch locationInView:ce.iv];
            [touchElement setLocalLaction:localLaction];
            [touchElement takeCardElement:ce];
            
            [player releaseTempCardElement:ce];
            [[player baseView] bringSubviewToFront:[touchElement touchIV]];
            return;
        }
    }
}

+(void) chooseTempleSlot:(UITouch*) touch:(NSMutableArray*) templeArray:(NSMutableArray*) playerArray:(AVAudioPlayer*) audioPlacePeep {
    
    AtonPlayer *currentPlayer;
    for (int i=0; i<[playerArray count]; i++) {
        AtonPlayer *player = [playerArray objectAtIndex:i];
        if (player.scrollDoneIV.hidden == NO) {
            currentPlayer = player;
            break;
        }
    }
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        NSMutableArray *templeSlotArray = [temple slotArray];
        for (int j=0; j< [templeSlotArray count]; j++) {
            TempleSlot *slot = [templeSlotArray objectAtIndex:j];
            if([touch view] == [slot iv]) {

                
                NSMutableArray *peepArray = currentPlayer.scrollPeepArray;
                int numPeepsLeftForSelection = 0;
                for (int k=0; k < [peepArray count]; k++) {
                    UIImageView *iv = [peepArray objectAtIndex:k];
                    if (iv.image != nil &&  iv.alpha > 0.5) {
                        numPeepsLeftForSelection++;
                    }
                }
                
                if ([slot isSelected] == NO && numPeepsLeftForSelection == 0) {
                    return;
                }
                
                
                [slot selectOrDeselectSlot];
                [audioPlacePeep play];
                
                if (currentPlayer == nil) {
                    // Code should never reach here
                    return;
                }
                
                if ([slot isSelected]) {
                   
                    for (int k=0; k < [peepArray count]; k++) {
                        UIImageView *iv = [peepArray objectAtIndex:k];
                        if (iv.alpha < 1.0) {
                            continue;
                        } else {
                            iv.alpha = 0.3;
                            break;
                        }
                    }
                } else {
                    
                    for (int k=[peepArray count]-1; k >= 0; k--) {
                        UIImageView *iv = [peepArray objectAtIndex:k];
                        if (iv.alpha < 1.0) {
                            iv.alpha = 1.0;
                            break;

                        } else {
                            continue;
                        }
                    }

                }
            }
        }
    }
}

@end
