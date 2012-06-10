//
//  GameCenterHelper.h
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@protocol GameCenterHelperDelegate 
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
@end

@interface GameCenterHelper : NSObject<GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
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

@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GameCenterHelperDelegate> delegate;

//@property (assign, readonly) BOOL gameCenterAvailable;

@end
