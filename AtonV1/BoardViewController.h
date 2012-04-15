//
//  BoardViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonPlayer.h"
#import "AtonTouchMoveUtility.h"

@interface BoardViewController : UIViewController

@property(strong, nonatomic) AtonPlayer *redPlayer, *bluePlayer;
@end
