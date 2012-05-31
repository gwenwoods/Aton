//
//  AtonGameManager.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonPlayer.h"
#import "TempleUtility.h"


@interface AtonGameManager : NSObject {
    
    AtonGameParameters *para;
    UIImageView *gamePhaseTieIV, *helpTieIV ;
    UILabel *quitLb;
    AVAudioPlayer *audioPlayGame, *audioChime;
}

-(id)initializeWithParameters:(AtonGameParameters*) atonPara:(UIViewController*) viewController:(AVAudioPlayer*) atonAudioPlayGame:(AVAudioPlayer*) atonAudioChime;
-(void) showGamePhaseView:(NSString*) msg;
-(void) showHelpView:(NSString*) msg;
-(void) showFinalResultView:(NSString*) msg;
-(void) processActionResult:(int) messagePlayerEnum:(NSString*) msg;
-(NSString*) gameOverConditionSuper;
@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic) UIView* baseView;
@property(nonatomic) int messagePlayerEnum;
@property(strong, nonatomic) UIImageView *welcomeView, *gamePhaseView, *helpView;
@property(strong, nonatomic) UIImageView *exchangeCardsView, *finalResultView, *quitView;
@property(strong, nonatomic) UIImageView *gamePhaseActivePlayerIV, *helpActivePlayerIV ;
@property(strong, nonatomic) UILabel *gamePhaseLb, *gamePhaseDetailLb, *gamePhaseMiddleLb;
@property(strong, nonatomic) UILabel *helpLb, *helpDetailLb, *helpMiddleLb;
@property(strong, nonatomic) UILabel *exchangeCardsLb, *finalResultLb, *finalResultDetailLb;
//@property(strong, nonatomic) UIButton *exchangeYesButton, *exchangeNoButton;

@end
