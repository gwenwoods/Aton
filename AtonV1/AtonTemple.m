//
//  AtonTemple.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTemple.h"


@implementation AtonTemple

static int SPACE_WIDTH = 53;
static int SPACE_HEIGHT = 53;

@synthesize baseView;
@synthesize templeEnum;
@synthesize origin, slotArray;

-(id)initializeWithParameters:(int) thisTempleId:(CGPoint) templeOrigin:(UIView*) atonBaseView {
    if (self) {
        templeEnum = thisTempleId;
        origin = templeOrigin;
        baseView = atonBaseView;
        
        [self initializeTempleSlotArray];
    }
    return self;
}

-(void) initializeTempleSlotArray {
    
    if (templeEnum > TEMPLE_DEATH) {
        slotArray = [[NSMutableArray alloc] init];
        for (int i=0; i<12;i++) {
            CGPoint slotOrigin = [self getOriginInNormalTempForSlot:i];
            TempleSlot *slot = [[TempleSlot alloc] initializeWithParameters:i:slotOrigin:baseView];
            [slotArray addObject:slot];
        }
    }
}

-(CGPoint) getOriginInNormalTempForSlot:(int) slotID {
    
    int dx = (slotID % 4) * SPACE_WIDTH;
    int dy = 0;
    if (slotID >= 4 && slotID <=7) {
        dy = SPACE_HEIGHT;
    } else if(slotID >=8) {
        dy = SPACE_HEIGHT * 2;
    }
    
    return CGPointMake(origin.x + dx, origin.y + dy);
}

-(void) hideSlotBoundary {
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        slot.boundaryIV.hidden = YES;
    }
}

@end
