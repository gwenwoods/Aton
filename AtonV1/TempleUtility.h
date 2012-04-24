//
//  TempleUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTemple.h"

@interface TempleUtility : NSObject

+(void) deselectAllTempleSlots:(NSMutableArray*) templeArray;
+(NSMutableArray*) enableEligibleTempleSlotInteraction:(NSMutableArray*) templeArray:(int) maxTemple: (int) occupiedEnum;
+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray;
+(TempleSlot*) findSelectedSlot:(NSMutableArray*) templeArray;
+(NSMutableArray*) findAllSelectedSlots:(NSMutableArray*) templeArray;
+(TempleSlot*) findFirstAvailableDeathSpot:(NSMutableArray*) templeArray;
+(BOOL) isDeathTempleFull:(NSMutableArray*) templeArray;
+(void) clearDeathTempleFull:(NSMutableArray*) templeArray;
@end
