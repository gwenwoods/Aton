//
//  AtonAI.h
//  AtonV1
//
//  Created by Wen Lin on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"
#import "TempleUtility.h"

@interface AtonAI : NSObject

-(id)initializeWithParameters:(AtonGameParameters*)atonPara;
-(double) removePeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum ;
-(double) placePeeps:(int)targetPlayerEnum:(int)placeNum:(int) maxTempleEnum ;
-(double) removeOnePeepFromEachTemple:(int) playerEnum;

@end
