//
//  LiteSlot.m
//  AtonV1
//
//  Created by Wen Lin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LiteSlot.h"

@implementation LiteSlot
@synthesize templeEnum, slotID;

-(id)initWithPara:(int) thisTempleEnum:(int) thisSlotID {
    if (self) {
        templeEnum = thisTempleEnum;
        slotID = thisSlotID;
    }
    return self;
}


@end
