//
//  AtonTemple.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTemple.h"


@implementation AtonTemple

static int SPACE_WIDTH = 53;
static int SPACE_HEIGHT = 53;
static int DEATH_WIDTH = 59;
static int TEMPLE_WIDTH = 264;
static int TEMPLE_HEIGHT = 300;


static int colorEnumArray_temple1[12] = {YELLOW, YELLOW, YELLOW, YELLOW, GREY, GREY, ORANGE_1, BLUE, GREEN, GREEN, GREEN, GREEN};
static int colorEnumArray_temple2[12] = {YELLOW, YELLOW, YELLOW, YELLOW, GREY, GREY, ORANGE_1, BLUE, GREEN, GREEN, GREEN, GREEN};
static int colorEnumArray_temple3[12] = {YELLOW, YELLOW, YELLOW, ORANGE_1, GREY, GREY, GREY, BLUE, GREEN, GREEN, GREEN, ORANGE_1};
static int colorEnumArray_temple4[12] = {YELLOW, YELLOW, YELLOW, ORANGE_2, GREY, GREY, GREY, BLUE, GREEN, GREEN, GREEN, ORANGE_2};

@synthesize baseView, iv;
@synthesize templeEnum;
@synthesize origin, slotArray;

-(id)initializeWithParameters:(int) thisTempleId:(CGPoint) templeOrigin:(UIView*) atonBaseView {
    if (self) {
        templeEnum = thisTempleId;
        origin = templeOrigin;
        baseView = atonBaseView;
        
        if (templeEnum != TEMPLE_DEATH) {
            iv = [[UIImageView alloc] initWithFrame:CGRectMake(origin.x-30, origin.y-90, TEMPLE_WIDTH, TEMPLE_HEIGHT)];
            [baseView addSubview:iv];

           // [iv.layer setBorderWidth: 6.0];
            iv.hidden = YES;    
            NSArray *myImages;
            if (templeEnum == TEMPLE_1) {
                myImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Redflame1.png"],
                            [UIImage imageNamed:@"Redflame2.png"],
                            [UIImage imageNamed:@"Redflame3.png"],
                            [UIImage imageNamed:@"Redflame4.png"],
                            [UIImage imageNamed:@"Redflame5.png"],
                            [UIImage imageNamed:@"Redflame6.png"],
                            [UIImage imageNamed:@"Redflame7.png"],
                            [UIImage imageNamed:@"Redflame8.png"],
                            [UIImage imageNamed:@"Redflame9.png"],
                            [UIImage imageNamed:@"Redflame10.png"],
                            [UIImage imageNamed:@"Redflame11.png"],
                            [UIImage imageNamed:@"Redflame12.png"],
                            [UIImage imageNamed:@"Redflame13.png"],
                            [UIImage imageNamed:@"Redflame14.png"],
                            nil];
            } else if (templeEnum == TEMPLE_2) {
                myImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Redflame5.png"],
                            [UIImage imageNamed:@"Redflame6.png"],
                            [UIImage imageNamed:@"Redflame7.png"],
                            [UIImage imageNamed:@"Redflame8.png"],
                            [UIImage imageNamed:@"Redflame9.png"],
                            [UIImage imageNamed:@"Redflame10.png"],
                            [UIImage imageNamed:@"Redflame11.png"],
                            [UIImage imageNamed:@"Redflame12.png"],
                            [UIImage imageNamed:@"Redflame13.png"],
                            [UIImage imageNamed:@"Redflame14.png"],
                            [UIImage imageNamed:@"Redflame1.png"],
                            [UIImage imageNamed:@"Redflame2.png"],
                            [UIImage imageNamed:@"Redflame3.png"],
                            [UIImage imageNamed:@"Redflame4.png"],
                            nil];

            } else if (templeEnum == TEMPLE_3) {
                myImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Redflame9.png"],
                            [UIImage imageNamed:@"Redflame10.png"],
                            [UIImage imageNamed:@"Redflame11.png"],
                            [UIImage imageNamed:@"Redflame12.png"],
                            [UIImage imageNamed:@"Redflame13.png"],
                            [UIImage imageNamed:@"Redflame14.png"],
                            [UIImage imageNamed:@"Redflame1.png"],
                            [UIImage imageNamed:@"Redflame2.png"],
                            [UIImage imageNamed:@"Redflame3.png"],
                            [UIImage imageNamed:@"Redflame4.png"],
                            [UIImage imageNamed:@"Redflame5.png"],
                            [UIImage imageNamed:@"Redflame6.png"],
                            [UIImage imageNamed:@"Redflame7.png"],
                            [UIImage imageNamed:@"Redflame8.png"],
                            nil];
                
            } else if (templeEnum == TEMPLE_4) {
                myImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Redflame13.png"],
                            [UIImage imageNamed:@"Redflame14.png"],
                            [UIImage imageNamed:@"Redflame1.png"],
                            [UIImage imageNamed:@"Redflame2.png"],
                            [UIImage imageNamed:@"Redflame3.png"],
                            [UIImage imageNamed:@"Redflame4.png"],
                            [UIImage imageNamed:@"Redflame5.png"],
                            [UIImage imageNamed:@"Redflame6.png"],
                            [UIImage imageNamed:@"Redflame7.png"],
                            [UIImage imageNamed:@"Redflame8.png"],
                            [UIImage imageNamed:@"Redflame9.png"],
                            [UIImage imageNamed:@"Redflame10.png"],
                            [UIImage imageNamed:@"Redflame11.png"],
                            [UIImage imageNamed:@"Redflame12.png"],
                            nil];
                
            }
            
            UIImageView *handleAnimationIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,TEMPLE_WIDTH,TEMPLE_HEIGHT)];
            handleAnimationIV.alpha = 1.0;
            handleAnimationIV.animationImages = myImages;
            handleAnimationIV.animationDuration = 2.8; // seconds
            handleAnimationIV.animationRepeatCount = 0; // 0 = loops forever
            [handleAnimationIV startAnimating];
            [iv addSubview:handleAnimationIV];
        }
        
        [self initializeTempleSlotArray];
    }
    return self;
}

