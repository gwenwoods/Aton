//
//  AtonGameManager.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonPlayer.h"
@interface AtonGameManager : NSObject {
    UIImageView *gamePhaseTieIV, *helpTieIV ;
    UILabel *quitLb;
}

-(id)initializeWithParameters:(UIViewController*) viewController;
-(void) showGamePhaseView:(NSString*) msg;
-(void) showHelpView:(NSString*) msg;
-(void) showFinalResultView:(NSString*) msg;

@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic) UIView* baseView;
@property(nonatomic) int messagePlayerEnum;
@property(strong, nonatomic) UIImageView *gamePhaseView, *helpView, *exchangeCardsView, *finalResultView, *quitView;
@property(strong, nonatomic) UIImageView *gamePhaseActivePlayerIV, *helpActivePlayerIV ;
//@property(strong, nonatomic) UIImageView *gamePhaseTieIV, *helpTieIV ;
@property(strong, nonatomic) UILabel *gamePhaseLb, *gamePhaseDetailLb, *gamePhaseMiddleLb;
@property(strong, nonatomic) UILabel *helpLb, *helpDetailLb, *helpMiddleLb;
@property(strong, nonatomic) UILabel *exchangeCardsLb, *finalResultLb, *finalResultDetailLb;
//@property(strong, nonatomic) UIButton *exchangeYesButton, *exchangeNoButton;

@end
