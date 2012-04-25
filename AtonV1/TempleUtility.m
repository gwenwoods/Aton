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

+(TempleScoreResult*) computeAllTempleScore:(NSMutableArray*) templeArray {
    
    // compute Temple_1 score
    AtonTemple *temple1 = [templeArray objectAtIndex:TEMPLE_1];
    TempleScoreResult *result_temple1 = [TempleUtility computeScoreTemple1:temple1];
    
    // compute Temple_2 score
    AtonTemple *temple2 = [templeArray objectAtIndex:TEMPLE_2];
    TempleScoreResult *result_temple2 = [TempleUtility computeScoreTemple2:temple2];
    
    // compute Temple_3 score
    AtonTemple *temple3 = [templeArray objectAtIndex:TEMPLE_3];
    TempleScoreResult *result_temple3 = [TempleUtility computeScoreTemple3:temple3];
    
    // compute Temple_4 score
    AtonTemple *temple4 = [templeArray objectAtIndex:TEMPLE_4];
    TempleScoreResult *result_temple4 = [TempleUtility computeScoreTemple4:templeArray];
    
    TempleScoreResult* totalTempleScore = [[TempleScoreResult alloc] init];
    totalTempleScore.winningPlayerEnum = PLAYER_RED;
    totalTempleScore.winningScore = 12;
}

+(TempleScoreResult*) computeScoreTemple1:(AtonTemple*) temple {
    
}

+(TempleScoreResult*) computeScoreTemple2:(AtonTemple*) temple {
    
}

+(TempleScoreResult*) computeScoreTemple3:(AtonTemple*) temple {
    
}

+(TempleScoreResult*) computeScoreTemple4:(NSMutableArray*) templeArray {
    
}


@end
