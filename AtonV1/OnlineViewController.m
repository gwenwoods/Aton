//
//  OnlineViewController.m
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnlineViewController.h"

@implementation OnlineViewController
//@synthesize match;
@synthesize boardScreen;
@synthesize delegateOnlineView;
@synthesize playGameButton, label;
@synthesize localRandomNum, remoteRandomNum;

static int AFTER_PEEP_DELAY_TIME = 2.0;
//@synthesize localPlayer, remotePlayer;

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

/*
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
*/
//---------------------------------------------
//#pragma mark GKMatchDelegate
/*
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
*/



//--------------
// UI Outlet
-(IBAction) playGame:(id)sender {
    playGameButton.hidden = YES;
    [self sendRandomNumber];
    [self checkGameStart];
}

//-----------------


/*-(void) communicateWithRemotePlayer {
    GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:5]:@"Morning"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameData];
    GameData *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@" num = %d ", [receivedData.randomNum intValue]);
    NSLog(@" %@",[receivedData str]);
}*/

- (void) showMatchViewController {
    gameCenterStateEnum = GAME_CENTER_WAITING_FIND_MATCH;
    [[GameCenterHelper sharedInstance] displayMatchViewController:self delegate:self];
}

-(void) sendRandomNumber {
     localRandomNum = arc4random()%10000;
    // [(OnlineViewController* )presentingViewController setLocalRandomNum:localRandomNum];
    localPlayerName = [GKLocalPlayer localPlayer].alias;
    GameData *gameData = [[GameData alloc] initWithPara:[NSNumber numberWithInt:localRandomNum]:localPlayerName];
  //  NSLog(@"local player name %@", localPlayer.alias);
    [[GameCenterHelper sharedInstance] sendGameData:gameData];
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
        return;
    }
    
    [self goToAtonGameView];
}

-(void) goToAtonGameView {
    
    gameCenterStateEnum = GAME_CENTER_PLAYING;
    
  //  localPlayer = [GKLocalPlayer localPlayer];
    NSLog(@"local player enum = %d", localPlayerEnum);
  //  NSLog(@"remote player name = %@", remotePlayer.alias);
    onlinePara = [[OnlineParameters alloc] initWithPara:nil:localPlayerName:remotePlayerName:localPlayerEnum];
    //  onlinePara = [[OnlineParameters alloc] initWithPara:match:localPlayer.alias:remotePlayer.alias:localPlayerEnum];
    boardScreen = [[BoardViewController alloc] initWithOnlinePara:onlinePara];
    boardScreen.delegateBoardView = self;
    boardScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:boardScreen animated:YES];
}
/*
-(void) checkAuthentication {
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        label.text = @"Game center account required to play online";
    } else {
        [self performSelector:@selector(showMatchViewController) withObject:nil afterDelay:2.0];
    }
}*/



//---------------------------------
// GameCenterHelper delegate
- (void) receivedGameData:(GameData*)gameData {
    
    if (gameCenterStateEnum == GAME_CENTER_WAITING_RANDOM_NUMBER) {
        if (gameData.randomNum == nil) {
            return;
        }
        remoteRandomNum = [gameData.randomNum intValue];
        remotePlayerName = gameData.str;
        NSLog(@" in OVC, remote player name = %@", remotePlayerName);
        gameCenterStateEnum = GAME_CENTER_WAITING_GAME_START;
        [self checkGameStart];
       
    } else if (gameCenterStateEnum == GAME_CENTER_PLAYING) {
        AtonGameParameters *para = boardScreen.atonParameters;
        AtonGameEngine *engine = boardScreen.atonGameEngine;
        para.onlinePara.remoteGamePhaseEnum = gameData.gamePhaseEnum.intValue;
        
        NSLog(@"remote game phase enum : %d ", para.onlinePara.remoteGamePhaseEnum);
        NSMutableArray *nsCardArray = gameData.cardNumArray;
        
        if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_BLUE_CLOSE_CARD) {
            AtonPlayer *bluePlayer = [para.playerArray objectAtIndex:PLAYER_BLUE];
            int *remoteNumberArray = malloc(sizeof(int)*4);
            for (int i=0; i < 4; i++) {
                remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
            }
            [bluePlayer setCardNumberArray:remoteNumberArray];
            
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD) {
                para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
                engine.gameManager.messagePlayerEnum = PLAYER_NONE;
                [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:[engine.messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
            //    [engine run];
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_RED_CLOSE_CARD) {
            AtonPlayer *redPlayer = [para.playerArray objectAtIndex:PLAYER_RED];
            int *remoteNumberArray = malloc(sizeof(int)*4);
            for (int i=0; i < 4; i++) {
                remoteNumberArray[i] = [[nsCardArray objectAtIndex:i] intValue];
            }
            [redPlayer setCardNumberArray:remoteNumberArray];
            
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_ARRANGE_CARD) {
                para.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
                engine.gameManager.messagePlayerEnum = PLAYER_NONE;
                [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:[engine.messageMaster getMessageForEnum:MSG_COMPARE_RESULTS] afterDelay:1.0];
                
             //   [engine run];
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
            para.removePeepData = gameData;
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_REMOVE) {
                
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remoteRemovePeeps1:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_FIRST_REMOVE_PEEP;
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
            para.removePeepData = gameData;
            // fix here ... just copy the first case
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_REMOVE) {
                
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remoteRemovePeeps2:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_SECOND_REMOVE_PEEP;
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
            para.placePeepData = gameData;
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_PLACE) {
                
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remotePlacePeeps1:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_FIRST_PLACE_PEEP;
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
            para.placePeepData = gameData;
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_PLACE) {
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remotePlacePeeps2:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_SECOND_PLACE_PEEP;
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
            para.firstRemove4Data = gameData;
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_REMOVE_4) {
                
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remoteFirstRemove4:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_FIRST_REMOVE_4;
            }
        } else if (para.onlinePara.remoteGamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
            para.secondRemove4Data = gameData;
            if (para.gamePhaseEnum == GAME_PHASE_WAITING_FOR_REMOTE_REMOVE_4) {
                
                NSMutableArray *allSelectedSlots = [TempleUtility selectSlotFromLiteSlotArray:para.templeArray:gameData.liteSlotArray];
                [self performSelector:@selector(remoteSecondRemove4:) withObject:allSelectedSlots afterDelay:2.0];
                para.gamePhaseEnum = GAME_PHASE_ROUND_END_SECOND_REMOVE_4;
            }
        }

    }
}

