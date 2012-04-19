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
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 1 result:\n Player Red wins 4 points" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_CARD_ONE_RESULT) {
        [gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 2 result:\n Player Blue can remove 2 Red Peeps" afterDelay:1.0];
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        int occupiedEnum = OCCUPIED_RED;
        /* if (playerEnum == 0) {
            occupiedEnum = OCCUPIED_RED;
        } else if (playerEnum == 1) {
            occupiedEnum = OCCUPIED_BLUE;
        }*/
        
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :occupiedEnum];
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_BLUE];
        
    } else if(gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    } else if(gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        [TempleUtility enableEligibleTempleSlotInteraction:templeArray :TEMPLE_4 :OCCUPIED_EMPTY];
        
    }
}

-(AtonRoundResult*) computeRoundResult:(NSMutableArray*) playerArray:(AtonRoundResult*) result {
    [result setFirstPlayerEnum:1];
    [result setSecondPlayerEnum:0];
    [result setCardOneWinnerEnum:0];
    [result setCardOneWinningScore:4];
    return result;
}
@end
