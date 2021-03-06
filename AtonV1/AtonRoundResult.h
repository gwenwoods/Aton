//
//  AtonRoundResult.h
//  AtonV1
//
//  Created by Wen Lin on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTemple.h"
#import "AtonPlayer.h"


enum GAME_PHASE_ENUM {
    // MAIN PHASE
    GAME_PHASE_DISTRIBUTE_CARD, 
    GAME_PHASE_RED_LAY_CARD, GAME_PHASE_RED_CLOSE_CARD,
    GAME_PHASE_BLUE_LAY_CARD, GAME_PHASE_BLUE_CLOSE_CARD,
    GAME_PHASE_COMPARE,
    
    GAME_PHASE_CARD_ONE_RESULT,
    GAME_PHASE_FIRST_REMOVE_PEEP, GAME_PHASE_SECOND_REMOVE_PEEP,
    GAME_PHASE_FIRST_PLACE_PEEP, GAME_PHASE_SECOND_PLACE_PEEP,
    
    GAME_PHASE_ROUND_END_DEATH_FULL, GAME_PHASE_ROUND_END_SCORING, 
    
    GAME_PHASE_ROUND_END_TEMPLE_1_ANIMATION, GAME_PHASE_ROUND_END_TEMPLE_2_ANIMATION,
    GAME_PHASE_ROUND_END_TEMPLE_3_ANIMATION, GAME_PHASE_ROUND_END_TEMPLE_4_ANIMATION,
    GAME_PHASE_ROUND_END_GREY_BONUS_ANIMATION,
    GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_RED_ANIMATION, GAME_PHASE_ROUND_END_ORANGE_BONUS_FOR_BLUE_ANIMATION,
    GAME_PHASE_ROUND_END_FIRST_REMOVE_4, GAME_PHASE_ROUND_END_SECOND_REMOVE_4,
    
    GAME_PHASE_ROUND_END_SCORING_END, 
    //---------------
    // BRANCH PHASE
    GAME_PHASE_FIRST_REMOVE_NONE, GAME_PHASE_PRE_SECOND_REMOVE_PEEP,
    GAME_PHASE_SECOND_REMOVE_NONE, GAME_PHASE_PRE_FIRST_PLACE_PEEP,
    
    GAME_PHASE_FIRST_PLACE_NONE, GAME_PHASE_PRE_SECOND_PLACE_PEEP,
    GAME_PHASE_SECOND_PLACE_NONE, GAME_PHASE_CHECK_DEATH_TEMPLE,
    
    GAME_PHASE_ROUND_END_FIRST_REMOVE_4_NONE, GAME_PHASE_ROUND_END_PRE_SECOND_REMOVE_4,
    GAME_PHASE_ROUND_END_SECOND_REMOVE_4_NONE, GAME_PHASE_PRE_DISTRIBUTE_CARD,
    
    GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD, GAME_PHASE_WAITING_FOR_REMOTE_REMOVE,
    GAME_PHASE_WAITING_FOR_REMOTE_PLACE, GAME_PHASE_WAITING_FOR_REMOTE_REMOVE_4
    
};

@interface AtonRoundResult : NSObject {
    NSMutableArray *playerArray; 
}

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray;


//-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum;
-(int) getFirstRemoveTargetEnum;
-(int) getSecondRemoveTargetEnum;
-(int) getFirstRemovePositiveNum;
-(int) getSecondRemovePositiveNum;

@property(nonatomic) int firstPlayerEnum, secondPlayerEnum;
//@property(nonatomic) int firstActiveTemple, secondActiveTemple;
@property(nonatomic) int firstRemoveNum, secondRemoveNum;
@property(nonatomic) int firstPlaceNum, secondPlaceNum;
@property(nonatomic) int firstTemple, secondTemple;
@property(nonatomic) int cardOneWinnerEnum, cardOneWinningScore;
@property(nonatomic) int higherScorePlayer, lowerScorePlayer;
@property(strong,nonatomic) NSMutableArray *templeScoreResultArray;

@end
