//
//  AtonTouchElement.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonTouchElement.h"

@implementation AtonTouchElement

@synthesize baseView;
@synthesize touchIV, cardNum, fromIndex;
@synthesize localLaction;

-(id)initializeWithParameters:(UIViewController*) controller {
    if (self) {
        baseView = controller.view;
        touchIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 134)];
        [baseView addSubview:touchIV];
        [baseView bringSubviewToFront:touchIV];
        fromIndex = -1;
    }
    return self;
}

-(void) takeCardElement:(CardElement*) ce {
    
    touchIV.center = ce.iv.center;
    touchIV.image = ce.iv.image;
    cardNum = ce.number;
    fromIndex = ce.locationIndex;
    [baseView bringSubviewToFront:touchIV];
}

-(void) reset {
    touchIV.image = nil;
    cardNum = 0;
    fromIndex = -1;
}


@end
