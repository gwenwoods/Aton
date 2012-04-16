//
//  AtonTouchMovedUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchMovedUtility.h"

@implementation AtonTouchMovedUtility


+(void) moveTouchElement:(UIEvent *)event:(AtonTouchElement*) touchElement:(UIView*) baseView {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:baseView];
    
    if ([self isWithinImgView:touchLocation:[touchElement touchIV]]) {
        CGPoint localLaction = [touchElement localLaction];
        UIImageView *tIV = [touchElement touchIV];
        int dx = (int)localLaction.x - (int)tIV.frame.size.width/2;
        int dy = (int)localLaction.y - (int)tIV.frame.size.height/2;
        tIV.center = CGPointMake(touchLocation.x -dx, touchLocation.y -dy);
    }
}

+(BOOL) isWithinImgView:(CGPoint) point:(UIImageView*)iv1 {
	// check if iv0 is within iv1
	int x0 = point.x;
	int y0 = point.y;
	
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