-(void) remoteRemovePeeps1:(NSMutableArray*) allSelectedSlots {
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;
    [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    
    NSString* msg = [engine.messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
    engine.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
    [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.removePeepData = nil;
}

-(void) remoteRemovePeeps2:(NSMutableArray*) allSelectedSlots {
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;
    [TempleUtility removePeepsToDeathTemple:[para templeArray]:allSelectedSlots:para.audioToDeath];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    
     NSString* msg = [engine.messageMaster getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
    engine.gameManager.messagePlayerEnum = para.atonRoundResult.firstPlayerEnum;
    [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.removePeepData = nil;
}

-(void) remotePlacePeeps1:(NSMutableArray*) allSelectedSlots {
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;
    int occupiedEnum = OCCUPIED_RED;
    if (para.atonRoundResult.firstPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        [selectedSlot placePeep:occupiedEnum];
    }
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
    if ([engine.gameManager gameOverConditionSuper] != nil) {
        // TODO: Q? do we need this if ?
        [engine.gameManager performSelector:@selector(showFinalResultView:) withObject:[engine.gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else {
        NSString* msg = [engine.messageMaster getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
        engine.gameManager.messagePlayerEnum = para.atonRoundResult.secondPlayerEnum;
        [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        //[firstPlayer closeMenu];
    }
    para.placePeepData = nil;
}

-(void) remotePlacePeeps2:(NSMutableArray*) allSelectedSlots {
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;
    int occupiedEnum = OCCUPIED_RED;
    if (para.atonRoundResult.secondPlayerEnum == PLAYER_BLUE) {
        occupiedEnum = OCCUPIED_BLUE;
    }
    
    for (int i=0; i < [allSelectedSlots count]; i++) {
        TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
        [selectedSlot placePeep:occupiedEnum];
    }
    [TempleUtility disableAllTempleSlotInteractionAndFlame:[para templeArray]];
    
    if ([engine.gameManager gameOverConditionSuper] != nil) {
        [engine.gameManager performSelector:@selector(showFinalResultView:) withObject:[engine.gameManager gameOverConditionSuper] afterDelay:0.0];
        
    } else if ([TempleUtility isDeathTempleFull:[para templeArray]]) {
        para.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[para templeArray]];
        
        para.gamePhaseEnum = GAME_PHASE_ROUND_END_DEATH_FULL;
        engine.gameManager.messagePlayerEnum = PLAYER_NONE;
        [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:[engine.messageMaster getMessageForEnum:MSG_DEAD_KINGDOM_FULL] afterDelay:AFTER_PEEP_DELAY_TIME];
    } else {
        engine.gameManager.messagePlayerEnum = PLAYER_NONE;
        [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:[engine.messageMaster getMessageForEnum:MSG_TURN_END] afterDelay:AFTER_PEEP_DELAY_TIME];
        
    }
    para.placePeepData = nil;
}

-(void) remoteFirstRemove4:(NSMutableArray*) allSelectedSlots {
    
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;

    [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
    
    [TempleUtility disableTemplesFlame:[para templeArray]];
    engine.gameManager.messagePlayerEnum = para.atonRoundResult.lowerScorePlayer;
    NSString* msg = [engine.messageMaster getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
    [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
    para.firstRemove4Data = nil;
}

-(void) remoteSecondRemove4:(NSMutableArray*) allSelectedSlots {
    
    AtonGameParameters *para = boardScreen.atonParameters;
    AtonGameEngine *engine = boardScreen.atonGameEngine;
    
    [TempleUtility removePeepsToSupply:[para templeArray]:allSelectedSlots];
    [TempleUtility disableTemplesFlame:[para templeArray]];
    engine.gameManager.messagePlayerEnum = PLAYER_NONE;
    [engine.gameManager performSelector:@selector(showGamePhaseView:) withObject:[engine.messageMaster getMessageForEnum:MSG_NEW_ROUND_BEGIN] afterDelay:AFTER_PEEP_DELAY_TIME];
    para.secondRemove4Data = nil;
    
}
- (void)matchFound {
    
    if (gameCenterStateEnum != GAME_CENTER_WAITING_FIND_MATCH) {
        return;
    }
    NSLog(@"Match Hola");
    NSLog(@"Match found ... in online view");
   // [self dismissModalViewControllerAnimated:YES];
   // match = theMatch;
   // match.delegate = self;
    
    gameCenterStateEnum = GAME_CENTER_WAITING_RANDOM_NUMBER;
    playGameButton.hidden = NO;
    label.hidden = NO;

}
- (void)matchStarted{}
- (void)matchEnded{}

//------------------------------
// Board view delegate
- (void)dismissBoardViewWithoutAnimation:(BoardViewController *)subcontroller
{
    NSLog(@"Board View Back to Player View");
    [self dismissModalViewControllerAnimated:NO];
    [delegateOnlineView dismissOnlineViewWithoutAnimation:self];
}

@end
