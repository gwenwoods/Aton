//
//  PlayerViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

// This is defined in Math.h
//#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
//#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface PlayerViewController ()
@end

@implementation PlayerViewController
@synthesize delegatePlayerView;
@synthesize boardScreen;
@synthesize audioEnterName;

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
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Do any additional setup after loading the view from its nib.
    NSString* playerViewFont = @"Papyrus";
    
    redName = @"Player Red";
    blueName = @"Player Blue";
    
    rotateIV =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ankh_small.png"]];
    rotateIV.frame = CGRectMake(490, 200, 45, 64);
    [self.view addSubview:rotateIV];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:8];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	[NSTimer scheduledTimerWithTimeInterval: 0.005 target: self selector:@selector(hadleTimer:) userInfo: nil repeats: YES];
	[UIView commitAnimations];
    
    
    //-----------
    maskIV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 748.0)];
    [maskIV setBackgroundColor:[UIColor blackColor]];
    maskIV.alpha = 0.75;
    [self.view addSubview:maskIV];
    maskIV.hidden = YES;
    
    enterNameView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 748.0)];
    [enterNameView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:enterNameView];
    enterNameView.hidden = YES;
    
    NSArray *redImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"Redflame1.png"],
                [UIImage imageNamed:@"Redflame2.png"],
                [UIImage imageNamed:@"Redflame3.png"],
                [UIImage imageNamed:@"Redflame4.png"],
                [UIImage imageNamed:@"Redflame5.png"],
                [UIImage imageNamed:@"Redflame6.png"],
                [UIImage imageNamed:@"Redflame7.png"],
                [UIImage imageNamed:@"Redflame8.png"],
                [UIImage imageNamed:@"Redflame9.png"],
                [UIImage imageNamed:@"Redflame10.png"],
                [UIImage imageNamed:@"Redflame11.png"],
                [UIImage imageNamed:@"Redflame12.png"],
                [UIImage imageNamed:@"Redflame13.png"],
                [UIImage imageNamed:@"Redflame14.png"],
                nil];
    
    NSArray *blueImages = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"blueFlame1.png"],
                  [UIImage imageNamed:@"blueFlame2.png"],
                  [UIImage imageNamed:@"blueFlame3.png"],
                  [UIImage imageNamed:@"blueFlame4.png"],
                  [UIImage imageNamed:@"blueFlame5.png"],
                  [UIImage imageNamed:@"blueFlame6.png"],
                  [UIImage imageNamed:@"blueFlame7.png"],
                  [UIImage imageNamed:@"blueFlame8.png"],
                  [UIImage imageNamed:@"blueFlame9.png"],
                  [UIImage imageNamed:@"blueFlame10.png"],
                  [UIImage imageNamed:@"blueFlame11.png"],
                  [UIImage imageNamed:@"blueFlame12.png"],
                  nil];


    enterNameIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(700,100,200,200)];
    [enterNameView addSubview:enterNameIconIV];
    
    redAnimationIV = [[UIImageView alloc] initWithFrame:CGRectMake(-20,-20,240,240)];
    redAnimationIV.alpha = 1.0;
    redAnimationIV.animationImages = redImages;
    redAnimationIV.animationDuration = 2.8; // seconds
    redAnimationIV.animationRepeatCount = 0; // 0 = loops forever
    [redAnimationIV startAnimating];
    [enterNameIconIV addSubview:redAnimationIV];
    
    blueAnimationIV = [[UIImageView alloc] initWithFrame:CGRectMake(-20,-20,240,240)];
    blueAnimationIV.alpha = 1.0;
    blueAnimationIV.animationImages = blueImages;
    blueAnimationIV.animationDuration = 2.4; // seconds
    blueAnimationIV.animationRepeatCount = 0; // 0 = loops forever
    [blueAnimationIV startAnimating];
    [enterNameIconIV addSubview:blueAnimationIV];
    
    
    enterNameLb = [[UILabel alloc] initWithFrame:CGRectMake(200,124,400,60)];
    enterNameLb.backgroundColor = [UIColor clearColor];
    enterNameLb.textColor = [UIColor whiteColor];
    enterNameLb.text = @"Please Enter Player Name";
    enterNameLb.textAlignment = UITextAlignmentCenter;
    enterNameLb.font = [UIFont fontWithName:playerViewFont size:30];
    [enterNameView addSubview:enterNameLb];
    
    enterNameTextField =  [[UITextField alloc] initWithFrame:CGRectMake(200,200,400,60)];
    enterNameTextField.backgroundColor = [UIColor whiteColor];
    enterNameTextField.userInteractionEnabled = YES;
    enterNameTextField.textAlignment = UITextAlignmentLeft;
    enterNameTextField.font = [UIFont fontWithName:playerViewFont size:36];
    [enterNameTextField addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    enterNameTextField.delegate = self;
    [enterNameView addSubview:enterNameTextField];

    redNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    redNameButton.frame = CGRectMake(190,360,238,123);
    redNameButton.userInteractionEnabled = YES;
    redNameButton.titleLabel.font = [UIFont fontWithName:playerViewFont size:24];
    [redNameButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    [redNameButton setTitle:redName  forState:UIControlStateNormal];
    [redNameButton addTarget:self action:@selector(setRedName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redNameButton];

    blueNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blueNameButton.frame = CGRectMake(601,360,238,123);
    blueNameButton.userInteractionEnabled = YES;
    blueNameButton.titleLabel.font = [UIFont fontWithName:playerViewFont size:24];
    [blueNameButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    [blueNameButton setTitle:blueName  forState:UIControlStateNormal];
    [blueNameButton addTarget:self action:@selector(setBlueName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueNameButton];
    
    useAIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useAIButton.frame = CGRectMake(620,60,200,62);
    useAIButton.userInteractionEnabled = YES;
    useAIButton.titleLabel.font = [UIFont fontWithName:playerViewFont size:24];
   // [useAIButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    [useAIButton setImage:[UIImage imageNamed:@"Button_Human.png"]   forState:UIControlStateNormal];
    [useAIButton addTarget:self action:@selector(chooseAIPlayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useAIButton];
    //----------
    // audio when starting to  play
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chime.mp3", [[NSBundle mainBundle] resourcePath]]];
	audioPlayerChime = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	audioPlayerChime.numberOfLoops = 0;
    audioPlayerChime.volume = 0.5;
    [audioPlayerChime prepareToPlay];
    
    //----------
    // enterName view
    NSURL *urlEnterName = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/cherokee_war_drum.aiff", [[NSBundle mainBundle] resourcePath]]];
	audioEnterName = [[AVAudioPlayer alloc] initWithContentsOfURL:urlEnterName error:nil];
	audioEnterName.numberOfLoops = 1000;
    audioEnterName.volume = 0.5;
    [audioEnterName prepareToPlay];
    
    NSURL *urlSwitch = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/switch-22.aiff", [[NSBundle mainBundle] resourcePath]]];
	audioSwitch = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSwitch error:nil];
	audioSwitch.numberOfLoops = 0;
    audioSwitch.volume = 1.0;
    [audioSwitch prepareToPlay];
    
    [self performSelector:@selector(playOpenMusic) withObject:nil afterDelay:3.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
    [self performSelector:@selector(fadeVolumeUp:) withObject:audioEnterName afterDelay:3.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
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

-(IBAction) backToMenu:(id)sender {
    if (audioEnterName.isPlaying){
        [audioEnterName stop];
    } else {
        audioEnterName = nil;
    }
    [delegatePlayerView dismissPlayerViewWithAnimation:self];
}

//-(void) toMain {
//    [delegatePlayerView dismissPlayerViewWithAnimation:self];
//}

-(IBAction) toPlay:(id)sender {

    if (audioEnterName.isPlaying) 
    {
        [audioEnterName stop];

      //  [self performSelector:@selector(fadeVolumeDownQuick:) withObject:audioPlayerOpen afterDelay:0.0 inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
    } else {
        audioEnterName = nil;
    }
    boardScreen = [[BoardViewController alloc] initWithNibNameAndPara:@"BoardViewController_iPad" bundle:nil red:redName blue:blueName:useAI];
    boardScreen.delegateBoardView = self;
    boardScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:boardScreen animated:YES];
    [audioPlayerChime play];
}


- (void)dismissBoardViewWithoutAnimation:(BoardViewController *)subcontroller
{
    NSLog(@"Board View Back to Player View");
    [self dismissModalViewControllerAnimated:NO];
    [delegatePlayerView dismissPlayerViewWithoutAnimation:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"Hit me");
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Hide Keyboard");
    enterNameView.hidden = YES;
    maskIV.hidden = YES;
    NSString* name = enterNameTextField.text;
    name = [name stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length == 0) {
        return;
    }
    if (updateRed == YES) {
        redName = name;
        [redNameButton setTitle:redName forState:UIControlStateNormal];
    } else {
        blueName = name;
        [blueNameButton setTitle:blueName forState:UIControlStateNormal];
    }
    
   
}

-(IBAction) setRedName:(id)sender {
    updateRed = YES;
    updateBlue = NO;
    [self toEnterNameView];
}

-(IBAction) setBlueName:(id)sender {
    updateBlue = YES;
    updateRed = NO;
    [self toEnterNameView];
}

-(IBAction) chooseAIPlayer:(id)sender {
    [audioSwitch play];
    if (useAI) {
        useAI = NO;
        [useAIButton setImage:[UIImage imageNamed:@"Button_Human.png"]   forState:UIControlStateNormal];
        blueName = @"Player Blue";
        blueNameButton.userInteractionEnabled = YES;
        [blueNameButton setTitle:blueName forState:UIControlStateNormal];
    } else {
        useAI = YES;
        [useAIButton setImage:[UIImage imageNamed:@"Button_AI.png"]   forState:UIControlStateNormal];
        blueName = @" A.I.";
        blueNameButton.userInteractionEnabled = NO;
        [blueNameButton setTitle:blueName forState:UIControlStateNormal];
    }
}

-(void) toEnterNameView {
    maskIV.hidden = NO;
    enterNameView.hidden = NO;
    enterNameView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:maskIV];
    [self.view bringSubviewToFront:enterNameView];
    
    enterNameTextField.text = @"";
    [enterNameTextField becomeFirstResponder];
    
    if (updateRed == YES) {
        enterNameIconIV.image = [UIImage imageNamed:@"Red_icon_big.png"];
        redAnimationIV.hidden = NO;
        blueAnimationIV.hidden = YES;
    } else {
        // must be updatedBlue
        enterNameIconIV.image = [UIImage imageNamed:@"Blue_icon_big.png"];
        redAnimationIV.hidden = YES;
        blueAnimationIV.hidden = NO;
    }
    
    
}

-(void)hadleTimer:(NSTimer *)timer
{
	angle += 0.005;
	if (angle > 6.283) { 
		angle = 0;
	}
	
	CGAffineTransform transform=CGAffineTransformMakeRotation(angle);
	rotateIV.transform = transform;
}

-(void) playOpenMusic {
    [audioEnterName play];
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
@end
