//
//  GCHelper.h
//  CatRace
//
//  Created by Wen Lin on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate 
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    __unsafe_unretained id <GCHelperDelegate> delegate;
    NSMutableDictionary *playersDict;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController 
                       delegate:(id<GCHelperDelegate>)theDelegate;

@end
