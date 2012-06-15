//
//  LiteSlot.m
//  AtonV1
//
//  Created by Wen Lin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LiteSlot.h"

@implementation LiteSlot
@synthesize templeEnum, slotId;

-(id)initWithPara:(NSNumber*) thisTempleEnum:(NSNumber*) thisSlotID {
    if (self) {
        templeEnum = thisTempleEnum;
        slotId = thisSlotID;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        templeEnum = [decoder decodeObjectForKey:@"templeEnum"];
        slotId  = [decoder decodeObjectForKey:@"slotId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:templeEnum forKey:@"templeEnum"];
    [encoder encodeObject:slotId forKey:@"slotId"]; 
}

@end
