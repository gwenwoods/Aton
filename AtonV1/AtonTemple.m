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
static int DEATH_WIDTH = 59;

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
    } else {
        for (int i=0; i<8;i++) {
            CGPoint slotOrigin = CGPointMake(origin.x + i * DEATH_WIDTH, origin.y);
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
        slot.isSelected = NO;
    }
}

-(NSMutableArray*) enableTempleSlotInteraction:(int) occupiedEnum {

    NSMutableArray *eligiableSlotArray = [[NSMutableArray alloc]init];
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        if (slot.occupiedEnum == occupiedEnum ) {
            slot.iv.userInteractionEnabled = YES;
            [eligiableSlotArray addObject:slot];
        }
    }
    return  eligiableSlotArray;
}

-(void) disableTempleSlotInteraction {
    
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        slot.iv.userInteractionEnabled = NO;
        slot.boundaryIV.hidden = YES;
    }
}

-(TempleSlot*) findSelectedSlot {
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        if ([slot isSelected]) {
            return slot;
        }
    }
    return nil;
}
@end
