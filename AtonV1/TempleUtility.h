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

+(void) hideAllTempleSlotBoundary:(NSMutableArray*) templeArray;
+(void) enableEligibleTempleSlotInteraction:(NSMutableArray*) templeArray:(int) maxTemple: (int) playerEnum;
+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray;
+(TempleSlot*) findSelectedSlot:(NSMutableArray*) templeArray;

@end
