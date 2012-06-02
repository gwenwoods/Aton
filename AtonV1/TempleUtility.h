//
//  TempleUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AtonTemple.h"
#import "TempleScoreResult.h"
#import "AtonPlayer.h"
#import "AtonMessageMaster.h"


@interface TempleUtility : NSObject

+(void) deselectAllTempleSlots:(NSMutableArray*) templeArray;
+(void) enableEligibleTempleSlotInteraction:(NSMutableArray*) templeArray:(int) maxTemple: (int) occupiedEnum;
+(void) disableAllTempleSlotInteraction:(NSMutableArray*) templeArray;
+(void) disableAllTempleSlotInteractionAndFlame:(NSMutableArray*) templeArray;
+(TempleSlot*) findSelectedSlot:(NSMutableArray*) templeArray;
+(NSMutableArray*) findAllSelectedSlots:(NSMutableArray*) templeArray;
+(TempleSlot*) findFirstAvailableDeathSpot:(NSMutableArray*) templeArray;
+(BOOL) isDeathTempleFull:(NSMutableArray*) templeArray;
+(void) clearDeathTemple:(NSMutableArray*) templeArray;
+(double) removePeepsToDeathTemple:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots:(AVAudioPlayer*) audioToDeath;
+(void) removePeepsToSupply:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots;
+(BOOL) isSelectedOneFromEachTemple:(NSMutableArray*) templeArray:(NSMutableArray*) allSelectedSlots;
+(NSMutableArray*) computeAllTempleScore:(NSMutableArray*) templeArray;
+(int) findPeepNumInTemple:(AtonTemple*) temple: (int) occupiedEnum;

+(int) findTempleFullWinner:(NSMutableArray*) templeArray:(int) templeEnum;
+(int) findColorFullWinner:(NSMutableArray*) templeArray:(int) targetColorEnum;

+(void) enableActiveTemplesFlame: (NSMutableArray*) templeArray:(int) playerEnum:(int) maxTempleEnum;
+(void) disableTemplesFlame: (NSMutableArray*) templeArray;
+(NSMutableArray*) findEligibleTempleSlots:(NSMutableArray*) templeArray:(int) maxTemple: (int) occupiedEnum;
+(int*) findPeepDiffEachTemple: (NSMutableArray*) templeArray;
+(int) findGreyBlueNumBeforeTempleForPlayer:(NSMutableArray*) templeArray:(int) maxTemple:(int) playerEnum;

@end
