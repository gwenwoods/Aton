//
//  AtonTouchMoveUtility.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchMoveUtility.h"

@implementation AtonTouchMoveUtility

+(void) playerArrangeCard:(UITouch*) touch:(AtonPlayer*) player {
    
    CGPoint touchLocation = [touch locationInView:nil];
    NSMutableArray *startCardIVArray = [player startCardIVArray];
    for (int i=0; i<4; i++) {
        UIImageView *iv = [startCardIVArray objectAtIndex:i];
        if([touch view] == iv) {
            iv.center = CGPointMake(touchLocation.y , 768-touchLocation.x);
            [[player baseView] bringSubviewToFront:iv];
        }
    }
}
@end
