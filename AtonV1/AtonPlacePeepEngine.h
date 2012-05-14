//
//  AtonPlacePeepEngine.h
//  AtonV1
//
//  Created by Wen Lin on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameParameters.h"
#import "AtonAI.h"
#import "AtonMessageMaster.h"

@interface AtonPlacePeepEngine : AtonAI {
    
    
    AtonGameParameters *para;
    AtonAI *ai;
    BOOL useAI;
    
    AtonMessageMaster *messageMaster;
    
}

-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonmMessageMaster:(AtonAI*) atonAI;
//-(void) placePeep;
-(void) placePeep:(int) gamePhaseEnum;
@end
