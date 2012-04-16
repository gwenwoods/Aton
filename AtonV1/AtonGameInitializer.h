//
//  AtonGameInitializer.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"

@interface AtonGameInitializer : NSObject

+(AtonGameParameters*) initializeNewGame:(UIViewController*) controller;

@end
