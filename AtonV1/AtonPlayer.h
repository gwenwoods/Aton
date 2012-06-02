//
//  AtonPlayer.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


#import "CardElement.h"
#import "AtonTouchElement.h"
#import "ScoreScarab.h"

enum PLAYER_ENUM {
    PLAYER_RED, PLAYER_BLUE, PLAYER_NONE
};

enum PLAYER_ACTION_ENUM {
    ACTION_NONE, ACTION_REMOVE, ACTION_PLACE  
};

@interface AtonPlayer : NSObject {
    
    CGPoint *startOriginArray;
    UILabel *deckCountLb;
    UIButton *doneButton;
    int score;
    
   // NSMutableArray *scrollPeepArray;
    UILabel *actionLb;
    
    UIImageView *scrollExchangeIV, *scrollBlankIV, *scrollDoneAniHomeIV;
    
    AVAudioPlayer *audioScroll;
}

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) viewController;
-(void) openCards;
-(void) openCardsForArrange;
-(void) closeCards;
-(void) distributeCards;
-(int*) getCardNumberArray;
-(void) resetCard;
-(void) displayMenu:(int) actionEnum:(int) peepNum;
-(void) closeMenu;
-(void) setCardNumberArray:(int*) newCardNumberArray;

// arrange cards functions
-(void) switchCardElement:(AtonTouchElement*) touchElement:(CardElement*) targetCE;
-(void) placeTempCardElementFromTouch:(AtonTouchElement*) touchElement;
-(void) releaseTempCardElement:(CardElement*) ce;
-(void) pushTargetToTemp:(CardElement*) targetCE;
-(void) placeCardElementFromTouch:(AtonTouchElement*) touchElement:(CardElement*) targetCE;

-(void) updateScore:(int) newScore;
-(int) getScore;

@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) UIView *baseView;
@property (nonatomic) int playerEnum;
@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) NSMutableArray *cardElementArray, *emptyCardElementArray, *tempCardElementArray;
@property (strong, nonatomic) NSMutableArray *deckArray, *scrollPeepArray;
@property (strong, nonatomic) UIImageView *deckIV, *deckAnimationIV;
@property (strong, nonatomic) UIButton *exchangeCardsButton;
@property (strong, nonatomic) UIImageView *scrollExchangeIV, *scrollDoneIV;
@property (strong, nonatomic)  UILabel *scoreLb;

@end
