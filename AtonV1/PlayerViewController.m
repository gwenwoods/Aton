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
    
    
    rotateIV =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ankh_small.png"]];
    rotateIV.frame = CGRectMake(460, 40, 45, 64);
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
    [self.view addSubview:enterNameView];
    enterNameView.hidden = YES;
    
    enterNameLb = [[UILabel alloc] initWithFrame:CGRectMake(200,100,400,60)];
    enterNameLb.backgroundColor = [UIColor clearColor];
    enterNameLb.textColor = [UIColor whiteColor];
    enterNameLb.text = @"Enter Player Name";
    enterNameLb.textAlignment = UITextAlignmentCenter;
    enterNameLb.font = [UIFont fontWithName:@"Copperplate" size:30];
    [enterNameView addSubview:enterNameLb];
    
    enterNameTextField =  [[UITextField alloc] initWithFrame:CGRectMake(200,200,400,60)];
    enterNameTextField.backgroundColor = [UIColor whiteColor];
    enterNameTextField.userInteractionEnabled = YES;
    enterNameTextField.textAlignment = UITextAlignmentLeft;
    enterNameTextField.font = [UIFont fontWithName:@"Copperplate" size:30];
    [enterNameTextField addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    enterNameTextField.delegate = self;
    [enterNameView addSubview:enterNameTextField];

    redNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    redNameButton.frame = CGRectMake(200,300,180,40);
    redNameButton.userInteractionEnabled = YES;
    redNameButton.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [redNameButton setTitle:@"Player Red"  forState:UIControlStateNormal];
    [redNameButton addTarget:self action:@selector(setRedName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redNameButton];

    blueNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    blueNameButton.frame = CGRectMake(600,300,180,40);
    blueNameButton.userInteractionEnabled = YES;
    blueNameButton.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [blueNameButton setTitle:@"Player Blue"  forState:UIControlStateNormal];
    [blueNameButton addTarget:self action:@selector(setBlueName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueNameButton];
    
    redName = redNameButton.titleLabel.text;
    blueName = blueNameButton.titleLabel.text;
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

    BoardViewController *screen = [[BoardViewController alloc] initWithNibNameAndPara:@"BoardViewController_iPad" bundle:nil red:redName blue:blueName];
    screen.delegateBoardView = self;
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
    [audioPlayerChime play];
//	[self dismissModalViewControllerAnimated:YES];
}


- (void)clickedButton:(BoardViewController *)subcontroller
{
    NSLog(@"Back to Player View");
    [self dismissModalViewControllerAnimated:NO];
    [delegatePlayerView dismissPlayerViewWithoutAnimation:self];
   // [self performSelector:@selector(toMain) withObject:nil afterDelay:0.1];
   // [self toMain];
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
    
    if (updateRed == YES) {
        [redNameButton setTitle:name forState:UIControlStateNormal];
        redName = name;
    } else {
        [blueNameButton setTitle:name forState:UIControlStateNormal];
        blueName = name;
    }
    
    
}

-(IBAction) setRedName:(id)sender {
    updateRed = YES;
    updateBlue = NO;
    enterNameTextField.text = redNameButton.titleLabel.text;
    [self toEnterNameView];
}

-(IBAction) setBlueName:(id)sender {
    updateBlue = YES;
    updateRed = NO;
    enterNameTextField.text = blueNameButton.titleLabel.text;
    [self toEnterNameView];
}

-(void) toEnterNameView {
    enterNameView.hidden = NO;
    enterNameView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:enterNameView];
    
    [enterNameTextField becomeFirstResponder];
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationRepeatCount:10];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    transform = CGAffineTransformRotate(transform, -3.14);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
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
