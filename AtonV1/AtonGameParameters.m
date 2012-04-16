//
//  AtonGameParameters.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameParameters.h"

@implementation AtonGameParameters

@synthesize playerArray, templeArray;

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray {
    
    if (self) {
        playerArray = atonPlayerArray;
        templeArray = atonTempleArray;
    }
    return self;
}

@end
