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
        temple.iv.hidden = NO;
        NSMutableArray *templeSlotArray =
        [temple enableTempleSlotInteraction:occupiedEnum];
        [eligiableSlotArray  addObjectsFromArray:templeSlotArray];
    }
    return eligiableSlotArray;
}

+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray {
    
    for (int i=1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        temple.iv.hidden = YES;
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
            break;
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

+(void) removePeepsToSupply:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots {
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        [selectedSlot removePeep];
    }
    [TempleUtility disableAllTempleSlotInteraction:templeArray];
}

+(BOOL) isSelectedOneFromEachTemple:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots {
    
    NSMutableArray *requiredTempleEnumArray = [[NSMutableArray alloc] init];
    [requiredTempleEnumArray addObject:[NSNumber numberWithInt:TEMPLE_1]];
    [requiredTempleEnumArray addObject:[NSNumber numberWithInt:TEMPLE_2]];
    [requiredTempleEnumArray addObject:[NSNumber numberWithInt:TEMPLE_3]];
    [requiredTempleEnumArray addObject:[NSNumber numberWithInt:TEMPLE_4]];
    
  //  NSMutableArray *selectedTempleEnumArray = [[NSMutableArray alloc] init];
    if ([allSelectedSlots count] > 4) {
        return NO;
    } else {
        for (int i=0; i<[allSelectedSlots count]; i++) {
            TempleSlot *slot = [allSelectedSlots objectAtIndex:i];
            int slotTempleEnum = slot.templeEnum;
            NSNumber *stNumber = [NSNumber numberWithInt:slotTempleEnum];
            if ([requiredTempleEnumArray containsObject:stNumber] == NO) {
                return NO;
            } else {
                [requiredTempleEnumArray removeObject:stNumber];
            }
        }
    }
    return YES;
}

+(NSMutableArray*) computeAllTempleScore:(NSMutableArray*) templeArray {
    
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
    TempleScoreResult *result_temple4 = [TempleUtility computeScoreTemple4:templeArray];
    
    // compute Grey Bonus
    TempleScoreResult *result_greyBonus = [TempleUtility computeScoreGreyBonus:templeArray];
    
    // compute bonus score for red
    TempleScoreResult *result_orangeBonus_forRed = [TempleUtility computeScoreOrangeBonusForRed:templeArray];

    // compute bonus score for blue
    TempleScoreResult *result_orangeBonus_forBlue = [TempleUtility computeScoreOrangeBonusForBlue:templeArray];
    
    NSMutableArray *templeScoreArray = [[NSMutableArray alloc] init];
    [templeScoreArray addObject:result_temple1];
    [templeScoreArray addObject:result_temple2];
    [templeScoreArray addObject:result_temple3];
    [templeScoreArray addObject:result_temple4];
    [templeScoreArray addObject:result_greyBonus];
    [templeScoreArray addObject:result_orangeBonus_forRed];
    [templeScoreArray addObject:result_orangeBonus_forBlue];
    
    return templeScoreArray;
}

+(TempleScoreResult*) computeScoreTemple1:(AtonTemple*) temple {
    
    int redCount = 0;
    int blueCount = 0;
    for (int i=0; i<12; i++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:i];
        if ([slot occupiedEnum] == OCCUPIED_RED) {
            redCount++;
        } else if ([slot occupiedEnum] == OCCUPIED_BLUE) {
            blueCount++;
        }
    }
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Temple 1 ";
    
    if (redCount > blueCount) {
        result.winningPlayerEnum = PLAYER_RED;
        result.winningScore = redCount - blueCount;
    } else if(blueCount > redCount) {
        result.winningPlayerEnum = PLAYER_BLUE;
        result.winningScore = blueCount - redCount;
    } else {
        result.winningPlayerEnum = PLAYER_NONE;
    }
    
    return result;
}

+(TempleScoreResult*) computeScoreTemple2:(AtonTemple*) temple {
    
    int redCount = 0;
    int blueCount = 0;
    for (int i=0; i<12; i++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:i];
        if ([slot occupiedEnum] == OCCUPIED_RED) {
            redCount++;
        } else if ([slot occupiedEnum] == OCCUPIED_BLUE) {
            blueCount++;
        }
    }
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Temple 2 ";
    
    if (redCount > blueCount) {
        result.winningPlayerEnum = PLAYER_RED;
        result.winningScore = 5;
    } else if(blueCount > redCount) {
        result.winningPlayerEnum = PLAYER_BLUE;
        result.winningScore = 5;
    } else {
        result.winningPlayerEnum = PLAYER_NONE;
    }
    
    return result;
}

+(TempleScoreResult*) computeScoreTemple3:(AtonTemple*) temple {
    int redCount = 0;
    int blueCount = 0;
    for (int i=0; i<12; i++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:i];
        if ([slot occupiedEnum] == OCCUPIED_RED) {
            redCount++;
        } else if ([slot occupiedEnum] == OCCUPIED_BLUE) {
            blueCount++;
        }
    }
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Temple 3 ";
    
    if (redCount > blueCount) {
        result.winningPlayerEnum = PLAYER_RED;
        result.winningScore = redCount;
    } else if(blueCount > redCount) {
        result.winningPlayerEnum = PLAYER_BLUE;
        result.winningScore = blueCount;
    } else {
        result.winningPlayerEnum = PLAYER_NONE;
    }
    
    return result;

}

