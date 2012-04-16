//
//  AtonGameParameters.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"
#import "AtonTemple.h"

@interface AtonGameParameters : NSObject

-(id)initializeWithParameters:(NSMutableArray*) atonPlayerArray:(NSMutableArray*) atonTempleArray;

@property(strong, nonatomic) NSMutableArray *playerArray, *templeArray;

@end
