//
//  PlayerViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

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
 //   [exchangeCardsButton addTarget:controller action:@selector(exchangeCards:) forControlEvents:UIControlEventTouchUpInside];
    enterNameTextField.delegate = self;
   // 
    [enterNameView addSubview:enterNameTextField];

    redNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    redNameButton.frame = CGRectMake(200,300,180,40);
    redNameButton.userInteractionEnabled = YES;
    redNameButton.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [redNameButton setTitle:@"Player Red"  forState:UIControlStateNormal];
    [redNameButton addTarget:self action:@selector(toEnterNameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redNameButton];

    
    //[textField_red becomeFirstResponder];
    textField_red.delegate = self;
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
    [delegatePlayerView clickedButton1:self];
}

-(IBAction) toPlay:(id)sender {
    redName = textField_red.text;
    blueName = textField_blue.text;
    
    BoardViewController *screen = [[BoardViewController alloc] initWithNibNameAndPara:@"BoardViewController_iPad" bundle:nil red:redName blue:blueName];
    screen.delegate1 = self;
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)clickedButton:(BoardViewController *)subcontroller
{
    // NSString *myData = [subcontroller getData];
    NSLog(@"Back to start menu");
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"Hit me");
    return NO;
}

-(IBAction)dismissKeyboard: (id)sender {
    NSLog(@"Hit me!");
    [sender resignFirstResponder];
  
} 

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Hide Keyboard");
    enterNameView.hidden = YES;
    NSString* name = enterNameTextField.text;
    [redNameButton setTitle:name forState:UIControlStateNormal];
    
}

-(IBAction) setRedName:(id)sender {
    
}

-(IBAction) setBlueName:(id)sender {
    
}
/*- (void)keyboardWillHide:(NSNotification *)notification {
    
      NSLog(@"I m hiding !");
}*/

-(void) toEnterNameView {
    enterNameView.hidden = NO;
    [self.view bringSubviewToFront:enterNameView];
    enterNameView.userInteractionEnabled = YES;
    [enterNameTextField becomeFirstResponder];
}
@end
