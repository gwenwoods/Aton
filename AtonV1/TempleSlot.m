//
//  TempleSlot.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempleSlot.h"

@implementation TempleSlot

static int SLOT_WIDTH = 48;
static int SLOT_HEIGHT = 48;
static int PEEP_SIZE = 32;
static int BOUNDARY_SIZE = 56;

@synthesize baseView;
@synthesize origin;
@synthesize slotID, colorTypeEnum, occupiedEnum;
@synthesize iv, peepIV, boundaryIV;

-(id)initializeWithParameters:(int) thisSlotID:(CGPoint) templeOrigin:(UIView*) atonBaseView {
    if (self) {
        baseView = atonBaseView;
        
        int slotOriginX = templeOrigin.x;
        int slotOriginY = templeOrigin.y;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(slotOriginX, slotOriginY, SLOT_WIDTH, SLOT_HEIGHT)];
        peepIV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, PEEP_SIZE, PEEP_SIZE)];
        boundaryIV = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -4, BOUNDARY_SIZE, BOUNDARY_SIZE)];
        
        [iv addSubview:boundaryIV];
        [iv addSubview:peepIV];
        
        [iv setBackgroundColor:[UIColor blueColor]];
        [boundaryIV.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [boundaryIV.layer setBorderWidth: 2.0];
        [peepIV setBackgroundColor:[UIColor redColor]];
        iv.alpha = 0.5;

        [baseView addSubview:iv];
    }
    return self;
}


@end
