//
//  GameCenterManager.m
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCenterManager.h"

@implementation GameCenterManager

- (id)init {
    if ((self = [super init])) {
        /*   gameCenterAvailable = [self isGameCenterAvailable];
         if (gameCenterAvailable) {
         NSNotificationCenter *nc = 
         [NSNotificationCenter defaultCenter];
         [nc addObserver:self 
         selector:@selector(authenticationChanged) 
         name:GKPlayerAuthenticationDidChangeNotificationName 
         object:nil];
         }*/
    }
    return self;
} 

@end
