//
//  AtonAIEasy.m
//  AtonV1
//
//  Created by Wen Lin on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonAIEasy.h"

@implementation AtonAIEasy
@synthesize audioToDeath;

static double PLACE_PEEP_TIME = 1.5;
static double REMOVE_PEEP_TIME = 1.5;

-(id)initializeWithParameters:(NSMutableArray*) atonTempleArray:(AVAudioPlayer*) atonAudioToDeath {
	if (self) {
        templeArray = atonTempleArray;
        audioToDeath = atonAudioToDeath;
    }
    return self;
}

-(void) removePeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum {
    if (removeNum < 0) {
        [self removeOwnPeepsToDeathTemple:targetPlayerEnum:removeNum:maxTempleEnum];
    } else {
        [self removeOpponentPeepsToDeathTemple:targetPlayerEnum:removeNum:maxTempleEnum];
    }
}

-(void) removeOwnPeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum  {
    
    if (removeNum == 0) {
        return;
    } else if (removeNum < 0) {
        removeNum = -1 * removeNum;
    }
    
    
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];

    //int removedCount = 0;
   for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        NSMutableArray *templeSlotArray = [temple slotArray];
        for (int j=0; j < 12; j++) {
            TempleSlot *slot = [templeSlotArray objectAtIndex:j];
            if (slot.occupiedEnum == occupiedEnum) {
                [selectedSlotArray addObject:slot];
              //  removedCount ++;
                
                if ([selectedSlotArray count] == removeNum) {
                    break;
                }
            }
            
        }
        
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
    }
    
    [TempleUtility removePeepsToDeathTemple:templeArray:selectedSlotArray:audioToDeath];
}


-(void) removeOpponentPeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum  {
    
    if (removeNum == 0) {
        return;
    }
    
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];
    for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:GREY:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:BLUE:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:ORANGE_2:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:ORANGE_1:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:YELLOW:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:GREEN:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
    }
    
    [TempleUtility removePeepsToDeathTemple:templeArray:selectedSlotArray:audioToDeath];
    [TempleUtility disableActiveTemplesFlame:templeArray];
}


-(double) placePeeps:(int)targetPlayerEnum:(int)placeNum:(int) maxTempleEnum  {
  //  [TempleUtility disableAllTempleSlotInteraction:templeArray]; // Note --> this one diabled flame
    [TempleUtility deselectAllTempleSlots:templeArray];
  //  [TempleUtility changeSlotBoundaryColor:templeArray:targetPlayerEnum];
  //  AtonTemple *tem = [templeArray objectAtIndex:0];
  //  tem.iv.hidden = NO;
  //  [tem enableTempleFlame:PLAYER_BLUE];
    
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];
    for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:GREY:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:BLUE:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:ORANGE_2:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:ORANGE_1:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:YELLOW:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForPlace:temple:selectedSlotArray:GREEN:placeNum];
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
    }
    //int removedCount = 0;
 /*   for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        NSMutableArray *templeSlotArray = [temple slotArray];
        for (int j=0; j < 12; j++) {
            TempleSlot *slot = [templeSlotArray objectAtIndex:j];
            if (slot.occupiedEnum == OCCUPIED_EMPTY) {
                [selectedSlotArray addObject:slot];
                [slot selectOrDeselectSlot];
                
                if ([selectedSlotArray count] == placeNum) {
                    break;
                }
            }
        }
        
        if ([selectedSlotArray count] == placeNum) {
            break;
        }
    }*/
    
    for (int i=0; i < [selectedSlotArray count]; i++) {
        TempleSlot *selectedSlot = [selectedSlotArray objectAtIndex:i];
       // [selectedSlot placePeep:occupiedEnum];
        [selectedSlot performSelector:@selector(placePeep1:) withObject:[NSNumber numberWithInt:occupiedEnum] afterDelay:PLACE_PEEP_TIME];
    }

    
   // [self performSelector:@selector(placePeepsAnimation) withObject:nil afterDelay:PLACE_PEEP_TIME];
    
    return  PLACE_PEEP_TIME;
}

-(double) removeOnePeepFromEachTemple:(int) playerEnum {
    int occupiedEnum = OCCUPIED_RED;
    if (playerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    int* templePeepArray = malloc(sizeof(int) * 5);
    int* templeNeedRemoveCountArray = malloc(sizeof(int) * 5);
    int* templeSelectedCountArray = malloc(sizeof(int) * 5);
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        templeNeedRemoveCountArray[i] = 0;
        templeSelectedCountArray[i] = 0;
    }
    NSMutableArray *requiredTempleEnumArray = [[NSMutableArray alloc] init];
    
    int nonEmptyTempleCount=0;
    for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        templePeepArray[i] = [TempleUtility findPeepNumInTemple:temple:occupiedEnum];
        if (templePeepArray[i]>0) {
            [requiredTempleEnumArray addObject:[NSNumber numberWithInt:i]];
            templeNeedRemoveCountArray[i] ++;
            nonEmptyTempleCount++;
            templePeepArray[i] --;
        }
    }
    
    if (nonEmptyTempleCount == 1) {
        int nonEmptyTempleEnum = [[requiredTempleEnumArray objectAtIndex:0]intValue];
        templeNeedRemoveCountArray[nonEmptyTempleEnum] = 4;
        
    } else if (nonEmptyTempleCount == 2 ) {
        int maxPeep = 0;
        int maxPeepTempleEnum = 0;
        for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
            int templePeep = templePeepArray[i];
            if (templePeep > maxPeep) {
                maxPeep = templePeep;
                maxPeepTempleEnum = i;
            }
        }
        templeNeedRemoveCountArray[maxPeepTempleEnum] ++;
        templePeepArray[maxPeepTempleEnum] --;
        
        //-------
        // repeat logic again
        maxPeep = 0;
        maxPeepTempleEnum = 0;
        for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
            int templePeep = templePeepArray[i];
            if (templePeep > maxPeep) {
                maxPeep = templePeep;
                maxPeepTempleEnum = i;
            }
        }
        templeNeedRemoveCountArray[maxPeepTempleEnum] ++;
        templePeepArray[maxPeepTempleEnum] --;
        
    }  else if (nonEmptyTempleCount == 3 ) {
        int maxPeep = 0;
        int maxPeepTempleEnum = 0;
        for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
            int templePeep = templePeepArray[i];
            if (templePeep > maxPeep) {
                maxPeep = templePeep;
                maxPeepTempleEnum = i;
            }
        }
        templeNeedRemoveCountArray[maxPeepTempleEnum] ++;
        templePeepArray[maxPeepTempleEnum] --;
        
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];
    for (int i=TEMPLE_1; i<=TEMPLE_4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        int needRemoveNum = templeNeedRemoveCountArray[i];
        if (needRemoveNum == 0) {
            continue;
        }
        NSMutableArray *templeSlotArray = [temple slotArray];
        int actualRemovedNumInTemple = 0;
        for (int j=0; j < 12; j++) {
            TempleSlot *slot = [templeSlotArray objectAtIndex:j];
            if (slot.occupiedEnum == occupiedEnum) {
                [selectedSlotArray addObject:slot];
                [slot selectOrDeselectSlot];
                actualRemovedNumInTemple ++;
                if (actualRemovedNumInTemple == needRemoveNum) {
                    break;
                }
            }
        }
    }

    [TempleUtility removePeepsToSupply:templeArray:selectedSlotArray];
    int num = [selectedSlotArray count];
    
    NSLog(@"Remove %d peeps", num);
    return REMOVE_PEEP_TIME;
}

@end
