//
//  AtonTouchEndUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchEndUtility.h"

@implementation AtonTouchEndUtility


+(void) playerPlaceCard:(UITouch*) touch:(AtonTouchElement*) touchElement: (AtonPlayer*) player {
    
    if ([touchElement cardIndex] < 0) {
        return;
    }
    
    NSMutableArray *startCardIVArray = [player startCardIVArray];
    for (int i=0; i<4; i++) {
        UIImageView *iv = [startCardIVArray objectAtIndex:i];
        if([self isWithinImgView:[touchElement touchIV]:iv]) {
            int currentNum = [player startCardNumArray][i];
            
            int fromIndex = touchElement.cardIndex;
            UIImageView *fromIV = [startCardIVArray objectAtIndex:fromIndex];
            fromIV.image = iv.image;
            [player startCardNumArray][fromIndex] = currentNum;
            
            iv.image = touchElement.touchIV.image;
            [player startCardNumArray][i] = [touchElement cardNum];
            
            [touchElement reset];
        }
    }
}

+(BOOL) isWithinImgView:(UIImageView*)iv0:(UIImageView*)iv1 {
	// check if iv0 is within iv1
	int x0 = iv0.center.x;
	int y0 = iv0.center.y;
	
	int x1 = iv1.center.x;
	int y1 = iv1.center.y;
	int w1 = [iv1 frame].size.width/2.0;
	int h1 = [iv1 frame].size.height/2.0;
	
	if ( (x0 > x1-w1) && (x0 < x1+w1) && (y0 > y1-h1) && (y0 < y1+h1) ) {
	    return YES;		
	}
	return NO;
}

@end
