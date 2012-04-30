//
//  AtonGameManager.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonPlayer.h"
@interface AtonGameManager : NSObject

-(id)initializeWithParameters:(UIViewController*) viewController;
-(void) showGamePhaseView:(NSString*) msg;
-(void) showHelpView:(NSString*) msg;
-(void) showFinalResultView:(NSString*) msg;

@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic) UIView* baseView;
@property(nonatomic) int activePlayer;
@property(strong, nonatomic) UIImageView *gamePhaseView, *helpView, *exchangeCardsView, *finalResultView;
@property(strong, nonatomic) UIImageView *gamePhaseActivePlayerIV;
@property(strong, nonatomic) UILabel *gamePhaseLb, *gamePhaseDetailLb, *helpLb, *exchangeCardsLb, *finalResultLb;
//@property(strong, nonatomic) UIButton *exchangeYesButton, *exchangeNoButton;

@end
