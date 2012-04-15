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
    
    if ([touchElement touchElementEnum] != TOUCH_ELEMENT_NONE) {
        return;
    }
    
    NSMutableArray *startCardIVArray = [player startCardIVArray];
    
    for (int i=0; i<4; i++) {
        UIImageView *iv = [startCardIVArray objectAtIndex:i];
        if([touch view] == iv) {
            touchElement.touchIV.center = iv.center;
            touchElement.touchIV.image = iv.image;
            iv.image = nil;
            iv.alpha = 0.5;
            touchElement.touchElementEnum = i+1;
        }
    }
}

@end
