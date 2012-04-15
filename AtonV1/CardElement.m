//
//  CardElement.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardElement.h"

@implementation CardElement
@synthesize iv, number;
@synthesize locationIndex;

-(id)initializeWithParameters:(UIImageView*) imageView:(int) cardNumber:(int) index {
	if (self) {
        iv = imageView;
        number = cardNumber;
        locationIndex = index;
    }
    return self;
}

-(void) taken {
    iv.image = nil;
    number = 0;
}

@end
