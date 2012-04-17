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
@synthesize activePlayer, communicationView;

-(id)initializeWithParameters:(UIView*) atonBaseView {
    
    if (self) {
        baseView = atonBaseView;
        
        communicationView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100,200, 200)];
        communicationView.image = [UIImage imageNamed:@"under_fabric.png"];
        communicationView.hidden = YES;
        [baseView addSubview:communicationView];
        
    }
    return self;
}
@end
