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

-(id)initializeWithParameters:(NSMutableArray*) atonTempleArray:(AVAudioPlayer*) atonAudioToDeath {
	if (self) {
        templeArray = atonTempleArray;
        audioToDeath = atonAudioToDeath;
    }
    return self;
}

-(void) removePeeps:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum  {
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
@end
