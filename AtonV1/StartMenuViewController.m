//
//  StartMenuViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartMenuViewController.h"

@interface StartMenuViewController ()
@end

@implementation StartMenuViewController
@synthesize playerViewScreen, creditViewScreen, ruleViewScreen;
@synthesize audioPlayerOpen;

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
    // Do any additional setup after loading the view from its nib.
    
    NSURL *urlOpen = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/OpenMusic_Aton_new.wav", [[NSBundle mainBundle] resourcePath]]];
	audioPlayerOpen = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOpen error:nil];
	audioPlayerOpen.numberOfLoops = 1000;
    audioPlayerOpen.volume = 1.0;
    [audioPlayerOpen prepareToPlay];

    [self performSelector:@selector(playOpenMusic) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
 //   [self performSelector:@selector(fadeVolumeUp:) withObject:audioPlayerOpen afterDelay:1.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
 //   [self performSelector:@selector(fadeVolumeDown:) withObject:audioPlayerOpen afterDelay:27.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];

    //-----------------------------
    // audio when starting to  play
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chime.mp3", [[NSBundle mainBundle] resourcePath]]];
	audioPlayerEnterPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	audioPlayerEnterPlay.numberOfLoops = 0;
    audioPlayerEnterPlay.volume = 0.5;
    [audioPlayerEnterPlay prepareToPlay];
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

-(void) showPlayAnimation {
    playAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         playAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(void) showRulesAnimation {
    rulesAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         rulesAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}


-(void) showCreditsAnimation {
    creditsAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         creditsAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(void) fadeCreditsAnimation {
    creditsAnkhIV.alpha = 1.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         creditsAnkhIV.alpha = 0.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([self isWithinImgView:touchLocation:playIV]) {
        playAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = nil;
        [self showPlayAnimation];
    } else {
        playAnkhIV.image = nil;
    }
    
    if ([self isWithinImgView:touchLocation:rulesIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        creditsAnkhIV.image = nil;
        [self showRulesAnimation];
        
    } else {
        rulesAnkhIV.image = nil;
    }
    
    if ([self isWithinImgView:touchLocation:creditsIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        [self showCreditsAnimation];
        
    } else {
        creditsAnkhIV.image = nil;
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([self isWithinImgView:touchLocation:playIV]) {
        if (playAnkhIV.image == nil) {
            [self showPlayAnimation];
        }
        playAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = nil;
        
    } else {
        playAnkhIV.image = nil;
    }

    
    if ([self isWithinImgView:touchLocation:rulesIV]) {
        playAnkhIV.image = nil;
        if (rulesAnkhIV.image == nil) {
            [self showRulesAnimation];
        }
        rulesAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        creditsAnkhIV.image = nil;
        
    } else {
        rulesAnkhIV.image = nil;
    }
    
    if ([self isWithinImgView:touchLocation:creditsIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = nil;
        if (creditsAnkhIV.image == nil) {
            [self showCreditsAnimation];
        }
        creditsAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        
    } else {
     //   if (creditsAnkhIV.image != nil) {
     //       [self fadeCreditsAnimation];
     //   } else{
            creditsAnkhIV.image = nil;
     //   }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
            CGPoint touchLocation = [touch locationInView:self.view];
		    if ([self isWithinImgView:touchLocation:playIV]) {
                
                if (audioPlayerOpen.isPlaying) {
                    [self performSelector:@selector(fadeVolumeDownQuick:) withObject:audioPlayerOpen afterDelay:0.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
                } else {
                    audioPlayerOpen = nil;
                }

                playerViewScreen = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
                playerViewScreen.delegatePlayerView = self;
                playerViewScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:playerViewScreen animated:YES];
                playAnkhIV.image = nil;
            }
            
            if ([self isWithinImgView:touchLocation:rulesIV]) {
                
                if (audioPlayerOpen.isPlaying) {
                    [self performSelector:@selector(fadeVolumeDown:) withObject:audioPlayerOpen afterDelay:0.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
                } else {
                    audioPlayerOpen = nil;
                }
                
                ruleViewScreen = [[RuleViewController alloc] initWithNibName:nil bundle:nil];
                ruleViewScreen.delegateRuleView = self;
                ruleViewScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:ruleViewScreen animated:YES];

                rulesAnkhIV.image = nil;
            }
            
            if ([self isWithinImgView:touchLocation:creditsIV]) {
                
                if (audioPlayerOpen.isPlaying) {
                    [self performSelector:@selector(fadeVolumeDown:) withObject:audioPlayerOpen afterDelay:0.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
                } else {
                    audioPlayerOpen = nil;
                }
                
                creditViewScreen = [[CreditViewController alloc] initWithNibName:nil bundle:nil];
                creditViewScreen.delegateCreditView = self;
                creditViewScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:creditViewScreen animated:YES];
                creditsAnkhIV.image = nil;
            }
		}
	}
}

-(BOOL) isWithinImgView:(CGPoint) point:(UIImageView*)iv1 {
	// check if iv0 is within iv1
	int x0 = point.x;
	int y0 = point.y;
	
	int x1 = iv1.center.x;
	int y1 = iv1.center.y;
	int w1 = [iv1 frame].size.width/2.0;
	int h1 = [iv1 frame].size.height/2.0;
	
	if ( (x0 > x1-w1) && (x0 < x1+w1) && (y0 > y1-h1) && (y0 < y1+h1) ) {
	    return YES;		
	}
	return NO;
}

/*-(IBAction) toPlayerView:(id)sender {
    PlayerViewController *screen = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
}*/

- (void)fadeVolumeDownQuick:(AVAudioPlayer *)aPlayer
{
    aPlayer.volume = aPlayer.volume - 0.04;
    if (aPlayer.volume < 0.01) {
        [aPlayer stop];         
    } else {
        [self performSelector:@selector(fadeVolumeDownQuick:) withObject:aPlayer afterDelay:0.1];  
    }
}

- (void)fadeVolumeDown:(AVAudioPlayer *)aPlayer
{
    aPlayer.volume = aPlayer.volume - 0.025;
    if (aPlayer.volume < 0.01) {
        [aPlayer stop];         
    } else {
        [self performSelector:@selector(fadeVolumeDown:) withObject:aPlayer afterDelay:0.1];  
    }
}

- (void)fadeVolumeUp:(AVAudioPlayer *)aPlayer
{    
    aPlayer.volume = aPlayer.volume + 0.025;
    if (aPlayer.volume > 1.0) {
        //[aPlayer stop]; 
        return;
    } else {
        [self performSelector:@selector(fadeVolumeUp:) withObject:aPlayer afterDelay:0.1];  
    }
}



-(void) playOpenMusic {
    [audioPlayerOpen play];
}

/*
- (void)clickedButton:(BoardViewController *)subcontroller
{
     NSLog(@"Back to start menu");
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
}*/

//--------------------------------
// PlayerView delegate functions
- (void)dismissPlayerViewWithAnimation:(PlayerViewController *)subcontroller
{
    NSLog(@"Player View Back to Start Menu");
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
    self.playerViewScreen = nil;
}

- (void)dismissPlayerViewWithoutAnimation:(PlayerViewController *)subcontroller
{
    NSLog(@"Player View Back to Start Menu");
    [self dismissModalViewControllerAnimated:NO];
    [self viewDidLoad];
    self.playerViewScreen = nil;
}

//------------------------------
// RuleView delegate functions
- (void)dismissRuleViewWithAnimation:(RuleViewController *)subcontroller
{
    NSLog(@"Rule View Back to Start Menu");
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
    self.ruleViewScreen = nil;
}

- (void)dismissRuleViewWithoutAnimation:(RuleViewController *)subcontroller
{
    NSLog(@"Rule View Back to Start Menu");
    [self dismissModalViewControllerAnimated:NO];
    [self viewDidLoad];
    self.ruleViewScreen = nil;
}

//------------------------------
// CreditView delegate functions
- (void)dismissCreditViewWithAnimation:(CreditViewController *)subcontroller
{
    NSLog(@"Credit View Back to Start Menu");
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
    self.creditViewScreen = nil;
}

- (void)dismissCreditViewWithoutAnimation:(CreditViewController *)subcontroller
{
    NSLog(@"Credit View Back to Start Menu");
    [self dismissModalViewControllerAnimated:NO];
    [self viewDidLoad];
    self.creditViewScreen = nil;
}
@end
