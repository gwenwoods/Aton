//
//  AtonArrangeCardsExecutor.h
//  AtonV1
//
//  Created by Wen Lin on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractExecutor.h"
#import "AtonAI.h"
#import "AtonGameManager.h"
#import "AtonMessageMaster.h"

@interface AtonArrangeCardsExecutor : AbstractExecutor{
    
    AtonGameParameters *para;
    AtonGameManager *gameManager;
    AtonAI *ai;
    BOOL useAI;
    
    AtonMessageMaster *messageMaster;
    
}

-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonmMessageMaster:(AtonAI*) atonAI;
-(int*) arrangeCard:(int*) inputCardArray;

@end
