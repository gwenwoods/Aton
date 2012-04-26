//
//  AtonGameEngine.h
//  AtonV1
//
//  Created by Wen Lin on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonGameParameters.h"
#import "AtonRoundResult.h"
#import "TempleUtility.h"

@interface AtonGameEngine : NSObject

-(id)initializeWithParameters:(AtonGameParameters*) parameter;
-(void) run;
-(NSString*) gameOverCondition;

-(void) imageFly:(UIImageView*) begin:(UIImageView*) end;
@property(strong, nonatomic) AtonGameParameters *para;

@end
