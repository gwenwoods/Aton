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
    PLAYER_ARRANGE_CARD  
};

@interface AtonMessageMaster : NSObject {
}

-(id)initializeWithParameters:(AtonGameParameters*) parameter;
-(NSString*) getMessageBeforePhase:(int) gamePhaseEnum;
-(NSString*) getMessageForTempleScoreResult:(TempleScoreResult*) result;
-(NSString*) getMessageForEnum:(int) msgEnum;

@property(strong, nonatomic) AtonGameParameters *para;

@end
