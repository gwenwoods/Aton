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

static double PLACE_PEEP_TIME = 2.0;
static double REMOVE_PEEP_TIME = 2.0;

-(id)initializeWithParameters:(AtonGameParameters*)atonPara {
	if (self) {
        para = atonPara;
        templeArray = para.templeArray;
        audioToDeath = para.audioToDeath;
    }
    return self;
}

-(double) removePeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum {
    
    double animationTime = 0.0;
    if (removeNum < 0) {
        animationTime =[self removeOwnPeepsToDeathTemple:targetPlayerEnum:removeNum:maxTempleEnum];
    } else {
        animationTime =[self removeOpponentPeepsToDeathTemple:targetPlayerEnum:removeNum:maxTempleEnum];
    }
    return animationTime;
}

-(double) removeOwnPeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum  {
    
    if (removeNum == 0) {
        return 0;
    } else if (removeNum < 0) {
        removeNum = -1 * removeNum;
    }
    
    
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];

    //int removedCount = 0;
   for (int i=TEMPLE_1; i<= TEMPLE_4; i++) {
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
    
    for (int i=0; i < [selectedSlotArray count]; i++) {
        TempleSlot *slot = [selectedSlotArray objectAtIndex:i];
        [slot select];
    }
    [self performSelector:@selector(removeSelectedSlotsToDeathAndTempleFlame:) withObject:selectedSlotArray afterDelay:REMOVE_PEEP_TIME];

  //  [TempleUtility removePeepsToDeathTemple:templeArray:selectedSlotArray:audioToDeath];
  //  [TempleUtility disableTemplesFlame:templeArray];
    
    return REMOVE_PEEP_TIME;
}


-(double) removeOpponentPeepsToDeathTemple:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum  {
   // NSLog(@"target player Enum %d  %d  %d", targetPlayerEnum, removeNum, maxTempleEnum);
    
    if (removeNum == 0) {
        return 0;
    }
    
    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];
    for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:BLUE:removeNum:occupiedEnum];
        if ([selectedSlotArray count] == removeNum) {
            break;
        }
        selectedSlotArray = [TempleFunctionUtility addTempleColorSlotForRemove:temple:selectedSlotArray:GREY:removeNum:occupiedEnum];
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
    for (int i=0; i < [selectedSlotArray count]; i++) {
        TempleSlot *slot = [selectedSlotArray objectAtIndex:i];
        [slot select];
    }
  //  NSLog(@"removed count %d", [selectedSlotArray count]);
    
    [self performSelector:@selector(removeSelectedSlotsToDeathAndTempleFlame:) withObject:selectedSlotArray afterDelay:REMOVE_PEEP_TIME];
    
    //[TempleUtility removePeepsToDeathTemple:templeArray:selectedSlotArray:audioToDeath];
    //[TempleUtility disableTemplesFlame:templeArray];
    return  REMOVE_PEEP_TIME;
}


