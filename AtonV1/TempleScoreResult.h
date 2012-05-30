//
//  TempleScoreResult.h
//  AtonV1
//
//  Created by Wen Lin on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"

enum SCORE_ENUM {
    SCORE_TEMPLE_1, SCORE_TEMPLE_2, SCORE_TEMPLE_3, SCORE_TEMPLE_4,
    SCORE_GREY_BONUS, SCORE_ORANGE_BONUS_RED, SCORE_ORANGE_BONUS_BLUE
};

@interface TempleScoreResult : NSObject

//-(NSString*) getWinningMessage;

@property(nonatomic) int templeEnum;
@property(strong, nonatomic) NSString* resultName;
@property(nonatomic) int winningPlayerEnum;
@property(nonatomic) int winningScore;

@end
