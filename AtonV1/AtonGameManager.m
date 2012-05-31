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
@synthesize messagePlayerEnum;
@synthesize gamePhaseView, gamePhaseLb, gamePhaseDetailLb, gamePhaseMiddleLb;
@synthesize helpView, helpLb, helpDetailLb, helpMiddleLb;
@synthesize exchangeCardsView, exchangeCardsLb;
@synthesize welcomeView, finalResultView, finalResultLb, finalResultDetailLb ;
@synthesize gamePhaseActivePlayerIV, helpActivePlayerIV;
@synthesize quitView;

static int TITLE_FONT_SIZE = 24;
static int DETAIL_FONT_SIZE = 20;


-(id)initializeWithParameters:(AtonGameParameters*) atonPara:(UIViewController*) viewController:(AVAudioPlayer*) atonAudioPlayGame:(AVAudioPlayer*) atonAudioChime {
    
    if (self) {
        para = atonPara;
        controller = viewController;
        baseView = controller.view;
        audioPlayGame = atonAudioPlayGame;
        audioChime = atonAudioChime;
       // NSString *atonFont = @"Palatino";
       // NSString *atonFont = @"Optima";
        NSString *atonFont = @"Cochin";
        NSString *atonFontTitle = @"Cochin-Bold";
        
       // CGRect viewFrame = CGRectMake(200, 120, 618, 448);
        CGRect viewFrame = CGRectMake(255,120,510, 448);
        NSString *viewBgName = @"Aton_MessageScroll_new.png";
        gamePhaseView = [[UIImageView alloc] initWithFrame:viewFrame];
        gamePhaseView.image = [UIImage imageNamed:viewBgName];
        gamePhaseView.hidden = YES;
        [baseView addSubview:gamePhaseView];
        
        gamePhaseLb = [[UILabel alloc] initWithFrame:CGRectMake(52,110,400,24)];
        gamePhaseLb.backgroundColor = [UIColor clearColor];
        gamePhaseLb.textAlignment = UITextAlignmentCenter;
        gamePhaseLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseLb.numberOfLines = 1;     
        gamePhaseLb.textColor = [UIColor blackColor];
        gamePhaseLb.font = [UIFont fontWithName:atonFontTitle size:TITLE_FONT_SIZE];
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
        
        gamePhaseMiddleLb = [[UILabel alloc] initWithFrame:CGRectMake(52,160,400,80)];
        gamePhaseMiddleLb.backgroundColor = [UIColor clearColor];
        gamePhaseMiddleLb.textAlignment = UITextAlignmentCenter;
        gamePhaseMiddleLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseMiddleLb.numberOfLines = 4;     
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
        helpView = [[UIImageView alloc] initWithFrame:viewFrame];
        helpView.image = [UIImage imageNamed:@"Aton_MessageScroll_new.png"];
        helpView.hidden = YES;
        [baseView addSubview:helpView];
        
        helpLb = [[UILabel alloc] initWithFrame:CGRectMake(52,108,400,24)];
        helpLb.backgroundColor = [UIColor clearColor];
        helpLb.textAlignment = UITextAlignmentCenter;
        helpLb.lineBreakMode = UILineBreakModeCharacterWrap;
        helpLb.numberOfLines = 4;     
        helpLb.textColor = [UIColor blackColor];
        helpLb.font = [UIFont fontWithName:atonFontTitle size:TITLE_FONT_SIZE];
        [helpView addSubview:helpLb];
        [helpView bringSubviewToFront:helpLb];

        helpDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(52,200,400,100)];
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
        
        helpTieIV = [[UIImageView alloc] initWithFrame:CGRectMake(193, 140, 130, 60)];
        UIImageView *redHelpIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        redIV.image = [UIImage imageNamed:@"Red_icon.png"];
        UIImageView *blueHelpIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 60, 60)];
        blueIV.image = [UIImage imageNamed:@"Blue_icon.png"];
        [helpTieIV addSubview:redHelpIV];
        [helpTieIV addSubview:blueHelpIV];
        [helpView addSubview:helpTieIV];

        //---------------------------------
        exchangeCardsView = [[UIImageView alloc] initWithFrame:viewFrame];
        exchangeCardsView.image = [UIImage imageNamed:@"Aton_MessageScroll_new.png"];
        exchangeCardsView.hidden = YES;
        exchangeCardsView.userInteractionEnabled = YES;
        [baseView addSubview:exchangeCardsView];
        
        exchangeCardsLb = [[UILabel alloc] initWithFrame:CGRectMake(48,100,400,200)];
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
        exchangeYesButton.frame = CGRectMake(300 , 272, 80, 40);
        exchangeYesButton.userInteractionEnabled = YES;
        //[exchangeYesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [exchangeYesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        [exchangeYesButton addTarget:controller action:@selector(exchangeCardsYes:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeYesButton];
        
        UIButton *exchangeNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeNoButton.frame = CGRectMake(120 , 270, 88, 44);
        exchangeNoButton.userInteractionEnabled = YES;
     //   [exchangeNoButton setTitle:@"No" forState:UIControlStateNormal];
        [exchangeNoButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
        [exchangeNoButton addTarget:controller action:@selector(exchangeCardsNo:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeNoButton];

        //---------------------------------
        finalResultView = [[UIImageView alloc] initWithFrame:viewFrame];
        finalResultView.image = [UIImage imageNamed:viewBgName];
        finalResultView.hidden = YES;
        finalResultView.userInteractionEnabled = YES;
        [baseView addSubview:finalResultView];
        
        finalResultLb = [[UILabel alloc] initWithFrame:CGRectMake(52,112,400,48)];
        finalResultLb.backgroundColor = [UIColor clearColor];
        finalResultLb.textAlignment = UITextAlignmentCenter;
        finalResultLb.lineBreakMode = UILineBreakModeCharacterWrap;
        finalResultLb.numberOfLines = 2;     
        finalResultLb.textColor = [UIColor blackColor];
        finalResultLb.font = [UIFont fontWithName:atonFont size:20];
        [finalResultView addSubview:finalResultLb];
        [finalResultView bringSubviewToFront:finalResultLb];
        
        finalResultDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(52,180,400,80)];
        finalResultDetailLb.backgroundColor = [UIColor clearColor];
        finalResultDetailLb.textAlignment = UITextAlignmentCenter;
        finalResultDetailLb.lineBreakMode = UILineBreakModeCharacterWrap;
        finalResultDetailLb.numberOfLines = 6;     
        finalResultDetailLb.textColor = [UIColor blackColor];
        finalResultDetailLb.font = [UIFont fontWithName:atonFont size:20];
        [finalResultView addSubview:finalResultDetailLb];
        [finalResultView bringSubviewToFront:finalResultDetailLb];
        UIButton *closeFinalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeFinalButton.frame = CGRectMake(197,280,110,40);
        [closeFinalButton setImage:[UIImage imageNamed:@"Button_Done.png"] forState:UIControlStateNormal];
        [closeFinalButton addTarget:self action:@selector(closeFinalView:) forControlEvents:UIControlEventTouchUpInside];
        [finalResultView addSubview:closeFinalButton];
        
        //---------------------------------
        welcomeView = [[UIImageView alloc] initWithFrame:viewFrame];
        welcomeView.image = [UIImage imageNamed:viewBgName];
        welcomeView.userInteractionEnabled = YES;
        welcomeView.hidden = YES;
        [baseView addSubview:welcomeView];
        
        UILabel *welcomeLb = [[UILabel alloc] initWithFrame:CGRectMake(52,160,400,48)];
        welcomeLb.backgroundColor = [UIColor clearColor];
        welcomeLb.textAlignment = UITextAlignmentCenter;
        welcomeLb.lineBreakMode = UILineBreakModeCharacterWrap;
        welcomeLb.numberOfLines = 2;     
        welcomeLb.textColor = [UIColor blackColor];
        welcomeLb.font = [UIFont fontWithName:atonFont size:20];
        welcomeLb.text = @"Welcome to ancient Egypt\n\n You are the highest priest of Son God";
        [welcomeView addSubview:welcomeLb];
        [welcomeView bringSubviewToFront:welcomeLb];
        
        UIButton *closeWelcomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeWelcomeButton.frame = CGRectMake(197,280,110,40);
        [closeWelcomeButton setImage:[UIImage imageNamed:@"Button_Done.png"] forState:UIControlStateNormal];
        [closeWelcomeButton addTarget:self action:@selector(closeWelcomeView:) forControlEvents:UIControlEventTouchUpInside];
        [welcomeView addSubview:closeWelcomeButton];
        
        //-----------
        quitView = [[UIImageView alloc] initWithFrame:viewFrame];
        quitView.image = [UIImage imageNamed:viewBgName];
        quitView.userInteractionEnabled = YES;
        quitView.hidden = YES;
        
        quitLb = [[UILabel alloc] initWithFrame:CGRectMake(52,100,400,200)];
        quitLb.backgroundColor = [UIColor clearColor];
        quitLb.textAlignment = UITextAlignmentCenter;
        quitLb.lineBreakMode = UILineBreakModeCharacterWrap;
        quitLb.numberOfLines = 8;     
        quitLb.textColor = [UIColor blackColor];
        quitLb.font = [UIFont fontWithName:atonFont size:20];
        quitLb.text = @"Do You Want to Quit Now? \n\n";
        [quitView addSubview:quitLb];
        [quitView bringSubviewToFront:quitLb];
        
        UIButton *quitYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        quitYesButton.frame = CGRectMake(300 , 272, 80, 40);
        quitYesButton.userInteractionEnabled = YES;
        //[quitYesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [quitYesButton setImage:[UIImage imageNamed:@"button_yes.png"] forState:UIControlStateNormal];
        [quitYesButton addTarget:controller action:@selector(quitYes:) forControlEvents:UIControlEventTouchUpInside];
        [quitView addSubview:quitYesButton];
        
        UIButton *quitNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        quitNoButton.frame = CGRectMake(120 , 270, 88, 44);
        quitNoButton.userInteractionEnabled = YES;
       // [quitNoButton setTitle:@"No" forState:UIControlStateNormal];
        [quitNoButton setImage:[UIImage imageNamed:@"button_no.png"] forState:UIControlStateNormal];
        [quitNoButton addTarget:controller action:@selector(quitNo:) forControlEvents:UIControlEventTouchUpInside];
        [quitView addSubview:quitNoButton];
        [baseView addSubview:quitView];
    }
    return self;
}

