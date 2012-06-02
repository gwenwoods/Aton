//
//  AnimationUtility.m
//  AtonV1
//
//  Created by Wen Lin on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationUtility.h"

@implementation AnimationUtility

+(void) fadeInIV:(UIImageView*)iv:(double) animationDuration {
    
    iv.alpha = 0.0;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         iv.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}
@end
