//
//  GameCenterHelper.h
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "OnlineViewController.h"

enum GAME_CENTER_STATE_ENUM {
    GAME_CENTER_WAITING_LOCAL_AUTHENTICATION,
    GAME_CENTER_WAITING_FIND_MATCH,
    GAME_CENTER_WAITING_RANDOM_NUMBER,
    GAME_CENTER_WAITING_GAME_START
};


@protocol GameCenterHelperDelegate 
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
@end

@interface GameCenterHelper : NSObject<GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    int gameCenterStateEnum;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    __unsafe_unretained id <GameCenterHelperDelegate> delegate;
}

+(void) test1;
+(GameCenterHelper *)sharedInstance;
-(void)authenticateLocalUser;
-(void)authenticationChanged;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController 
                       delegate:(id<GameCenterHelperDelegate>)theDelegate;
-(void)displayMatchViewController:(UIViewController *) viewController 
                         delegate:(id<GameCenterHelperDelegate>)theDelegate;
-(void) sendRandomNumber;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GameCenterHelperDelegate> delegate;

//@property (assign, readonly) BOOL gameCenterAvailable;

@end
