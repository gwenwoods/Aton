//
//  AtonPlayer.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonPlayer.h"

@implementation AtonPlayer

static int CARD_WIDTH = 88;
static int CARD_HEIGHT = 134;

static int START_SPACE = 818;

static NSString *redCardNames[4] = {@"Red_Card1",@"Red_Card2",@"Red_Card3",@"Red_Card4"};
static NSString *blueCardNames[4] = {@"Blue_Card1",@"Blue_Card2",@"Blue_Card3",@"Blue_Card4"};

@synthesize baseView;
@synthesize playerEnum, playerName;
@synthesize score;
@synthesize cardElementArray, emptyCardElementArray, tempCardElementArray;

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) controller {
	if (self) {
        baseView = controller.view;
        playerEnum = thisPlayerEnum;
        
        startOriginArray = (CGPoint*)malloc(sizeof(CGPoint) * 4);
        startOriginArray[0] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 70.0);
        startOriginArray[1] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 244.0);
        startOriginArray[2] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 418.0);
        startOriginArray[3] =  CGPointMake(10.0 + thisPlayerEnum * START_SPACE, 592.0);
        
        cardElementArray = [[NSMutableArray alloc] init];
        int *cardNumArray = {1,2,3,4};
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(startOriginArray[i].x, startOriginArray[i].y, CARD_WIDTH, CARD_HEIGHT)];
            iv.image = [UIImage imageNamed:[self getCardBackName]];
            iv.userInteractionEnabled = YES;
            
            [baseView addSubview:iv];
           
            CardElement *ce = [[CardElement alloc] initializeWithParameters:iv:0:(i+1)];
            [cardElementArray addObject:ce];
        }
        
        emptyCardElementArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -200, CARD_WIDTH, CARD_HEIGHT)];
            iv.image = nil;
            iv.userInteractionEnabled = YES;
            [baseView addSubview:iv];
            
            CardElement *ce = [[CardElement alloc] initializeWithParameters:iv:0:5];
            [emptyCardElementArray addObject:ce];
        }

        tempCardElementArray = [[NSMutableArray alloc] init];
    }  
    return self;
}

-(void) initilizeCardElement:(int*) cardNumberArray {
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        ce.number = cardNumberArray[i];
        ce.iv.image = [UIImage imageNamed:[self getCardName:ce.number]];
    }
}

-(NSString*) getCardBackName {
    
    if(playerEnum == 0) {
        return @"Red_CardBack.png";
    } else {
        return @"Blue_CardBack.png";
    }
}

-(NSString*) getCardName: (int) cardNum {
    
    if (playerEnum == 0) {
        return redCardNames[cardNum-1];
    } else {
        return blueCardNames[cardNum-1];
    }
}

-(void) switchCardElement:(AtonTouchElement*) touchElement:(CardElement*) targetCE {
    
    int fromIndex = touchElement.fromIndex;
    CardElement *fromCE = [cardElementArray objectAtIndex:(fromIndex-1)];
    fromCE.iv.image = targetCE.iv.image;
    fromCE.number = targetCE.number;
    if(fromCE.iv.image != nil) {
        fromCE.subIV.hidden = YES;
    }
    
    targetCE.iv.image = touchElement.touchIV.image;
    targetCE.subIV.hidden = YES;
    targetCE.number = [touchElement cardNum];
    
    [baseView bringSubviewToFront:fromCE.iv];
    [baseView bringSubviewToFront:targetCE.iv];
    [touchElement reset];
}

-(void) placeTempCardElementFromTouch:(AtonTouchElement*) touchElement {

    CardElement *ce = [emptyCardElementArray objectAtIndex:0];
    ce.number = touchElement.cardNum;
    ce.iv.image = touchElement.touchIV.image;
    ce.iv.center = touchElement.touchIV.center;
    [baseView bringSubviewToFront:ce.iv];
    
    [emptyCardElementArray removeObjectAtIndex:0];
    [tempCardElementArray addObject:ce];
    [touchElement reset];
}

-(void) releaseTempCardElement:(CardElement*) ce {
    [tempCardElementArray removeObject:ce];
    ce.iv.image = nil;
    ce.iv.center = CGPointMake(-200,-200);
    ce.number = 0;
    [emptyCardElementArray addObject:ce];
}

-(void) pushTargetToTemp:(CardElement*) targetCE {
    CardElement *tempCE= [emptyCardElementArray objectAtIndex:0];
    tempCE.number = targetCE.number;
    CGPoint tempCenter = CGPointMake(targetCE.iv.center.x+100, targetCE.iv.center.y);
    tempCE.iv.center = tempCenter;
    tempCE.iv.image = targetCE.iv.image;
    [baseView bringSubviewToFront:tempCE.iv];
    
    [emptyCardElementArray removeObject:tempCE];
    [tempCardElementArray addObject:tempCE];
}

-(void) placeCardElementFromTouch:(AtonTouchElement*) touchElement:(CardElement*) targetCE {
    targetCE.iv.image = touchElement.touchIV.image;
    targetCE.subIV.hidden = YES;
    targetCE.number = [touchElement cardNum];
    [touchElement reset];
}
@end
