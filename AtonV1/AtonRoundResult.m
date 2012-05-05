//
//  AtonRoundResult.m
//  AtonV1
//
//  Created by Wen Lin on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonRoundResult.h"

@implementation AtonRoundResult

@synthesize firstPlayerEnum, secondPlayerEnum;
//@synthesize firstActiveTemple, secondActiveTemple;
@synthesize firstRemoveNum, secondRemoveNum;
@synthesize firstPlaceNum, secondPlaceNum;
@synthesize firstTemple, secondTemple;
@synthesize cardOneWinnerEnum, cardOneWinningScore;
@synthesize templeScoreResultArray;


-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray {
	if (self) {
        playerArray = atonPlayerArray;
    }
    return self;
}


-(int) getFirstRemoveTargetEnum {
    
    if (firstRemoveNum < 0) {
        return firstPlayerEnum;
    }  else {
        return secondPlayerEnum;
    }
}

-(int) getSecondRemoveTargetEnum {
    
    if (secondRemoveNum < 0) {
        return secondPlayerEnum;
    }  else {
        return firstPlayerEnum;
    }
}

-(int) getFirstRemovePositiveNum {
    if (firstRemoveNum >= 0) {
        return firstRemoveNum;
    } else {
        return firstRemoveNum * (-1);
    }
}

-(int) getSecondRemovePositiveNum {
    if (secondRemoveNum >= 0) {
        return secondRemoveNum;
    } else {
        return secondRemoveNum * (-1);
    }
}

@end
