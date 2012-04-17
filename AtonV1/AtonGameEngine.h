//
//  AtonGameEngine.h
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"

@interface AtonGameEngine : NSObject

-(id)initializeWithParameters:(AtonGameParameters*) parameter;
-(void) run;

@property(strong, nonatomic) AtonGameParameters *para;

@end
