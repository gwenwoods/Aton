//
//  AtonTemple.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/QuartzCore.h"
#import "TempleSlot.h"

enum TEMPLE_ENUM {
    TEMPLE_DEATH, TEMPLE_1, TEMPLE_2, TEMPLE_3, TEMPLE_4
};

@interface AtonTemple : NSObject {
    
}

-(id)initializeWithParameters:(int) thisTempleId:(CGPoint) templeOrigin:(UIView*) atonBaseView;
-(void) deselectAllSlots;
-(void) disableTempleSlotInteraction;
-(NSMutableArray*) enableTempleSlotInteraction:(int) occupiedEnum;
-(TempleSlot*) findSelectedSlot;
-(NSMutableArray*) findAllSelectedSlots;

@property(strong, nonatomic) UIView* baseView;
@property(strong, nonatomic) UIImageView* iv;
@property(nonatomic) int templeEnum;
@property(nonatomic) CGPoint origin;
@property(strong, nonatomic) NSMutableArray *slotArray;

@end
