//
//  GameCenterHelper.m
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCenterHelper.h"

@implementation GameCenterHelper

@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;

//@synthesize gameCenterAvailable;
static GameCenterHelper *sharedHelper = nil;

+(void) test1 {
    NSLog(@"test1");
}

+(GameCenterHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GameCenterHelper alloc] init];
    }
    return sharedHelper;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

-(void)authenticateLocalUser { 
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];        
    } else {
        NSLog(@"Already authenticated!");
    }
}

-(void)authenticationChanged {    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;           
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
}

-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers   
                 viewController:(UIViewController *)viewController 
                       delegate:(id<GameCenterHelperDelegate>)theDelegate {
    
    if (!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;               
    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];    
    mmvc.matchmakerDelegate = self;
    
    [presentingViewController presentModalViewController:mmvc animated:YES];
    
}

//#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    
    if (gameCenterStateEnum != GAME_CENTER_WAITING_FIND_MATCH) {
        return;
    }
    
    NSLog(@"Match found");
    [presentingViewController dismissModalViewControllerAnimated:YES];
    match = theMatch;
    match.delegate = self;
    
    gameCenterStateEnum = GAME_CENTER_WAITING_RANDOM_NUMBER;
    [(OnlineViewController* )presentingViewController playGameButton].hidden = NO;
    [(OnlineViewController* )presentingViewController label].hidden = NO;
   // label.hidden = NO;

   /* [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
    }*/
}

//#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    NSLog(@"received data ... in gc helper");
    
    if (match != theMatch) return;
    if (gameCenterStateEnum != GAME_CENTER_WAITING_RANDOM_NUMBER) {
        return;
    }
    
    GameData *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (receivedData != nil) {
        int remoteRandomNum = [receivedData.randomNum intValue];
        [(OnlineViewController* )presentingViewController setRemoteRandomNum:remoteRandomNum];
        gameCenterStateEnum = GAME_CENTER_WAITING_GAME_START;
        [(OnlineViewController* )presentingViewController checkGameStart];
    }
    
    // if (match != theMatch) return;
    
   // [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    
    if (match != theMatch) return;
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            [self lookupPlayers];
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            break;
    }                     

    /* if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }  */                   
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}


//--------------
-(void)displayMatchViewController:(UIViewController *) viewController 
                      delegate:(id<GameCenterHelperDelegate>)theDelegate {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated == YES) {
        gameCenterStateEnum = GAME_CENTER_WAITING_FIND_MATCH;
    }
   // delegate = theDelegate;    
    self.presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    mmvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [presentingViewController presentModalViewController:mmvc animated:YES];
    
}

-(void) sendRandomNumber {
    int localRandomNum = arc4random()%10000;
    [(OnlineViewController* )presentingViewController setLocalRandomNum:localRandomNum];
    GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:localRandomNum]:@"Morning"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
    
    NSError *error;
    [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    NSLog(@"send random number ...");
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            
        } else {
            for (GKPlayer *player in players) {
                [(OnlineViewController* )presentingViewController setRemotePlayer:player];
                NSLog(@"Found player: %@", player.alias);
                //[playersDict setObject:player forKey:player.playerID];
                NSString *msg = @"Found player ";
                msg = [msg stringByAppendingString:player.alias];
                // msg = [msg stringByAppendingString:@" says HELLO !"];
                
                
                [(OnlineViewController* )presentingViewController label].text = msg;
                
            }
            
            // Notify delegate match can begin
            // matchStarted = YES;
            //[delegate matchStarted];
            
        }
    }];
}
@end
