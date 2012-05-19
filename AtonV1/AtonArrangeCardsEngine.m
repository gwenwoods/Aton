//
//  AtonArrangeCardsEngine.m
//  AtonV1
//
//  Created by Wen Lin on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonArrangeCardsEngine.h"

@implementation AtonArrangeCardsEngine


-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para = atonParameter;
        messageMaster = atonMessageMaster;
        useAI = para.useAI;
        ai = atonAI;
    }
    return self;
}

-(int*) arrangeCard:(int*) inputCardArray {
    
    int* outputCardArray = malloc(sizeof(int)*4);
    outputCardArray[0] = 4;
    outputCardArray[1] = 4;
    outputCardArray[2] = 4;
    outputCardArray[3] = 4;
    return outputCardArray;
}
@end
