//
//  AtonPlayer.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonPlayer.h"

@implementation AtonPlayer

static int CARD_WIDTH_START = 88;
static int CARD_HEIGHT_START = 134;

static int CARD_WIDTH_END = 78;
static int CARD_HEIGHT_END = 118;

static int START_SPACE = 818;
static int END_SPACE = 648;

@synthesize baseView;
@synthesize playerEnum, playerName;
@synthesize score;
@synthesize startCardNumArray, endCardNumArray;
@synthesize startCardIVArray, endCardIVArray;


-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) controller {
	if (self) {
        baseView = controller.view;
        playerEnum = thisPlayerEnum;
        
        startOriginArray = (CGPoint*)malloc(sizeof(CGPoint) * 4);
        startOriginArray[0] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 70.0);
        startOriginArray[1] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 244.0);
        startOriginArray[2] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 418.0);
        startOriginArray[3] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 592.0);
        
        startCardIVArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(startOriginArray[i].x, startOriginArray[i].y, CARD_WIDTH_START, CARD_HEIGHT_START)];
            iv.image = [UIImage imageNamed:[self getCardBackName]];
            iv.userInteractionEnabled = YES;
            [baseView addSubview:iv];
            
            [startCardIVArray addObject:iv];
        }
        
        endOriginArray = (CGPoint*)malloc(sizeof(CGPoint) * 4);
        endOriginArray[0] =  CGPointMake(100.0 + thisPlayerEnum * END_SPACE, 70.0);
        endOriginArray[1] =  CGPointMake(100.0 + thisPlayerEnum * END_SPACE, 244.0);
        endOriginArray[2] =  CGPointMake(100.0 + thisPlayerEnum * END_SPACE, 418.0);
        endOriginArray[3] =  CGPointMake(100.0 + thisPlayerEnum * END_SPACE, 592.0);
        
        endCardIVArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(endOriginArray[i].x, endOriginArray[i].y, CARD_WIDTH_END, CARD_HEIGHT_END)];
            iv.image = [UIImage imageNamed:[self getCardBackName]];
            [baseView addSubview:iv];
            
            [endCardIVArray addObject:iv];
        }

    }  
    return self;
}

-(NSString*) getCardBackName{
    
    if(playerEnum == 0) {
        return @"Red_CardBack.png";
    } else {
        return @"Blue_CardBack.png";
    }
}
@end
