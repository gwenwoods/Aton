//
//  TempleScoreResult.h
//  AtonV1
//
//  Created by Wen Lin on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"

@interface TempleScoreResult : NSObject

-(NSString*) getWinningMessage;

@property(nonatomic) int templeEnum;
@property(nonatomic) int winningPlayerEnum;
@property(nonatomic) int winningScore;

@end
