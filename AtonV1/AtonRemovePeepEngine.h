//
//  AtonRemovePeepEngine.h
//  AtonV1
//
//  Created by Wen Lin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"
#import "AtonGameManager.h"
#import "AtonAI.h"
#import "AtonMessageMaster.h"

@interface AtonRemovePeepEngine : NSObject{
    
    AtonGameParameters *para;
    AtonGameManager *gameManager;
    AtonAI *ai;
    BOOL useAI;
    
    AtonMessageMaster *messageMaster;
    
}
-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI;
-(void) removePeep:(int) gamePhaseEnum;

@end
