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
    textField_red.becomeFirstResponder;
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
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
    NSLog(@"I m hiding !");
}

/*- (void)keyboardWillHide:(NSNotification *)notification {
    
      NSLog(@"I m hiding !");
}*/
@end
