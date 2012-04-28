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
#import "AtonMessageMaster.h"

@interface AtonGameEngine : NSObject {
    AtonMessageMaster *messageMaster;
}

-(id)initializeWithParameters:(AtonGameParameters*) parameter;
-(void) run;
-(void) playerDoneAction;
-(NSString*) gameOverCondition;

-(void) imageFly:(UIImageView*) begin:(UIImageView*) end;
@property(strong, nonatomic) AtonGameParameters *para;

@end
