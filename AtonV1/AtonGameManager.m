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
@synthesize gamePhaseView, gamePhaseLb;
@synthesize helpView, helpLb;
@synthesize exchangeCardsView, exchangeCardsLb;
//@synthesize exchangeYesButton, exchangeNoButton;

-(id)initializeWithParameters:(UIViewController*) viewController {
    
    if (self) {
        controller = viewController;
        baseView = controller.view;
        
        gamePhaseView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,500, 400)];
        gamePhaseView.image = [UIImage imageNamed:@"under_fabric.png"];
        gamePhaseView.hidden = YES;
        [baseView addSubview:gamePhaseView];
        
        gamePhaseLb = [[UILabel alloc] initWithFrame:CGRectMake(40,60,400,200)];
        gamePhaseLb.backgroundColor = [UIColor clearColor];
        gamePhaseLb.textAlignment = UITextAlignmentCenter;
        gamePhaseLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseLb.numberOfLines = 5;     
        gamePhaseLb.textColor = [UIColor whiteColor];
        gamePhaseLb.font = [UIFont fontWithName:@"Copperplate" size:24];
        [gamePhaseView addSubview:gamePhaseLb];
        [gamePhaseView bringSubviewToFront:gamePhaseLb];
        
        //---------------------------------
        helpView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,500, 400)];
        helpView.image = [UIImage imageNamed:@"under_fabric.png"];
        helpView.hidden = YES;
        [baseView addSubview:helpView];
        
        helpLb = [[UILabel alloc] initWithFrame:CGRectMake(40,60,400,200)];
        helpLb.backgroundColor = [UIColor clearColor];
        helpLb.textAlignment = UITextAlignmentCenter;
        helpLb.lineBreakMode = UILineBreakModeCharacterWrap;
        helpLb.numberOfLines = 3;     
        helpLb.textColor = [UIColor whiteColor];
        helpLb.font = [UIFont fontWithName:@"Copperplate" size:24];
        [helpView addSubview:helpLb];
        [helpView bringSubviewToFront:helpLb];

        //---------------------------------
        exchangeCardsView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,500, 400)];
        exchangeCardsView.image = [UIImage imageNamed:@"under_fabric.png"];
        exchangeCardsView.hidden = YES;
        exchangeCardsView.userInteractionEnabled = YES;
        [baseView addSubview:exchangeCardsView];
        
        exchangeCardsLb = [[UILabel alloc] initWithFrame:CGRectMake(40,60,400,200)];
        exchangeCardsLb.backgroundColor = [UIColor clearColor];
        exchangeCardsLb.textAlignment = UITextAlignmentCenter;
        exchangeCardsLb.lineBreakMode = UILineBreakModeCharacterWrap;
        exchangeCardsLb.numberOfLines = 3;     
        exchangeCardsLb.textColor = [UIColor whiteColor];
        exchangeCardsLb.font = [UIFont fontWithName:@"Copperplate" size:24];
        exchangeCardsLb.text = @"You can exchange cards\n once per game.\n Do you want to exchange now?";
        [exchangeCardsView addSubview:exchangeCardsLb];
        [exchangeCardsView bringSubviewToFront:exchangeCardsLb];

        UIButton *exchangeYesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        exchangeYesButton.frame = CGRectMake(300 , 240, 40, 50);
        exchangeYesButton.userInteractionEnabled = YES;
        [exchangeYesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [exchangeYesButton addTarget:controller action:@selector(exchangeCardsYes:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeYesButton];
        
        UIButton *exchangeNoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        exchangeNoButton.frame = CGRectMake(120 , 240, 40, 50);
        exchangeNoButton.userInteractionEnabled = YES;
        [exchangeNoButton setTitle:@"No" forState:UIControlStateNormal];
        [exchangeNoButton addTarget:controller action:@selector(exchangeCardsNo:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCardsView addSubview:exchangeNoButton];

    }
    return self;
}

-(void) showGamePhaseView:(NSString*) msg {
    gamePhaseView.hidden = NO;
    gamePhaseLb.text = msg;
}

-(void) showHelpView:(NSString*) msg {
    helpView.hidden = NO;
    helpLb.text = msg;
}

@end
