//
//  TempleUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempleUtility.h"

@implementation TempleUtility

+(void) deselectAllTempleSlots:(NSMutableArray*) templeArray {
    // only for temple 1 - temple 4
    for (int i=1; i< [templeArray count]; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        [temple deselectAllSlots];
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
        [eligiableSlotArray  addObjectsFromArray:templeSlotArray];
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

+(NSMutableArray*) findAllSelectedSlots:(NSMutableArray*) templeArray {
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc] init];
    
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        [selectedSlotArray addObjectsFromArray:[temple findAllSelectedSlots]];
     /*   TempleSlot *slot = [temple findSelectedSlot];
        if(slot!=nil) {
            return slot;
        }*/
    }
    return selectedSlotArray;
}

+(TempleSlot*) findFirstAvailableDeathSpot:(NSMutableArray*) templeArray {
    AtonTemple *temple = [templeArray objectAtIndex:TEMPLE_DEATH];
    for (int i=0; i<8; i++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:i];
        if ([slot occupiedEnum] == OCCUPIED_EMPTY) {
            return slot;
        }
    }
    return nil;
}

+(BOOL) isDeathTempleFull:(NSMutableArray*) templeArray {
    AtonTemple *temple = [templeArray objectAtIndex:TEMPLE_DEATH];
    TempleSlot *slot = [[temple slotArray] objectAtIndex:7];
    if ([slot occupiedEnum]!=OCCUPIED_EMPTY) {
        return YES;
    } else {
        return NO;
    }
}

+(void) clearDeathTemple:(NSMutableArray*) templeArray {
    AtonTemple *temple = [templeArray objectAtIndex:TEMPLE_DEATH];
    for (int i=0; i<8; i++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:i];
        [slot removePeep];
    }
}

+(void) removePeepsToDeathTemple:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots {
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        TempleSlot *deathSlot = [TempleUtility findFirstAvailableDeathSpot:templeArray];
        if (deathSlot == nil) {
            [selectedSlot removePeep];
            return;
        }
        
        // create animation IV
        UIImageView *animationIV = [[UIImageView alloc] init];
        animationIV.frame = [selectedSlot getPeepFrame];
        animationIV.image = selectedSlot.peepIV.image;
        [selectedSlot.baseView addSubview:animationIV]; 
        [selectedSlot.baseView bringSubviewToFront:animationIV];
        
        [deathSlot placePeep:[selectedSlot occupiedEnum]];
        deathSlot.peepIV.alpha = 0.0;
        [selectedSlot removePeep];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             animationIV.frame = [deathSlot getPeepFrame];
                         } 
                         completion:^(BOOL finished){
                             [animationIV removeFromSuperview];
                             deathSlot.peepIV.alpha = 1.0;
                         }];

    }
    [TempleUtility disableAllTempleSlotInteraction:templeArray];
}
@end
