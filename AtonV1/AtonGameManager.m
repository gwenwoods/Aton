//
//  AtonGameManager.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonGameManager.h"

@implementation AtonGameManager

@synthesize baseView;
@synthesize activePlayer;
@synthesize gamePhaseView, gamePhaseLb;
@synthesize helpView, helpLb;

-(id)initializeWithParameters:(UIView*) atonBaseView {
    
    if (self) {
        baseView = atonBaseView;
        
        gamePhaseView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 120,500, 400)];
        gamePhaseView.image = [UIImage imageNamed:@"under_fabric.png"];
        gamePhaseView.hidden = YES;
        [baseView addSubview:gamePhaseView];
        
        gamePhaseLb = [[UILabel alloc] initWithFrame:CGRectMake(40,60,400,200)];
        gamePhaseLb.backgroundColor = [UIColor clearColor];
        gamePhaseLb.textAlignment = UITextAlignmentCenter;
        gamePhaseLb.lineBreakMode = UILineBreakModeCharacterWrap;
        gamePhaseLb.numberOfLines = 3;     
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

    }
    return self;
}

-(void) showCommunicationView:(NSString*) msg {
    gamePhaseView.hidden = NO;
    gamePhaseLb.text = msg;
}
@end
