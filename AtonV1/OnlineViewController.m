//
//  OnlineViewController.m
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnlineViewController.h"

@interface OnlineViewController ()

@end

@implementation OnlineViewController
@synthesize match;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(600, 200, 300, 100)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.userInteractionEnabled = YES;
    textField.hidden = YES;
    [self.view addSubview:textField];
    
    sendMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendMessageButton.frame = CGRectMake(800,400,100,60);
    sendMessageButton.userInteractionEnabled = YES;
    [sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
    //  gameCenterButton.titleLabel.font = [UIFont fontWithName:playerViewFont size:24];
    // [useAIButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    //  [useAIButton setImage:[UIImage imageNamed:@"Button_Human.png"]   forState:UIControlStateNormal];
    [sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendMessageButton.hidden = YES;
    [self.view addSubview:sendMessageButton];

    
    match = nil;
    
    [[GameCenterHelper sharedInstance] authenticateLocalUser];
   // [self showMatchViewController];
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


//#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    NSLog(@"match cancelled "); 
    [self dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    
    NSLog(@"Error finding match: %@", error.localizedDescription); 
    [self dismissModalViewControllerAnimated:YES];
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [self dismissModalViewControllerAnimated:YES];
    textField.hidden = NO;
    label.hidden = NO;
    sendMessageButton.hidden = NO;
    
    match = theMatch;
    match.delegate = self;
    NSLog(@"expected player = %d", match.expectedPlayerCount);
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match! player count %d", theMatch.playerIDs.count);
        // [self dismissModalViewControllerAnimated:YES];

    }
   // [self lookupPlayers];
}

- (void) showMatchViewController {

    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;

    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    mmvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:mmvc animated:YES];
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
          //  [delegate matchEnded];
        } else {
            
            // Populate players dict
            playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
                NSString *msg = @"   ";
                msg = [msg stringByAppendingString:player.alias];
                msg = [msg stringByAppendingString:@" says HELLO !"];
                
                
                label.text = msg;
                [self.view addSubview:label];
                
            }
            
            // Notify delegate match can begin
            matchStarted = YES;
            //[delegate matchStarted];
            
        }
    }];
    
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    if (match != theMatch) return;
    NSLog(@"received data");
  //  [self match:theMatch didReceiveData:data fromPlayer:playerID];
    NSString *content =[ NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
    if (content == nil) {
        return;
    }
    NSString* msg = [[playersDict objectForKey:playerID] alias];
    msg = [msg stringByAppendingString:@" : "];
    msg = [msg stringByAppendingString:content];
    label.text =msg;
  //  label.text = [label.text stringByAppendingString:msg];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    NSLog(@"woof");
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
          //  [delegate matchEnded];
            break;
    }                     
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
   // [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
   // [delegate matchEnded];
}

//--------------
-(IBAction) sendMessage:(id)sender {
    NSString *myMsg = @"Me : ";
    myMsg = [myMsg stringByAppendingString:textField.text];
    label.text = myMsg;
    
    NSString* str= textField.text;
    NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    [match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    textField.text = @"";
    
}
@end