+(TempleScoreResult*) computeScoreTemple4:(NSMutableArray*) templeArray {
    
    AtonTemple *temple4 = [templeArray objectAtIndex:TEMPLE_4];
    int redCount = 0;
    int blueCount = 0;
    for (int i=0; i<12; i++) {
        TempleSlot *slot = [[temple4 slotArray] objectAtIndex:i];
        if ([slot occupiedEnum] == OCCUPIED_RED) {
            redCount++;
        } else if ([slot occupiedEnum] == OCCUPIED_BLUE) {
            blueCount++;
        }
    }
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Temple 4 ";
    
    if (redCount > blueCount) {
        result.winningPlayerEnum = PLAYER_RED;
        int occupiedBlueSlot = 0;
        for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
            AtonTemple *temple = [templeArray objectAtIndex:i];
            TempleSlot *blueSlot = [[temple slotArray] objectAtIndex:7];
            if ([blueSlot occupiedEnum]==OCCUPIED_RED) {
                occupiedBlueSlot ++;
            }
        }
        result.winningScore = occupiedBlueSlot * 3;
        
    } else if(blueCount > redCount) {
        result.winningPlayerEnum = PLAYER_BLUE;
        int occupiedBlueSlot = 0;
        for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
            AtonTemple *temple = [templeArray objectAtIndex:i];
            TempleSlot *blueSlot = [[temple slotArray] objectAtIndex:7];
            if ([blueSlot occupiedEnum]==OCCUPIED_BLUE) {
                occupiedBlueSlot ++;
            }
        }
        result.winningScore = occupiedBlueSlot * 3;
    } else {
        result.winningPlayerEnum = PLAYER_NONE;
    }
    
    return result;

}

+(TempleScoreResult*) computeScoreGreyBonus:(NSMutableArray*) templeArray {
    
    
    int redCount = 0;
    int blueCount = 0;
    
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            if ([slot colorTypeEnum] == GREY) {
                if ([slot occupiedEnum] == OCCUPIED_RED) {
                    redCount++;
                } else if ([slot occupiedEnum] == OCCUPIED_BLUE) {
                    blueCount++;
                }
            }
        }
    }
    
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Grey Bonus ";
    
    if (redCount > blueCount) {
        result.winningPlayerEnum = PLAYER_RED;
        result.winningScore = 8;
        
    } else if(blueCount > redCount) {
        result.winningPlayerEnum = PLAYER_BLUE;
        result.winningScore = 8;
        
    } else {
        result.winningPlayerEnum = PLAYER_NONE;
    }    
    return result;
}

+(TempleScoreResult*) computeScoreOrangeBonusForRed:(NSMutableArray*) templeArray {
    
   
    int points = 0;
    
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            if ([slot occupiedEnum] == OCCUPIED_RED) {
                if ([slot colorTypeEnum] == ORANGE_1) {
                    points ++;
                } else if ([slot colorTypeEnum] == ORANGE_2) {
                    points = points + 2;
                } 
            } 
        }
    }
    
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Orange Bonus For Red ";
    
    result.winningPlayerEnum = PLAYER_RED;
    result.winningScore = points;
    
    return result;
}

+(TempleScoreResult*) computeScoreOrangeBonusForBlue:(NSMutableArray*) templeArray {
    
    
    int points = 0;
    
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            if ([slot occupiedEnum] == OCCUPIED_BLUE) {
                if ([slot colorTypeEnum] == ORANGE_1) {
                    points ++;
                } else if ([slot colorTypeEnum] == ORANGE_2) {
                    points = points + 2;
                } 
            } 
        }
    }
    
    
    TempleScoreResult *result = [[TempleScoreResult alloc] init];
    result.resultName = @"Orange Bonus For Blue ";
    
    result.winningPlayerEnum = PLAYER_BLUE;
    result.winningScore = points;
    
    return result;
}

+(BOOL) isYellowFull:(NSMutableArray*) templeArray {
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            if ([slot colorTypeEnum] == YELLOW && [slot occupiedEnum] == OCCUPIED_EMPTY) {
                return NO;
               
            } 
        }
    }
    return YES;
}

+(BOOL) isGreenFull:(NSMutableArray*) templeArray {
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            if ([slot colorTypeEnum] == GREEN && [slot occupiedEnum] == OCCUPIED_EMPTY) {
                return NO;
                
            } 
        }
    }
    return YES;
}

+(BOOL) isTempleFull:(NSMutableArray*) templeArray:(int) templeEnum {

    AtonTemple *temple = [templeArray objectAtIndex:templeEnum];
    for (int j=0; j<12; j++) {
        TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
        if ([slot occupiedEnum] == OCCUPIED_EMPTY) {
            return NO;
                
        } 
    }
    
    return YES;
}

+(void) changeSlotBoundaryColor: (NSMutableArray*) templeArray:(int) playerEnum {
    
    UIColor *color = [UIColor redColor];
    
    if (playerEnum == PLAYER_BLUE) {
        color = [UIColor blueColor];
    }
    
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        for (int j=0; j<12; j++) {
            TempleSlot *slot = [[temple slotArray] objectAtIndex:j];
            [slot.boundaryIV.layer setBorderColor:color.CGColor];   
        }
    }
    
}

@end
