//
//  TempleUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTemple.h"
#import "TempleScoreResult.h"
#import "AtonPlayer.h"

@interface TempleUtility : NSObject

+(void) deselectAllTempleSlots:(NSMutableArray*) templeArray;
+(NSMutableArray*) enableEligibleTempleSlotInteraction:(NSMutableArray*) templeArray:(int) maxTemple: (int) occupiedEnum;
+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray;
+(TempleSlot*) findSelectedSlot:(NSMutableArray*) templeArray;
+(NSMutableArray*) findAllSelectedSlots:(NSMutableArray*) templeArray;
+(TempleSlot*) findFirstAvailableDeathSpot:(NSMutableArray*) templeArray;
+(BOOL) isDeathTempleFull:(NSMutableArray*) templeArray;
+(void) clearDeathTemple:(NSMutableArray*) templeArray;
+(void) removePeepsToDeathTemple:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots;

+(NSMutableArray*) computeAllTempleScore:(NSMutableArray*) templeArray;

+(BOOL) isYellowFull:(NSMutableArray*) templeArray;
+(BOOL) isGreenFull:(NSMutableArray*) templeArray;
+(BOOL) isTempleFull:(NSMutableArray*) templeArray:(int) templeEnum;

//+(TempleScoreResult*) computeScoreTemple1:(AtonTemple*) temple;
//+(TempleScoreResult*) computeScoreTemple2:(AtonTemple*) temple;
//+(TempleScoreResult*) computeScoreTemple3:(AtonTemple*) temple;
//+(TempleScoreResult*) computeScoreTemple4:(NSMutableArray*) templeArray;
@end
