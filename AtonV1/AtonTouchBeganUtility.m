//
//  AtonTouchBeganUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchBeganUtility.h"

@implementation AtonTouchBeganUtility

+(void) checkTouch:(UIEvent *)event:(AtonTouchElement*) touchElement:(AtonGameParameters*) atonParameters {
    UITouch *touch = [[event allTouches] anyObject];
    NSMutableArray *playerArray = [atonParameters playerArray];
    NSMutableArray *templeArray = [atonParameters templeArray];
    [self playerArrangeCard:touch:touchElement:[playerArray objectAtIndex:0]];
    [self chooseTempleSlot:touch:templeArray];
}

+(void) playerArrangeCard:(UITouch*) touch:(AtonTouchElement*) touchElement: (AtonPlayer*) player {
    
    if ([touchElement fromIndex] > 0) {
        return;
    }
    
    NSMutableArray *cardElementArray = [player cardElementArray];    
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        if([touch view] == ce.iv) {
            
            // the card spot is empty
            if(ce.iv.image == nil) {
                return;
            }
            
            // if a card is available in the regular spot
            // take it to touch element
            CGPoint localLaction = [touch locationInView:ce.iv];
            [touchElement setLocalLaction:localLaction];
            [touchElement takeCardElement:ce];
            [ce taken];
            return;
        }
    }
    
    NSMutableArray *tempCardElementArray = [player tempCardElementArray];
    for (int i=0; i<[tempCardElementArray count]; i++) {
        CardElement *ce = [tempCardElementArray objectAtIndex:i];
        if([touch view] == ce.iv) {

            CGPoint localLaction = [touch locationInView:ce.iv];
            [touchElement setLocalLaction:localLaction];
            [touchElement takeCardElement:ce];
            
            [player releaseTempCardElement:ce];
            [[player baseView] bringSubviewToFront:[touchElement touchIV]];
            return;
        }
    }
}

+(void) chooseTempleSlot:(UITouch*) touch:(NSMutableArray*) templeArray {
    
    for (int i=0; i<4; i++) {
        AtonTemple *temple = [templeArray objectAtIndex:i];
        NSMutableArray *templeSlotArray = [temple slotArray];
        for (int i=0; i< [templeSlotArray count]; i++) {
            TempleSlot *slot = [templeSlotArray objectAtIndex:i];
            if([touch view] == [slot iv]) {
                [TempleUtility hideAllTempleSlotBoundary:templeArray];
                slot.boundaryIV.hidden = NO;
            }
        }
    }
}

@end
