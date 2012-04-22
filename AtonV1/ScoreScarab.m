//
//  ScoreScarab.m
//  AtonV1
//
//  Created by Wen Lin on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreScarab.h"

@implementation ScoreScarab

int static CYLINDER_WIDTH = 40;
int static CYLINDER_HEIGHT = 50;

@synthesize scoreValue, occupiedEnum;
@synthesize iv, redIV, blueIV;
@synthesize redFrame, blueFrame;

-(id)initializeWithParameters:(int) score:(UIImageView*) imageView {
	if (self) {
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
        
        float cx_red = cx - 4.0;
        float cy_red = cy - 2.0;
        redFrame = CGRectMake(cx_red - CYLINDER_WIDTH * 0.5, cy_red - CYLINDER_HEIGHT * 0.5, CYLINDER_WIDTH, CYLINDER_HEIGHT);
        
        float cx_blue = cx + 6.0;
        float cy_blue = cy - 6.0;
        blueFrame = CGRectMake(cx_blue - CYLINDER_WIDTH * 0.5, cy_blue - CYLINDER_HEIGHT * 0.5, CYLINDER_WIDTH, CYLINDER_HEIGHT);
    }
    return self;
}


@end
