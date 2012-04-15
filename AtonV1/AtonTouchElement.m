//
//  AtonTouchElement.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchElement.h"

@implementation AtonTouchElement


@synthesize touchIV, cardNum, cardIndex;

-(id)initializeWithParameters:(UIViewController*) controller {
    
    if (self) {
        touchIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 134)];
        [controller.view addSubview:touchIV];
        [controller.view bringSubviewToFront:touchIV];
    }
    return self;
    
}

-(void) reset {
    
   // touchElementEnum = TOUCH_ELEMENT_NONE;
    touchIV.image = nil;
    cardNum = -1;
    cardIndex = -1;
}


@end
