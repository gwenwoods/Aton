//
//  AtonRoundResult.h
//  AtonV1
//
//  Created by Wen Lin on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtonRoundResult : NSObject


@property(nonatomic) int firstPlayerEnum, secondPlayerEnum;
@property(nonatomic) int firstActiveTemple, secondActiveTemple;
@property(nonatomic) int firstRemoveNum, secondRemoveNum;
@property(nonatomic) int firstRemoveCount, secondRemoveCount;
@property(nonatomic) int firstPlaceNum, secondPlaceNum;
@property(nonatomic) int firstPlaceCount, secondPlaceCount;
@property(nonatomic) int firstTemple, secondTemple;
@property(nonatomic) int cardOneWinnerEnum, cardOneWinningScore;


@end
