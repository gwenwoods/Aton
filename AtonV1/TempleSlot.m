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
static int PEEP_SIZE = 40;
static int BOUNDARY_SIZE = 56;

@synthesize baseView;
@synthesize templeEnum;
@synthesize origin;
@synthesize slotID, colorTypeEnum, occupiedEnum;
@synthesize iv, peepIV, boundaryIV;
@synthesize isSelected;

-(id)initializeWithParameters:(int) thisTempleEnum:(int) thisSlotID:(CGPoint) templeOrigin:(UIView*) atonBaseView {
    if (self) {
        baseView = atonBaseView;
        templeEnum = thisTempleEnum;
        slotID = thisSlotID;
        
        int slotOriginX = templeOrigin.x;
        int slotOriginY = templeOrigin.y;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(slotOriginX, slotOriginY, SLOT_WIDTH, SLOT_HEIGHT)];
        peepIV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, PEEP_SIZE, PEEP_SIZE)];
       
        boundaryIV = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -4, BOUNDARY_SIZE, BOUNDARY_SIZE)];
        [iv addSubview:boundaryIV];
        [iv addSubview:peepIV];
        
      //  [iv setBackgroundColor:[UIColor blueColor]];
        [boundaryIV.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [boundaryIV.layer setBorderWidth: 4.0];
        boundaryIV.hidden = YES;
      //  [peepIV setBackgroundColor:[UIColor redColor]];
      //  iv.alpha = 0.5;

        [baseView addSubview:iv];
    }
    return self;
}

-(void) removePeepWithAnimation {
   // peepIV.image = nil;
    occupiedEnum = OCCUPIED_EMPTY;
    isSelected = NO;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         peepIV.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         peepIV.image = nil;
                         peepIV.alpha = 1.0;                         }];

}

-(void) removePeep {
    peepIV.image = nil;
    occupiedEnum = OCCUPIED_EMPTY;
    isSelected = NO;
}

-(void) placePeep:(int) occuEnum {
    peepIV.image = nil;
    occupiedEnum = occuEnum;
    if (occupiedEnum == OCCUPIED_RED) {
        peepIV.image =  [UIImage imageNamed:@"Red_Disc.png"];
    } else if (occupiedEnum == OCCUPIED_BLUE) {
        peepIV.image =  [UIImage imageNamed:@"Blue_Disc.png"];
    } 
    isSelected = NO;
}

-(void) placePeep1:(NSNumber*) occuEnum {
    peepIV.image = nil;
    occupiedEnum = occuEnum.intValue;
    if (occupiedEnum == OCCUPIED_RED) {
        peepIV.image =  [UIImage imageNamed:@"Red_Disc.png"];
    } else if (occupiedEnum == OCCUPIED_BLUE) {
        peepIV.image =  [UIImage imageNamed:@"Blue_Disc.png"];
    } 
    isSelected = NO;
}

-(CGRect) getPeepFrame {
    CGPoint ivOrigin = iv.frame.origin;
    CGRect rect = CGRectMake(ivOrigin.x + 4, ivOrigin.y + 4, PEEP_SIZE, PEEP_SIZE);
    return rect;
}

-(void) selectOrDeselectSlot {
    if (isSelected) {
        isSelected = NO;
        boundaryIV.hidden = YES;
    } else {
        isSelected = YES;
        boundaryIV.hidden = NO;
    }
}
@end
