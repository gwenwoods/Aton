//
//  AtonPlacePeepExecutor.h
//  AtonV1
//
//  Created by Wen Lin on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractExecutor.h"
#import "AtonAI.h"
#import "AtonGameManager.h"
#import "AtonMessageMaster.h"

@interface AtonPlacePeepExecutor: AbstractExecutor {
    AtonGameParameters *para;
    AtonAI *ai;
    BOOL useAI;
    AtonGameManager *gameManager;
    AtonMessageMaster *messageMaster;    
}

-(id)initWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI;
-(void) placePeep:(int) gamePhaseEnum;
@end
