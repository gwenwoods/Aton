//
//  ScoreScarab.m
//  AtonV1
//
//  Created by Wen Lin on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreScarab.h"

@implementation ScoreScarab
@synthesize scoreValue, occupiedEnum;
@synthesize iv, redIV, blueIV;

-(id)initializeWithParameters:(int) score:(UIImageView*) imageView {
	if (self) {
        iv = imageView;
        redIV = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -2, 40, 50)];
        redIV.image = [UIImage imageNamed:@"Red_Cylinder.png"];
        redIV.hidden = YES;
        
                
        blueIV = [[UIImageView alloc] initWithFrame:CGRectMake(6, -6, 40, 50)];
        blueIV.image = [UIImage imageNamed:@"Blue_Cylinder.png"];
        blueIV.hidden = YES;
        
        [iv addSubview:blueIV];
        [iv addSubview:redIV];
    }
    return self;
}


@end
