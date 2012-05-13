//
//  AtonAI.h
//  AtonV1
//
//  Created by Wen Lin on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtonPlayer.h"
#import "TempleUtility.h"

@interface AtonAI : NSObject

-(id)initializeWithParameters:(NSMutableArray*) atonTempleArray:(AVAudioPlayer*) atonAudioToDeath;
-(void) removePeeps:(int)targetPlayerEnum:(int)removeNum:(int) maxTempleEnum ;


@end
