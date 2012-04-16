//
//  BoardViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonPlayer.h"
#import "AtonTouchBeganUtility.h"
#import "AtonTouchMovedUtility.h"
#import "AtonTouchEndUtility.h"
#import "AtonTouchElement.h"

#import "TempleSlot.h" // temp one

@interface BoardViewController : UIViewController {
    
    CGPoint touchLocation;
}

@property(strong, nonatomic) AtonPlayer *redPlayer, *bluePlayer;
@property(strong, nonatomic) AtonTouchElement *touchElement;

@end
