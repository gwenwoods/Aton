//
//  AtonArrangeCardsEngine.h
//  AtonV1
//
//  Created by Wen Lin on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractAtonEngine.h"
#import "AtonAI.h"
#import "AtonMessageMaster.h"

@interface AtonArrangeCardsEngine : AbstractAtonEngine{
    
    AtonGameParameters *para;
    AtonAI *ai;
    BOOL useAI;
    
    AtonMessageMaster *messageMaster;
    
}

-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonmMessageMaster:(AtonAI*) atonAI;
-(int*) arrangeCard:(int*) inputCardArray;

@end
