//
//  AtonPlayer.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "CardElement.h"
#import "AtonTouchElement.h"



@interface AtonPlayer : NSObject {
    
    CGPoint *startOriginArray;
}

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) controller;
-(void) initilizeCardElement:(int*) cardNumberArray;
-(void) distributeCards;

// arrange cards functions
-(void) switchCardElement:(AtonTouchElement*) touchElement:(CardElement*) targetCE;
-(void) placeTempCardElementFromTouch:(AtonTouchElement*) touchElement;
-(void) releaseTempCardElement:(CardElement*) ce;
-(void) pushTargetToTemp:(CardElement*) targetCE;
-(void) placeCardElementFromTouch:(AtonTouchElement*) touchElement:(CardElement*) targetCE;


@property (strong, nonatomic) UIView *baseView;
@property (nonatomic) int playerEnum;
@property (strong, nonatomic) NSString *playerName;
@property (nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cardElementArray, *emptyCardElementArray, *tempCardElementArray;
@property (strong, nonatomic) UIImageView *deckIV;
@property (nonatomic) int* deckArray;

@end
