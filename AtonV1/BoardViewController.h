//
//  BoardViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonGameParameters.h"
#import "AtonTouchBeganUtility.h"
#import "AtonTouchMovedUtility.h"
#import "AtonTouchEndUtility.h"
#import "AtonTouchElement.h"

#import "AtonTemple.h"

@interface BoardViewController : UIViewController {
    
    CGPoint touchLocation;
}

//@property(strong, nonatomic) AtonPlayer *redPlayer, *bluePlayer;
@property(strong, nonatomic) AtonGameParameters *atonParameters;
@property(strong, nonatomic) AtonTouchElement *touchElement;

@property(strong, nonatomic) AtonTemple* temple1;

@end
