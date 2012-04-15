//
//  AtonTouchBeganUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTouchElement.h"
#import "AtonPlayer.h"

@interface AtonTouchBeganUtility : NSObject

+(void) playerArrangeCard:(UITouch*) touch:(AtonTouchElement*) touchElement: (AtonPlayer*) player;

@end
