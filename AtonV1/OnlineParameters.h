//
//  OnlineParameters.h
//  AtonV1
//
//  Created by Wen Lin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface OnlineParameters : NSObject {
    GKMatch *match;
    
    //local player: remote player
    NSString* localPlayerName;
    NSString* remotePlayerName;
    int localPlayerEnum;
    int remoteGamePhaseEnum;
}

- (id)initWithPara:(GKMatch*) gkMatch:(NSString *)localName:(NSString*) remoteName:(int) localEnum;

@property(strong, nonatomic) GKMatch *match;
@property(strong, nonatomic) NSString *localPlayerName, *remotePlayerName;
@property(nonatomic) int localPlayerEnum, remoteGamePhaseEnum;

@end
