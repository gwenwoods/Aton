//
//  PlayerViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface PlayerViewController ()
@end

@implementation PlayerViewController
@synthesize delegatePlayerView;
@synthesize boardScreen;

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
    
    
  //  [self rotateImage:imageToMove duration:3.0 
  //             curve:UIViewAnimationCurveEaseIn degrees:180];
    
    //-----------
    
    enterNameView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 748.0)];
    [enterNameView setBackgroundColor:[UIColor blackColor]];
  //  enterNameView.alpha = 0.5;
    [self.view addSubview:enterNameView];
    enterNameView.hidden = YES;
    
    NSArray *myImages = [NSArray arrayWithObjects:
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

    UIImageView *flameIV = [[UIImageView alloc] initWithFrame:CGRectMake(700,100,200,200)];
    [enterNameView addSubview:flameIV];
    
    UIImageView *handleAnimationIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    handleAnimationIV.alpha = 1.0;
    handleAnimationIV.animationImages = myImages;
    handleAnimationIV.animationDuration = 7.0; // seconds
    handleAnimationIV.animationRepeatCount = 0; // 0 = loops forever
    [handleAnimationIV startAnimating];
    [flameIV addSubview:handleAnimationIV];
    
    
    enterNameLb = [[UILabel alloc] initWithFrame:CGRectMake(200,100,400,60)];
    enterNameLb.backgroundColor = [UIColor clearColor];
    enterNameLb.textColor = [UIColor whiteColor];
    enterNameLb.text = @"Enter Player Name";
    enterNameLb.textAlignment = UITextAlignmentCenter;
   // enterNameLb.font = [UIFont fontWithName:@"Courier" size:30];
    enterNameLb.font = [UIFont fontWithName:@"Courier" size:30];
    [enterNameView addSubview:enterNameLb];
    
    enterNameTextField =  [[UITextField alloc] initWithFrame:CGRectMake(200,200,400,60)];
    enterNameTextField.backgroundColor = [UIColor whiteColor];
    enterNameTextField.userInteractionEnabled = YES;
    enterNameTextField.textAlignment = UITextAlignmentLeft;
    enterNameTextField.font = [UIFont fontWithName:@"Courier" size:30];
    [enterNameTextField addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    enterNameTextField.delegate = self;
    [enterNameView addSubview:enterNameTextField];

    redNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    redNameButton.frame = CGRectMake(190,360,238,123);
    redNameButton.userInteractionEnabled = YES;
    redNameButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:20];
    [redNameButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    [redNameButton setTitle:redName  forState:UIControlStateNormal];
    [redNameButton addTarget:self action:@selector(setRedName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redNameButton];

    blueNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blueNameButton.frame = CGRectMake(601,360,238,123);
    blueNameButton.userInteractionEnabled = YES;
    blueNameButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:20];
    [blueNameButton setBackgroundImage:[UIImage imageNamed:@"name_frame.png"] forState:UIControlStateNormal];
    [blueNameButton setTitle:blueName  forState:UIControlStateNormal];
    [blueNameButton addTarget:self action:@selector(setBlueName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueNameButton];
    
    
    //----------
    // audio when starting to  play
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chime.mp3", [[NSBundle mainBundle] resourcePath]]];
	audioPlayerChime = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	audioPlayerChime.numberOfLoops = 0;
    audioPlayerChime.volume = 0.5;
    [audioPlayerChime prepareToPlay];
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
	//[self dismissModalViewControllerAnimated:YES];
    [delegatePlayerView dismissPlayerViewWithAnimation:self];
}

-(void) toMain {
    [delegatePlayerView dismissPlayerViewWithAnimation:self];
}
-(IBAction) toPlay:(id)sender {

 //   BoardViewController *screen = [[BoardViewController alloc] initWithNibNameAndPara:@"BoardViewController_iPad" bundle:nil red:redName blue:blueName];
    boardScreen = [[BoardViewController alloc] initWithNibNameAndPara:@"BoardViewController_iPad" bundle:nil red:redName blue:blueName];
    boardScreen.delegateBoardView = self;
    boardScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:boardScreen animated:YES];
    [audioPlayerChime play];
//	[self dismissModalViewControllerAnimated:YES];
}


- (void)dismissBoardViewWithAnimation:(BoardViewController *)subcontroller
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

/*
-(IBAction)dismissKeyboard: (id)sender {
    NSLog(@"Hit me!");
    [sender resignFirstResponder];
  
} */

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Hide Keyboard");
    enterNameView.hidden = YES;
    NSString* name = enterNameTextField.text;
    name = [name stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length == 0) {
        return;
    }
    if (updateRed == YES) {
      //  [redNameButton setTitle:name forState:UIControlStateNormal];
        redName = name;
        [redNameButton setTitle:redName forState:UIControlStateNormal];
    } else {
      //  [blueNameButton setTitle:name forState:UIControlStateNormal];
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

-(void) toEnterNameView {
    enterNameView.hidden = NO;
    enterNameView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:enterNameView];
    
    enterNameTextField.text = @"";
    [enterNameTextField becomeFirstResponder];
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
@end
