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
#import "ScoreScarab.h"

enum PLAYER_ENUM {
    PLAYER_RED, PLAYER_BLUE, PLAYER_NONE
};

@interface AtonPlayer : NSObject {
    
    CGPoint *startOriginArray;
}

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) controller;
-(void) initilizeCardElement:(int*) cardNumberArray;
-(void) openCards;
-(void) openCardsForArrange;
-(void) closeCards;
-(void) distributeCards;
-(int*) getCardNumberArray;
-(void) assignScore:(int) points: (NSMutableArray*) scarabArray;
-(void) resetCard;

// arrange cards functions
-(void) switchCardElement:(AtonTouchElement*) touchElement:(CardElement*) targetCE;
-(void) placeTempCardElementFromTouch:(AtonTouchElement*) touchElement;
-(void) releaseTempCardElement:(CardElement*) ce;
-(void) pushTargetToTemp:(CardElement*) targetCE;
-(void) placeCardElementFromTouch:(AtonTouchElement*) touchElement:(CardElement*) targetCE;

@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) UIView *baseView;
@property (nonatomic) int playerEnum;
@property (strong, nonatomic) NSString *playerName;
@property (nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cardElementArray, *emptyCardElementArray, *tempCardElementArray;
@property (strong, nonatomic) NSMutableArray *deckArray;
@property (strong, nonatomic) UIImageView *deckIV, *deckAnimationIV, *redrawIV;
@property (strong, nonatomic) UIButton *exchangeCardsButton;
@end
