//
//  AtonGameManager.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameManager.h"

@implementation AtonGameManager

@synthesize controller, baseView;
@synthesize activePlayer;
@synthesize gamePhaseView, gamePhaseLb, gamePhaseDetailLb, gamePhaseMiddleLb;
@synthesize helpView, helpLb, helpDetailLb, helpMiddleLb;
@synthesize exchangeCardsView, exchangeCardsLb;
@synthesize finalResultView, finalResultLb, finalResultDetailLb ;
@synthesize gamePhaseActivePlayerIV, helpActivePlayerIV;
@synthesize quitView;

static int TITLE_FONT_SIZE = 26;
static int DETAIL_FONT_SIZE = 20;

-(id)initializeWithParameters:(UIViewController*) viewController {
    
    if (self) {
        controller = viewController;
        baseView = controller.view;
        
        NSString *atonFont = @"Palatino";
        
        gamePhaseView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,510, 448)];
        gamePhaseView.image = [UIImage imageNamed:@"Aton_MessageScroll.png"];
        gamePhaseView.hidden = YES;
        [baseView addSubview:gamePhaseView];
        
        gamePhaseLb = [[UILabel alloc] initWithFrame:CGRectMake(52,108,400,24)];
        gamePhaseLb.backgroundColor = [UIColor clearColor];
        gamePhaseLb.textAlignment = UITextAlignmentCenter;
        gamePhaseLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseLb.numberOfLines = 1;     
        gamePhaseLb.textColor = [UIColor blackColor];
        gamePhaseLb.font = [UIFont fontWithName:atonFont size:TITLE_FONT_SIZE];
        [gamePhaseView addSubview:gamePhaseLb];
        [gamePhaseView bringSubviewToFront:gamePhaseLb];
        
        gamePhaseDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(52,200,400,100)];
        gamePhaseDetailLb.backgroundColor = [UIColor clearColor];
        gamePhaseDetailLb.textAlignment = UITextAlignmentCenter;
        gamePhaseDetailLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseDetailLb.numberOfLines = 4;   
        gamePhaseDetailLb.textColor = [UIColor blackColor];
        gamePhaseDetailLb.font = [UIFont fontWithName:atonFont size:DETAIL_FONT_SIZE];
       // [gamePhaseDetailLb sizeToFit];
        [gamePhaseView addSubview:gamePhaseDetailLb];
        [gamePhaseView bringSubviewToFront:gamePhaseDetailLb];
        
        gamePhaseMiddleLb = [[UILabel alloc] initWithFrame:CGRectMake(52,160,400,60)];
        gamePhaseMiddleLb.backgroundColor = [UIColor clearColor];
        gamePhaseMiddleLb.textAlignment = UITextAlignmentCenter;
        gamePhaseMiddleLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseMiddleLb.numberOfLines = 3;     
        gamePhaseMiddleLb.textColor = [UIColor blackColor];
        gamePhaseMiddleLb.font = [UIFont fontWithName:atonFont size:DETAIL_FONT_SIZE];
        [gamePhaseView addSubview:gamePhaseMiddleLb];
        [gamePhaseView bringSubviewToFront:gamePhaseMiddleLb];
        
        gamePhaseActivePlayerIV = [[UIImageView alloc] initWithFrame:CGRectMake(228, 140, 60, 60)];
        [gamePhaseView addSubview:gamePhaseActivePlayerIV];
        
        gamePhaseTieIV = [[UIImageView alloc] initWithFrame:CGRectMake(193, 140, 130, 60)];
        UIImageView *redIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        redIV.image = [UIImage imageNamed:@"Red_icon.png"];
        UIImageView *blueIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 60, 60)];
        blueIV.image = [UIImage imageNamed:@"Blue_icon.png"];
        [gamePhaseTieIV addSubview:redIV];
        [gamePhaseTieIV addSubview:blueIV];
        [gamePhaseView addSubview:gamePhaseTieIV];
        
        //---------------------------------
        helpView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,510, 448)];
        helpView.image = [UIImage imageNamed:@"Aton_MessageScroll.png"];
        helpView.hidden = YES;
        [baseView addSubview:helpView];
        
        helpLb = [[UILabel alloc] initWithFrame:CGRectMake(52,108,400,20)];
        helpLb.backgroundColor = [UIColor clearColor];
        helpLb.textAlignment = UITextAlignmentCenter;
        helpLb.lineBreakMode = UILineBreakModeCharacterWrap;
        helpLb.numberOfLines = 4;     
        helpLb.textColor = [UIColor blackColor];
        helpLb.font = [UIFont fontWithName:atonFont size:TITLE_FONT_SIZE];
        [helpView addSubview:helpLb];
        [helpView bringSubviewToFront:helpLb];

        helpDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(52,200,400,80)];
        helpDetailLb.backgroundColor = [UIColor clearColor];
        helpDetailLb.textAlignment = UITextAlignmentCenter;
        helpDetailLb.lineBreakMode = UILineBreakModeCharacterWrap;
        helpDetailLb.numberOfLines = 4;     
        helpDetailLb.textColor = [UIColor blackColor];
        helpDetailLb.font = [UIFont fontWithName:atonFont size:DETAIL_FONT_SIZE];
        [helpView addSubview:helpDetailLb];
        [helpView bringSubviewToFront:helpDetailLb];
        
        helpMiddleLb = [[UILabel alloc] initWithFrame:CGRectMake(52,160,400,60)];
        helpMiddleLb.backgroundColor = [UIColor clearColor];
        helpMiddleLb.textAlignment = UITextAlignmentCenter;
        helpMiddleLb.lineBreakMode = UILineBreakModeCharacterWrap;
        helpMiddleLb.numberOfLines = 3;     
        helpMiddleLb.textColor = [UIColor blackColor];
        helpMiddleLb.font = [UIFont fontWithName:atonFont size:DETAIL_FONT_SIZE];
        [helpView addSubview:helpMiddleLb];
        [helpView bringSubviewToFront:helpMiddleLb];
        
        helpActivePlayerIV = [[UIImageView alloc] initWithFrame:CGRectMake(228, 140, 60, 60)];
        [helpView addSubview:helpActivePlayerIV];
        //---------------------------------
        exchangeCardsView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,510, 448)];
        exchangeCardsView.image = [UIImage imageNamed:@"Aton_MessageScroll.png"];
        exchangeCardsView.hidden = YES;
        exchangeCardsView.userInteractionEnabled = YES;
        [baseView addSubview:exchangeCardsView];
        
        exchangeCardsLb = [[UILabel alloc] initWithFrame:CGRectMake(40,100,400,200)];
        exchangeCardsLb.backgroundColor = [UIColor clearColor];
        exchangeCardsLb.textAlignment = UITextAlignmentCenter;
        exchangeCardsLb.lineBreakMode = UILineBreakModeCharacterWrap;
        exchangeCardsLb.numberOfLines = 8;     
        exchangeCardsLb.textColor = [UIColor blackColor];
        exchangeCardsLb.font = [UIFont fontWithName:atonFont size:20];
        exchangeCardsLb.text = @"You Can Exchange Cards\n Once Per Game.\n Exchange Now?";
        [exchangeCardsView addSubview:exchangeCardsLb];
        [exchangeCardsView bringSubviewToFront:exchangeCardsLb];

        UIButton *exchangeYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeYesButton.frame = CGRectMake(260 , 242, 116, 58);
        exchangeYesButton.userInteractionEnabled = YES;
        //[exchangeYesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [exchangeYesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        [exchangeYesButton addTarget:controller action:@selector(exchangeCardsYes:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeYesButton];
        
        UIButton *exchangeNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeNoButton.frame = CGRectMake(128 , 240, 125, 63);
        exchangeNoButton.userInteractionEnabled = YES;
     //   [exchangeNoButton setTitle:@"No" forState:UIControlStateNormal];
        [exchangeNoButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
        [exchangeNoButton addTarget:controller action:@selector(exchangeCardsNo:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeNoButton];

        //---------------------------------
        finalResultView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,510, 448)];
        finalResultView.image = [UIImage imageNamed:@"Aton_MessageScroll.png"];
        finalResultView.hidden = YES;
        finalResultView.userInteractionEnabled = YES;
        [baseView addSubview:finalResultView];
        
        finalResultLb = [[UILabel alloc] initWithFrame:CGRectMake(52,112,400,40)];
        finalResultLb.backgroundColor = [UIColor clearColor];
        finalResultLb.textAlignment = UITextAlignmentCenter;
        finalResultLb.lineBreakMode = UILineBreakModeCharacterWrap;
        finalResultLb.numberOfLines = 2;     
        finalResultLb.textColor = [UIColor blackColor];
        finalResultLb.font = [UIFont fontWithName:atonFont size:20];
        [finalResultView addSubview:finalResultLb];
        [finalResultView bringSubviewToFront:finalResultLb];
        
        finalResultDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(52,168,400,80)];
        finalResultDetailLb.backgroundColor = [UIColor clearColor];
        finalResultDetailLb.textAlignment = UITextAlignmentCenter;
        finalResultDetailLb.lineBreakMode = UILineBreakModeCharacterWrap;
        finalResultDetailLb.numberOfLines = 6;     
        finalResultDetailLb.textColor = [UIColor blackColor];
        finalResultDetailLb.font = [UIFont fontWithName:atonFont size:20];
        [finalResultView addSubview:finalResultDetailLb];
        [finalResultView bringSubviewToFront:finalResultDetailLb];

        //-----------
        quitView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,510, 448)];
        quitView.image = [UIImage imageNamed:@"Aton_MessageScroll.png"];
        quitView.userInteractionEnabled = YES;
        quitView.hidden = YES;
        
        quitLb = [[UILabel alloc] initWithFrame:CGRectMake(40,100,400,200)];
        quitLb.backgroundColor = [UIColor clearColor];
        quitLb.textAlignment = UITextAlignmentCenter;
        quitLb.lineBreakMode = UILineBreakModeCharacterWrap;
        quitLb.numberOfLines = 8;     
        quitLb.textColor = [UIColor blackColor];
        quitLb.font = [UIFont fontWithName:atonFont size:20];
        quitLb.text = @"Do You Want\n to Quit Now? \n\n";
        [quitView addSubview:quitLb];
        [quitView bringSubviewToFront:quitLb];
        
        UIButton *quitYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        quitYesButton.frame = CGRectMake(260 , 252, 116, 58);
        quitYesButton.userInteractionEnabled = YES;
        //[quitYesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [quitYesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        [quitYesButton addTarget:controller action:@selector(quitYes:) forControlEvents:UIControlEventTouchUpInside];
        [quitView addSubview:quitYesButton];
        
        UIButton *quitNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        quitNoButton.frame = CGRectMake(120 , 250, 125, 63);
        quitNoButton.userInteractionEnabled = YES;
       // [quitNoButton setTitle:@"No" forState:UIControlStateNormal];
        [quitNoButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
        [quitNoButton addTarget:controller action:@selector(quitNo:) forControlEvents:UIControlEventTouchUpInside];
        [quitView addSubview:quitNoButton];
        [baseView addSubview:quitView];
    }
    return self;
}

