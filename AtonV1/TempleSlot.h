//
//  TempleSlot.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

enum COLOR_TYPE_ENUM {
 GREEN, YELLOW, ORANGE_1, ORANGE_2, GREY, BLUE   
};

enum OCCUPIED_ENUM {
    OCCUPIED_EMPTY, OCCUPIED_RED, OCCUPIED_BLUE
};

@interface TempleSlot : NSObject

-(id)initializeWithParameters:(int) templeEnum: (int) thisSlotID:(CGPoint) templeOrigin:(UIView*) atonBaseView;
-(void) removePeep;
-(void) removePeepWithAnimation;
-(void) placePeep:(int) occuEnum;
-(void) placePeep1:(NSNumber*) occuEnum;
-(void) selectOrDeselectSlot;
-(void) select;
-(CGRect) getPeepFrame;

@property(strong, nonatomic) UIView* baseView;
@property(nonatomic) int templeEnum;
@property(nonatomic) CGPoint origin;
@property(nonatomic) int slotID, colorTypeEnum, occupiedEnum;
@property(strong, nonatomic) UIImageView *iv, *peepIV, *boundaryIV;
@property(nonatomic) BOOL isSelected;

@end
