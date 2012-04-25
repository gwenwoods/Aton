//
//  AtonRoundResult.h
//  AtonV1
//
//  Created by Wen Lin on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


enum GAME_PHASE_ENUM {
    GAME_PHASE_DISTRIBUTE_CARD, 
    GAME_PHASE_RED_LAY_CARD, GAME_PHASE_RED_CLOSE_CARD,
    GAME_PHASE_BLUE_LAY_CARD, GAME_PHASE_BLUE_CLOSE_CARD,
    GAME_PHASE_COMPARE,
    GAME_PHASE_CARD_ONE_RESULT,
    GAME_PHASE_FIRST_REMOVE_PEEP, GAME_PHASE_SECOND_REMOVE_PEEP,
    GAME_PHASE_FIRST_PLACE_PEEP, GAME_PHASE_SECOND_PLACE_PEEP,
    GAME_PHASE_ROUND_END_TEMPLE_1_SCORE, GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION,
    GAME_PHASE_ROUND_END_TEMPLE_2_SCORE,
    GAME_PHASE_ROUND_END_TEMPLE_3_SCORE,
    GAME_PHASE_ROUND_END_TEMPLE_4_SCORE,
    GAME_PHASE_ROUND_END_FIRST, GAME_PHASE_ROUND_END_SECOND
};

@interface AtonRoundResult : NSObject


@property(nonatomic) int firstPlayerEnum, secondPlayerEnum;
@property(nonatomic) int firstActiveTemple, secondActiveTemple;
@property(nonatomic) int firstRemoveNum, secondRemoveNum;
@property(nonatomic) int firstPlaceNum, secondPlaceNum;
@property(nonatomic) int firstTemple, secondTemple;
@property(nonatomic) int cardOneWinnerEnum, cardOneWinningScore;

-(void) reset;
-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum;
-(int) getFirstRemoveTargetEnum;
-(int) getSecondRemoveTargetEnum;
-(int) getFirstRemovePositiveNum;
-(int) getSecondRemovePositiveNum;

@end