-(double) placePeeps:(int)targetPlayerEnum:(int)placeNum:(int) maxTempleEnum  {
    
    int secondPlayerEnum = para.atonRoundResult.secondPlayerEnum;
    BOOL isSecondPlayer = targetPlayerEnum == secondPlayerEnum;
    BOOL isDeathFull = [TempleUtility isDeathTempleFull:templeArray];
    
    
    [TempleUtility deselectAllTempleSlots:templeArray];

    int occupiedEnum = OCCUPIED_RED;
    if (targetPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
   
    NSMutableArray *selectedSlotArray = [[NSMutableArray alloc]init];
    
    //-------------------------
    // Place on BLUE and GREY square first
    for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        if (isDeathFull && isSecondPlayer && [temple wonByPlayer:targetPlayerEnum]) {
            continue;
        }
        
        [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:BLUE:placeNum];
        if ([selectedSlotArray count] >= placeNum) {
            break;
        }
        
        [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:GREY:placeNum];
        if ([selectedSlotArray count] >= placeNum) {
            break;
        }
    }
    
    if ([selectedSlotArray count] >= placeNum) {
        for (int i=0; i < [selectedSlotArray count]; i++) {
            TempleSlot *selectedSlot = [selectedSlotArray objectAtIndex:i];
            [selectedSlot select];
            [selectedSlot performSelector:@selector(placePeep1:) withObject:[NSNumber numberWithInt:occupiedEnum] afterDelay:PLACE_PEEP_TIME];
        }
        return PLACE_PEEP_TIME;
    }
    
    //--------------------------
    // Place on other colors
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    // peepDiff: Blue-Red
    
    AtonTemple *deathTemple = [templeArray objectAtIndex:0];
    int deathCount = [deathTemple findOccupiedSlotsNum]; 
    
    for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
        
         AtonTemple *temple = [templeArray objectAtIndex:i];
        
        if (isDeathFull && isSecondPlayer && [temple wonByPlayer:targetPlayerEnum]) {
            continue;
        }
        
        if (peepDiff[i] >= 3) {
            continue;
        } else if (deathCount == 7 && (peepDiff[i] + placeNum) < 0) {
            continue;
        }
        
        int startingCount = [selectedSlotArray count];
        startingCount+=0;
        int newPeepsCount = 0;
        
   /*     newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:GREY:placeNum];
        if ((startingCount + newPeepsCount) >= placeNum) {
            // NOTE: this should always be ==, not >=
            // BUT in case of time deplay problem,
            // we use >= to minimize the potential bugs
            break;
        } else if((peepDiff[i] + newPeepsCount) >= 3) {
            continue;
        }*/
        
        newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:ORANGE_2:placeNum];
        if ((startingCount + newPeepsCount) >= placeNum) {
            break;
        } else if((peepDiff[i] + newPeepsCount) >= 3) {
            continue;
        }

        newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:ORANGE_1:placeNum];
        if ((startingCount + newPeepsCount) >= placeNum) {
            break;
        } else if((peepDiff[i] + newPeepsCount) >= 3) {
            continue;
        }

        newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:YELLOW:placeNum];
        if ((startingCount + newPeepsCount) >= placeNum) {
            break;
        } else if((peepDiff[i] + newPeepsCount) >= 3) {
            continue;
        }

        newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:GREEN:placeNum];
        if ((startingCount + newPeepsCount) >= placeNum) {
            break;
        } else if((peepDiff[i] + newPeepsCount) >= 3) {
            continue;
        }
    }

    //-------------
    // if selected slot is not enough
    if ([selectedSlotArray count] < placeNum) {
        for (int i=maxTempleEnum; i>= TEMPLE_1; i--) {
            AtonTemple *temple = [templeArray objectAtIndex:i];
            
            int startingCount = [selectedSlotArray count];
            startingCount+=0;
            int newPeepsCount = 0;
            
            newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:GREY:placeNum];
            if ((startingCount + newPeepsCount) >= placeNum) {
                break;
            }
            
            newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:ORANGE_2:placeNum];
            if ((startingCount + newPeepsCount) >= placeNum) {
                break;
            } 
            
            newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:ORANGE_1:placeNum];
            if ((startingCount + newPeepsCount) >= placeNum) {
                break;
            }
            
            newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:YELLOW:placeNum];
            if ((startingCount + newPeepsCount) >= placeNum) {
                break;
            }
            
            
            newPeepsCount += [TempleFunctionUtility addTempleColorSlotForPlace1:temple:selectedSlotArray:GREEN:placeNum];
            if ((startingCount + newPeepsCount) >= placeNum) {
                break;
            } 
        }

    }
    
    for (int i=0; i < [selectedSlotArray count]; i++) {
        TempleSlot *selectedSlot = [selectedSlotArray objectAtIndex:i];
        [selectedSlot select];
        [selectedSlot performSelector:@selector(placePeep1:) withObject:[NSNumber numberWithInt:occupiedEnum] afterDelay:PLACE_PEEP_TIME];
    }
    
    return  PLACE_PEEP_TIME;
}

-(double) removeOnePeepFromEachTemple:(int) playerEnum {
    [TempleUtility enableActiveTemplesFlame:templeArray :playerEnum:TEMPLE_4];
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

    for (int i=0; i < [selectedSlotArray count]; i++) {
        TempleSlot *slot = [selectedSlotArray objectAtIndex:i];
        [slot select];
    }

    [self performSelector:@selector(removeSelectedSlotsAndTempleFlame:) withObject:selectedSlotArray afterDelay:REMOVE_PEEP_TIME];
   // int num = [selectedSlotArray count];
    
    //NSLog(@"Remove %d peeps", num);
    return REMOVE_PEEP_TIME;
}

-(void) removeSelectedSlotsAndTempleFlame:(NSMutableArray*) selectedSlotArray {
    [TempleUtility removePeepsToSupply:templeArray:selectedSlotArray];
    [TempleUtility disableTemplesFlame:templeArray];
    
}

-(void) removeSelectedSlotsToDeathAndTempleFlame:(NSMutableArray*) selectedSlotArray {
    [TempleUtility removePeepsToDeathTemple:templeArray:selectedSlotArray:audioToDeath];
    [TempleUtility disableTemplesFlame:templeArray];
    
}
@end
