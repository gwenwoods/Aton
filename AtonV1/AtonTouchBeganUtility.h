//
//  AtonTouchBeganUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonTouchElement.h"
#import "AtonGameParameters.h"

@interface AtonTouchBeganUtility : NSObject

+(void) checkTouch:(UITouch*) touch:(AtonTouchElement*) touchElement:(AtonGameParameters*) atonParameters;
@end
