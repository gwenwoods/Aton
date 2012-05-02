//
//  ScoreScarab.m
//  AtonV1
//
//  Created by Wen Lin on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreScarab.h"

@implementation ScoreScarab

float static CYLINDER_WIDTH = 40.0;
float static CYLINDER_HEIGHT = 50.0;

@synthesize scoreValue, occupiedEnum;
@synthesize iv, redIV, blueIV;
@synthesize redFrame, blueFrame;

-(id)initializeWithParameters:(int) score:(UIImageView*) imageView {
	if (self) {
        scoreValue = score;
        iv = imageView;
        redIV = [[UIImageView alloc] initWithFrame:CGRectMake(-4.0, -2.0, CYLINDER_WIDTH, CYLINDER_HEIGHT)];
        redIV.image = [UIImage imageNamed:@"Red_Cylinder.png"];
        redIV.hidden = YES;
                
        blueIV = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, -6.0, CYLINDER_WIDTH, CYLINDER_HEIGHT)];
        blueIV.image = [UIImage imageNamed:@"Blue_Cylinder.png"];
        blueIV.hidden = YES;
        
        [iv addSubview:blueIV];
        [iv addSubview:redIV];
        
        float cx = iv.center.x;
        float cy = iv.center.y;
        float w = iv.frame.size.width;
        float h = iv.frame.size.height;
        
        redFrame = CGRectMake(cx - 0.5* w - 4.0, cy-0.5*h-2.0, CYLINDER_WIDTH, CYLINDER_HEIGHT);
        blueFrame = CGRectMake(cx - 0.5* w + 6.0, cy-0.5*h-6.0, CYLINDER_WIDTH, CYLINDER_HEIGHT);
    }
    return self;
}


@end
