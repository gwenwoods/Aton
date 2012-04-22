//
//  ScoreScarab.h
//  AtonV1
//
//  Created by Wen Lin on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreScarab : NSObject

-(id)initializeWithParameters:(int) score:(UIImageView*) imageView;

@property(nonatomic) int scoreValue;
@property(nonatomic) int occupiedEnum;
@property(strong, nonatomic) UIImageView *iv, *redIV, *blueIV;
@property(nonatomic) CGRect redFrame, blueFrame;

@end
