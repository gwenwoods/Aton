//
//  AtonTouchEndUtility.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"
#import "AtonTouchElement.h"

@interface AtonTouchEndUtility : NSObject

+(void) playerPlaceCard:(UITouch*) touch:(AtonTouchElement*) touchElement: (AtonGameParameters*) atonParameters;

@end
