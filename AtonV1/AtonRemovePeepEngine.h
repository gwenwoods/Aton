//
//  AtonRemovePeepEngine.h
//  AtonV1
//
//  Created by Wen Lin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"
#import "AtonAI.h"
#import "AtonMessageMaster.h"

@interface AtonRemovePeepEngine : NSObject{
    
    AtonGameParameters *para;
    AtonAI *ai;
    BOOL useAI;
    
    AtonMessageMaster *messageMaster;
    
}
-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonmMessageMaster:(AtonAI*) atonAI;
-(void) removePeep:(int) gamePhaseEnum;

@end
