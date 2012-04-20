//
//  TempleUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempleUtility.h"

@implementation TempleUtility

+(void) hideAllTempleSlotBoundary:(NSMutableArray*) templeArray {
    
    for (int i=0; i< [templeArray count]; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        [temple hideSlotBoundary];
    }
}

+(NSMutableArray*) enableEligibleTempleSlotInteraction:(NSMutableArray*) templeArray:(int) maxTemple: (int) occupiedEnum {
    
    NSMutableArray *eligiableSlotArray = [[NSMutableArray alloc]init];
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        [temple disableTempleSlotInteraction];
    }
    
    for (int i=1; i<= maxTemple; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        NSMutableArray *templeSlotArray =
        [temple enableTempleSlotInteraction:occupiedEnum];
        [eligiableSlotArray addObjectsFromArray:templeSlotArray];
    }
    return eligiableSlotArray;
}

+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray {
    
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        [temple disableTempleSlotInteraction];
    }
}

+(TempleSlot*) findSelectedSlot:(NSMutableArray*) templeArray {
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        TempleSlot *slot = [temple findSelectedSlot];
        if(slot!=nil) {
            return slot;
        }
    }
    return nil;
}

@end
