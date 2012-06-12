//
//  OnlineViewController.m
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnlineViewController.h"

//@interface OnlineViewController ()

//@end

@implementation OnlineViewController
@synthesize match;
@synthesize boardScreen;
@synthesize delegateOnlineView;
@synthesize playGameButton, label;
@synthesize localRandomNum, remoteRandomNum;
@synthesize localPlayer, remotePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gameCenterStateEnum = GAME_CENTER_WAITING_LOCAL_AUTHENTICATION;
        localRandomNum = -1;
        remoteRandomNum = -1;
        localPlayerEnum = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 300, 100)];
    label.textAlignment = UITextLayoutDirectionUp;
    label.hidden = YES;
    [self.view addSubview:label];
    
    playGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playGameButton.frame = CGRectMake(800,600,100,60);
    playGameButton.userInteractionEnabled = YES;
    [playGameButton setTitle:@"Play Game" forState:UIControlStateNormal];
    [playGameButton addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside];
    playGameButton.hidden = YES;
    [self.view addSubview:playGameButton];
    
    [[GameCenterHelper sharedInstance] authenticateLocalUser];
    [self performSelector:@selector(showMatchViewController) withObject:nil afterDelay:2.0];	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


//---------------------------------------------------
//#pragma mark GKMatchmakerViewControllerDelegate
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    NSLog(@"Match cancelled"); 
    [self dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    NSLog(@"Error finding match: %@", error.localizedDescription); 
    [self dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    if (gameCenterStateEnum != GAME_CENTER_WAITING_FIND_MATCH) {
        return;
    }
    
    NSLog(@"Match found");
    [self dismissModalViewControllerAnimated:YES];
    match = theMatch;
    match.delegate = self;
    
    gameCenterStateEnum = GAME_CENTER_WAITING_RANDOM_NUMBER;
    playGameButton.hidden = NO;
    label.hidden = NO;
    
   
}

//---------------------------------------------
//#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    NSLog(@"received data ... in online view");
    
    if (match != theMatch) return;
    if (gameCenterStateEnum != GAME_CENTER_WAITING_RANDOM_NUMBER) {
        return;
    }
    
    GameData *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (receivedData != nil) {
        remoteRandomNum = [receivedData.randomNum intValue];
        gameCenterStateEnum = GAME_CENTER_WAITING_GAME_START;
        [self checkGameStart];
    }
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    if (match != theMatch) return;
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
           //  [self lookupPlayers];
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            break;
    }                     
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    if (match != theMatch) return;
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (match != theMatch) return;
    NSLog(@"Match failed with error: %@", error.localizedDescription);
}


//------------------------------
// Board view delegate
- (void)dismissBoardViewWithoutAnimation:(BoardViewController *)subcontroller
{
    NSLog(@"Board View Back to Player View");
    [self dismissModalViewControllerAnimated:NO];
    [delegateOnlineView dismissOnlineViewWithoutAnimation:self];
}

//--------------
// UI Outlet
-(IBAction) playGame:(id)sender {
    playGameButton.hidden = YES;
    [self sendRandomNumber];
    [self checkGameStart];
}

//-----------------
-(void) goToAtonGameView {
    

    
    localPlayer = [GKLocalPlayer localPlayer];
    NSLog(@"local player enum = %d", localPlayerEnum);
    
    onlinePara = [[OnlineParameters alloc] initWithPara:match:localPlayer.alias:remotePlayer.alias:localPlayerEnum];
    boardScreen = [[BoardViewController alloc] initWithOnlinePara:onlinePara];
    boardScreen.delegateBoardView = self;
    boardScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:boardScreen animated:YES];
   // [audioPlayerChime play];
}

-(void) communicateWithRemotePlayer {
    GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:5]:@"Morning"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
    GameData *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@" num = %d ", [receivedData.randomNum intValue]);
    NSLog(@" %@",[receivedData str]);
}

-(void) checkGameStart {
    NSLog(@"check game start!");
    NSLog(@"local random = %d", localRandomNum);
    NSLog(@"remote random = %d", remoteRandomNum);
    if (localRandomNum < 0 || remoteRandomNum < 0) {
        return;
    }

    if (localRandomNum > remoteRandomNum) {
        localPlayerEnum = 0;
    } else if (localRandomNum < remoteRandomNum) {
        localPlayerEnum = 1;
    } else {
        remoteRandomNum = -1;
        gameCenterStateEnum = GAME_CENTER_WAITING_RANDOM_NUMBER;
        [self sendRandomNumber];
        [self checkGameStart];
    
     /*   localRandomNum = arc4random()%10000;
        GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:localRandomNum]:@"Morning"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
        
        NSError *error;
        [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
        NSLog(@"send data ...");*/
        return;
    }
    
    [self goToAtonGameView];
}

-(void) checkAuthentication {
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        label.text = @"Game center account required to play online";
    } else {
        [self performSelector:@selector(showMatchViewController) withObject:nil afterDelay:2.0];
    }
}

- (void) showMatchViewController {
    
     [[GameCenterHelper sharedInstance] displayMatchViewController:self delegate:self];
    
 /*   if ([GKLocalPlayer localPlayer].isAuthenticated == YES) {
        gameCenterStateEnum = GAME_CENTER_WAITING_FIND_MATCH;
    }
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    mmvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:mmvc animated:YES];*/
}

/*
- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            
        } else {
            for (GKPlayer *player in players) {
                remotePlayer = player;
                NSLog(@"Found player: %@", player.alias);
                //[playersDict setObject:player forKey:player.playerID];
                NSString *msg = @"Found player ";
                msg = [msg stringByAppendingString:player.alias];
               // msg = [msg stringByAppendingString:@" says HELLO !"];
                
                
                label.text = msg;
                
            }
            
            // Notify delegate match can begin
           // matchStarted = YES;
            //[delegate matchStarted];
            
        }
    }];
}*/

-(void) sendRandomNumber {
    [[GameCenterHelper sharedInstance] sendRandomNumber];
   /* localRandomNum = arc4random()%10000;
    GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:localRandomNum]:@"Morning"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
    
    NSError *error;
    [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    NSLog(@"send random number ...");*/
}
@end