-(void) initializeTempleSlotArray {
    
    slotArray = [[NSMutableArray alloc] init];
    if (templeEnum > TEMPLE_DEATH) {
        for (int i=0; i<12;i++) {
            CGPoint slotOrigin = [self getOriginInNormalTempForSlot:i];
            TempleSlot *slot = [[TempleSlot alloc] initializeWithParameters:templeEnum:i:slotOrigin:baseView];
            [slotArray addObject:slot];
        }
        
        [self assignSlotColor];
    } else {
        for (int i=0; i<8;i++) {
            CGPoint slotOrigin = CGPointMake(origin.x + i * DEATH_WIDTH, origin.y);
            TempleSlot *slot = [[TempleSlot alloc] initializeWithParameters:templeEnum:i:slotOrigin:baseView];
            [slotArray addObject:slot];
        }
    }
}

-(CGPoint) getOriginInNormalTempForSlot:(int) slotID {
    
    int dx = (slotID % 4) * SPACE_WIDTH;
    int dy = 0;
    if (slotID >= 4 && slotID <=7) {
        dy = SPACE_HEIGHT;
    } else if(slotID >=8) {
        dy = SPACE_HEIGHT * 2;
    }
    
    return CGPointMake(origin.x + dx, origin.y + dy);
}


-(void) deselectAllSlots {
    // only for temple 1 - 4
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        slot.boundaryIV.hidden = YES;
        slot.isSelected = NO;
    }
}

-(NSMutableArray*) enableTempleSlotInteraction:(int) occupiedEnum {

    NSMutableArray *eligiableSlotArray = [[NSMutableArray alloc]init];
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        if (slot.occupiedEnum == occupiedEnum ) {
            slot.iv.userInteractionEnabled = YES;
            [eligiableSlotArray addObject:slot];
        }
    }
    return  eligiableSlotArray;
}

-(void) disableTempleSlotInteraction {
    
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        slot.iv.userInteractionEnabled = NO;
        slot.boundaryIV.hidden = YES;
    }
}

-(TempleSlot*) findSelectedSlot {
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        if ([slot isSelected]) {
            return slot;
        }
    }
    return nil;
}

-(NSMutableArray*) findAllSelectedSlots {
    NSMutableArray *selectedSlotsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<12;i++) {
        TempleSlot *slot = [slotArray objectAtIndex:i];
        if ([slot isSelected]) {
            //return slot;
            [selectedSlotsArray addObject:slot];
        }
    }
    return selectedSlotsArray;
}

-(void) assignSlotColor {
    
    if (templeEnum == TEMPLE_1) {
        for (int i=0; i<12;i++) {
            TempleSlot *slot = [slotArray objectAtIndex:i];
            slot.colorTypeEnum = colorEnumArray_temple1[i];    
        }
        
    } else if (templeEnum == TEMPLE_2) {
        for (int i=0; i<12;i++) {
            TempleSlot *slot = [slotArray objectAtIndex:i];
            slot.colorTypeEnum = colorEnumArray_temple2[i];    
        }
        
    }  else if (templeEnum == TEMPLE_3) {
        for (int i=0; i<12;i++) {
            TempleSlot *slot = [slotArray objectAtIndex:i];
            slot.colorTypeEnum = colorEnumArray_temple3[i];    
        }
        
    } else if (templeEnum == TEMPLE_4) {
        for (int i=0; i<12;i++) {
            TempleSlot *slot = [slotArray objectAtIndex:i];
            slot.colorTypeEnum = colorEnumArray_temple4[i];    
        }
    }
}
@end
