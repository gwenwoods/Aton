//
//  TempleFunctionUtility.h
//  AtonV1
//
//  Created by Wen Lin on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTemple.h"

@interface TempleFunctionUtility : NSObject

+(NSMutableArray*) addTempleColorSlotForPlace:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum;
+(NSMutableArray*) addTempleColorSlotForRemove:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum:(int) occupiedEnum;

+(int) addTempleColorSlotForPlace1:(AtonTemple*) temple:(NSMutableArray*) selectedSlotArray:(int) colorTypeEnum:(int) requiredSlotNum;
@end
