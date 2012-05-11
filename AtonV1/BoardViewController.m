//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"


@implementation BoardViewController

//static int MESSAGE_DELAY_TIME = 0.5;
//static int AFTER_PEEP_DELAY_TIME = 2.0;

@synthesize playerRedName, playerBlueName;
@synthesize delegateBoardView;
@synthesize atonGameEngine;
@synthesize atonParameters;
@synthesize touchElement;
//@synthesize redPlayer, bluePlayer;

@synthesize temple1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //delegate1 = [[myDelegate alloc]init];
        //delegate1 = self;
    }
    return self;
}

- (id)initWithNibNameAndPara:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil red:(NSString*)redName blue:(NSString*) blueName 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //delegate1 = [[myDelegate alloc]init];
        //delegate1 = self;
        playerRedName = redName;
        playerBlueName = blueName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    


    NSURL *urlPlayGame = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/BG_sound.aiff", [[NSBundle mainBundle] resourcePath]]];
	audioPlayGame = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPlayGame error:nil];
	audioPlayGame.numberOfLoops = 1000;
    audioPlayGame.volume = 0.25;
    [audioPlayGame prepareToPlay];
    [self performSelector:@selector(playGameMusic) withObject:nil afterDelay:2.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
    
    NSURL *urlPlacePeep = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/switch-22.aiff", [[NSBundle mainBundle] resourcePath]]];
	audioPlacePeep = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPlacePeep error:nil];
	audioPlacePeep.numberOfLoops = 0;
    audioPlacePeep.volume = 1.0;
    [audioPlacePeep prepareToPlay];
  
    NSURL *urlTap = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/button-50.wav", [[NSBundle mainBundle] resourcePath]]];
	audioTap = [[AVAudioPlayer alloc] initWithContentsOfURL:urlTap error:nil];
	audioTap.numberOfLoops = 0;
    audioTap.volume = 1.0;
    [audioTap prepareToPlay];
    
    touchElement = [[AtonTouchElement alloc] initializeWithParameters:self];
    atonParameters = [AtonGameInitializer initializeNewGame:self:playerRedName:playerBlueName];
    atonGameEngine = [[AtonGameEngine alloc] initializeWithParameters:atonParameters];
    
    [atonGameEngine run];
    
    AtonAI *ai = [[AtonAIEasy alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [AtonTouchBeganUtility checkTouch:event:touchElement:atonParameters:atonGameEngine:audioPlacePeep:audioTap];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [AtonTouchMovedUtility moveTouchElement:event:touchElement:self.view];   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
		    [AtonTouchEndUtility playerPlaceCard:touch:touchElement:atonParameters];
		}
	}
}

- (IBAction) toMenu:(id)sender {
 //   [delegateBoardView dismissBoardViewWithoutAnimation:self];
 //   [self dismissModalViewControllerAnimated:YES];
    
    atonParameters.gameManager.quitView.hidden = NO;
}

- (IBAction) quitYes:(id)sender {
    [audioPlayGame stop];
    [delegateBoardView dismissBoardViewWithoutAnimation:self];
}

- (IBAction) quitNo:(id)sender {
    atonParameters.gameManager.quitView.hidden = YES;
}

- (IBAction) doneAction:(id)sender {
    [atonGameEngine playerDoneAction];
}

- (IBAction) exchangeCards:(id)sender {
    atonParameters.gameManager.exchangeCardsView.hidden = NO;
    [self.view bringSubviewToFront:atonParameters.gameManager.exchangeCardsView];
}

- (IBAction) exchangeCardsYes:(id)sender {
    
    AtonPlayer *player = nil;
    if (atonParameters.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        player = [[atonParameters playerArray] objectAtIndex:PLAYER_RED];
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        player = [[atonParameters playerArray] objectAtIndex:PLAYER_BLUE];
        
    } else {
        // Code should never reach here
        return;
    }

    player.exchangeCardsButton.hidden = YES;
    player.scrollExchangeIV.image = [UIImage imageNamed:@"scrollDown_blank.png"];
    [player resetCard];
    [player distributeCards];
    [player performSelector:@selector(openCardsForArrange) withObject:nil afterDelay:3.0];
    
    atonParameters.gameManager.exchangeCardsView.hidden = YES;
}

- (IBAction) exchangeCardsNo:(id)sender {
     atonParameters.gameManager.exchangeCardsView.hidden = YES;
}

-(void) playGameMusic {
    [audioPlayGame play];
}
@end
