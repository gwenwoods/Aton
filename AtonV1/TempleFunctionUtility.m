//
//  TempleFunctionUtility.m
//  AtonV1
//
//  Created by Wen Lin on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempleFunctionUtility.h"

@implementation TempleFunctionUtility

+(NSMutableArray*) addTempleColorSlotForPlace:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum {

    NSMutableArray *templeSlotArray = [temple slotArray];
    for (int j=0; j < 12; j++) {
        TempleSlot *slot = [templeSlotArray objectAtIndex:j];
        if (slot.colorTypeEnum == colorTypeEnum && slot.occupiedEnum == OCCUPIED_EMPTY) {
            [selectedSlotArray addObject:slot]; 
            [slot selectOrDeselectSlot];
            if ([selectedSlotArray count] == requiredSlotNum) {
                break;
            }
        }
    }

    return selectedSlotArray;
}

+(int) addTempleColorSlotForPlace1:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum {
    
    int count = 0;
    NSMutableArray *templeSlotArray = [temple slotArray];
    for (int j=0; j < 12; j++) {
        TempleSlot *slot = [templeSlotArray objectAtIndex:j];
        if (slot.colorTypeEnum == colorTypeEnum && slot.occupiedEnum == OCCUPIED_EMPTY) {
            [selectedSlotArray addObject:slot];
            if ([slot isSelected]) {
                continue;
            }
            [slot selectOrDeselectSlot];
            count++;
            if ([selectedSlotArray count] == requiredSlotNum) {
                break;
            }
        }
    }
    
    return count;
}

+(NSMutableArray*) addTempleColorSlotForRemove:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum:(int) occupiedEnum {
    
    NSMutableArray *templeSlotArray = [temple slotArray];
    for (int j=0; j < 12; j++) {
        TempleSlot *slot = [templeSlotArray objectAtIndex:j];
        if (slot.colorTypeEnum == colorTypeEnum && slot.occupiedEnum == occupiedEnum) {
            [selectedSlotArray addObject:slot]; 
            [slot selectOrDeselectSlot];
            if ([selectedSlotArray count] == requiredSlotNum) {
                break;
            }
        }
    }
    
    return selectedSlotArray;
}


@end