-(void) showGamePhaseView:(NSString*) msg {
    
    gamePhaseLb.text = nil;
    gamePhaseDetailLb.text = nil;
    gamePhaseMiddleLb.text = nil;
    
    NSArray *messageArray = [msg componentsSeparatedByString: @"|"];

    if ([messageArray count] > 1) {
        gamePhaseLb.text = [messageArray objectAtIndex:0];
        gamePhaseDetailLb.text = [messageArray objectAtIndex:1];
    } else {
        gamePhaseMiddleLb.text = [messageArray objectAtIndex:0];
    }
    
    if (activePlayer == PLAYER_RED) {
        gamePhaseTieIV.hidden = YES;
        gamePhaseActivePlayerIV.image = [UIImage imageNamed:@"Red_icon.png"];
        
    } else if (activePlayer == PLAYER_BLUE) {
        gamePhaseTieIV.hidden = YES;
        gamePhaseActivePlayerIV.image = [UIImage imageNamed:@"Blue_icon.png"];
        
    } else {
        gamePhaseActivePlayerIV.image = nil;
        if (gamePhaseMiddleLb.text == nil) {
            gamePhaseTieIV.hidden = NO;
        }
    }
    
    
    gamePhaseView.hidden = NO;
    gamePhaseView.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         gamePhaseView.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];

}

