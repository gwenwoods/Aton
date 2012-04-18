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
@synthesize communicationView, communicationLb;

-(id)initializeWithParameters:(UIView*) atonBaseView {
    
    if (self) {
        baseView = atonBaseView;
        
        communicationView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 120,540, 400)];
        communicationView.image = [UIImage imageNamed:@"under_fabric.png"];
        communicationView.hidden = YES;
        [baseView addSubview:communicationView];
        
        communicationLb = [[UILabel alloc] initWithFrame:CGRectMake(40,60,400,200)];
        communicationLb.backgroundColor = [UIColor clearColor];
        communicationLb.textAlignment = UITextAlignmentCenter;
        communicationLb.lineBreakMode = UILineBreakModeCharacterWrap;
        communicationLb.numberOfLines = 2;     
        //communicationLb.text = @"Player Red: lay your cards";
        communicationLb.textColor = [UIColor whiteColor];
        communicationLb.font = [UIFont fontWithName:@"Copperplate" size:24];
        [communicationView addSubview:communicationLb];
        [communicationView bringSubviewToFront:communicationLb];
        
    }
    return self;
}

-(void) showCommunicationView:(NSString*) msg {
    communicationView.hidden = NO;
    communicationLb.text = msg;
}
@end
