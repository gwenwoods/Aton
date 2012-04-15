//
//  AtonTouchBeganUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchBeganUtility.h"

@implementation AtonTouchBeganUtility

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

@end