-(void) processActionResult:(int) messagePlayerEnum:(NSString*) msg{

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
    
    if (messagePlayerEnum == PLAYER_RED) {
        gamePhaseTieIV.hidden = YES;
        gamePhaseActivePlayerIV.image = [UIImage imageNamed:@"Red_icon.png"];
        
    } else if (messagePlayerEnum == PLAYER_BLUE) {
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
    helpDetailLb.text = nil;
    helpMiddleLb.text = nil;
    
    NSArray *messageArray = [msg componentsSeparatedByString: @"|"];
    
    if ([messageArray count] > 1) {
        helpLb.text = [messageArray objectAtIndex:0];
        helpDetailLb.text = [messageArray objectAtIndex:1];
    } else {
        helpMiddleLb.text = [messageArray objectAtIndex:0];
    }
    
    if (messagePlayerEnum == PLAYER_RED) {
        helpTieIV.hidden = YES;
        helpActivePlayerIV.image = [UIImage imageNamed:@"Red_icon.png"];
        
    } else if (messagePlayerEnum == PLAYER_BLUE) {
        helpTieIV.hidden = YES;
        helpActivePlayerIV.image = [UIImage imageNamed:@"Blue_icon.png"];
        
    } else {
        helpActivePlayerIV.image = nil;
        if (helpMiddleLb.text == nil) {
            helpTieIV.hidden = NO;
        }
    }
    
    
    helpView.hidden = NO;
    helpView.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         helpView.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(void) showFinalResultView:(NSString*) msg {
    
    [audioPlayGame stop];
    [audioChime play];
    
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

-(IBAction) closeFinalView :(id)sender {
    finalResultView.hidden = YES;
}

-(IBAction) closeWelcomeView :(id)sender {
   // welcomeView.hidden = YES;
   // welcomeView.hidden = NO;
   // welcomeView.alpha = 1.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         welcomeView.alpha = 0.0;
                         
                     } 
                     completion:^(BOOL finished){
                         welcomeView.hidden = YES;
                     }];

}

-(NSString*) gameOverConditionSuper {
    NSString *msg;
    
    //  if ([TempleUtility isYellowFull:para.templeArray]) {
    if ([TempleUtility findColorFullWinner:para.templeArray:YELLOW] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para.templeArray:YELLOW];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"All Yellow Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    } else if ([TempleUtility findColorFullWinner:para.templeArray:GREEN]!= PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findColorFullWinner:para.templeArray:GREEN];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"All Green Squares Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_1] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_1];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 1 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_2] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_2];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 2 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_3] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_3];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 3 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    } else if ([TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_4] != PLAYER_NONE) {
        int winnerEnum =  [TempleUtility findTempleFullWinner:para.templeArray:TEMPLE_4];
        AtonPlayer *winner = [para.playerArray objectAtIndex:winnerEnum];
        msg = @"Temple 4 Full\n";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@" wins|"];
        
    }
    
    NSMutableArray *playerArray = para.playerArray;
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    if (redScore >= 40 && blueScore >= 40) {
        msg = @"";
        msg = [msg stringByAppendingString:@"Both players reaches 40 points|"];
        
    } else if (redScore >= 40) {
        AtonPlayer *winner = [para.playerArray objectAtIndex:PLAYER_RED];
        msg = @"";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@"\n reaches 40 points and wins|"];
        
    } else if (blueScore >= 40) {
        AtonPlayer *winner = [para.playerArray objectAtIndex:PLAYER_BLUE];
        msg = @"";
        msg = [msg stringByAppendingString:winner.playerName];
        msg = [msg stringByAppendingString:@"\n reaches 40 points and wins|"];
        
    }
    
    if (msg != nil) {
        msg = [msg stringByAppendingString:[self gameOverResultMsg]];
    }
    
    return msg;
}

-(NSString*) gameOverResultMsg {
    
    NSMutableArray *playerArray = para.playerArray;
    NSString *msg = @"Game Over\n";
    int redScore = [[playerArray objectAtIndex:PLAYER_RED] score];
    int blueScore = [[playerArray objectAtIndex:PLAYER_BLUE] score];
    
    AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
    
    NSString *redName = redPlayer.playerName;
    NSString *blueName = bluePlayer.playerName;
    msg = [msg stringByAppendingString:redName];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@": %i \n", redScore]];
    msg = [msg stringByAppendingString:blueName];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@": %i \n", blueScore]];
    return msg;
}

@end
