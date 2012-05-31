//
//  AtonMessageMaster.h
//  AtonV1
//
//  Created by Wen Lin on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"
#import "TempleScoreResult.h"

enum MESSAGE_ENUM {
    MSG_PLAYER_ARRANGE_CARD, MSG_COMPARE_RESULTS, MSG_TIE,
    MSG_NO_PEEP_TO_REMOVE, MSG_ALL_PEEPS_REMOVED,
    MSG_NO_SQUARE_TO_PLACE, MSG_ALL_SQUARE_FILLED,
    MSG_DEAD_KINGDOM_FULL, MSG_TURN_END, 
    
    MSG_NEW_ROUND_BEGIN
};

@interface AtonMessageMaster : NSObject {
}

-(id)initializeWithParameters:(AtonGameParameters*) parameter;
-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum;
-(NSString*) getMessageForTempleScoreResult:(TempleScoreResult*) result;
-(NSString*) getMessageForEnum:(int) msgEnum;

+(NSString*) getTempleScoreResultName:(int) resultEnum;

@property(strong, nonatomic) AtonGameParameters *para;

@end
