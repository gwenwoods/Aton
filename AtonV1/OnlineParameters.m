//
//  OnlineParameters.m
//  AtonV1
//
//  Created by Wen Lin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnlineParameters.h"

@implementation OnlineParameters
@synthesize match;
@synthesize localPlayerName, remotePlayerName, localPlayerEnum, remoteGamePhaseEnum;

- (id)initWithPara:(GKMatch*) gkMatch:(NSString *)localName:(NSString*) remoteName:(int) localEnum
{
    if (self) {
        match = gkMatch;
        localPlayerName = localName;
        remotePlayerName = remoteName;
        localPlayerEnum = localEnum;
    }
    return self;
}

@end
