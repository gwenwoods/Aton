//
//  CardElement.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardElement.h"

@implementation CardElement
@synthesize iv, subIV, number;
@synthesize locationIndex;

-(id)initializeWithParameters:(UIImageView*) imageView:(int) cardNumber:(int) index {
	if (self) {
        iv = imageView;
        number = cardNumber;
        locationIndex = index;
        if (locationIndex < 5) {
            subIV = [[UIImageView alloc]initWithFrame:CGRectMake(8,12, 72, 108)];
            [iv addSubview:subIV];
            [subIV.layer setBorderColor: [[UIColor whiteColor] CGColor]];
            [subIV.layer setBorderWidth: 2.0];
            subIV.hidden = YES;
        }
    }
    return self;
}

-(void) taken {
    if (subIV != nil) {
        subIV.hidden = NO;
    }
    iv.image = nil;
    number = 0;
}

@end
