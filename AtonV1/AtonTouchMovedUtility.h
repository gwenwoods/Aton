//
//  AtonTouchMovedUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtonTouchElement.h"

@interface AtonTouchMovedUtility : NSObject

+(void) moveTouchElement:(UITouch*) touch:(AtonTouchElement*) touchElement:(UIView*) baseView;

@end