-(void) showHelpView:(NSString*) msg {
    
    helpLb.text = nil;
    
    NSArray *messageArray = [msg componentsSeparatedByString: @"|"];
    NSString *title = [messageArray objectAtIndex:0];
    NSString *progressMsg = @"";
    
    if ([messageArray count] > 1) {
        progressMsg = [messageArray objectAtIndex:1];
    }
    
    if (activePlayer == PLAYER_RED) {
        helpActivePlayerIV.image = [UIImage imageNamed:@"Red_icon.png"];
        
    } else if (activePlayer == PLAYER_BLUE) {
        helpActivePlayerIV.image = [UIImage imageNamed:@"Blue_icon.png"];
        
    } else {
        helpActivePlayerIV.image = nil;
        
    }
    
    if ([messageArray count] > 1) {
        helpLb.text = title;
        helpDetailLb.text = progressMsg;
    } else {
        helpMiddleLb.text = title;
    }
    helpView.hidden = NO;
  //  helpLb.text = msg;
}

-(void) showFinalResultView:(NSString*) msg {
    
    NSArray *messageArray = [msg componentsSeparatedByString: @"|"];
    finalResultLb.text = [messageArray objectAtIndex:0];
    finalResultDetailLb.text = [messageArray objectAtIndex:1];
    
   // finalResultDetailLb.text = msg;
    finalResultView.hidden = NO;
    finalResultView.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         finalResultView.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}
@end
