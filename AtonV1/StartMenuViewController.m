//
//  StartMenuViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartMenuViewController.h"

//@interface StartMenuViewController ()

@implementation StartMenuViewController

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
    
/*    UILongPressGestureRecognizer *longPressRecognizer = 
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self 
     action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 0.05;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPressRecognizer];*/
   // [longPressRecognizer release];
    [super viewDidLoad];
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


-(IBAction) playTouchDown:(id)sender {
    playIV.image = [UIImage imageNamed:@"ankh_small.png"];
    rulesIV.image = nil;
    creditsIV.image = nil;
    
    playIV.alpha = 0.0;

    [UIView animateWithDuration:0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         playIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}


-(IBAction) playTouchUpInside:(id)sender {
    BoardViewController *screen = [[BoardViewController alloc] initWithNibName:@"BoardViewController_iPad" bundle:nil];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
    playIV.image = nil;
}

-(IBAction) showRules:(id)sender {
    playIV.image = nil;
    rulesIV.image = [UIImage imageNamed:@"ankh_small.png"];
    creditsIV.image = nil;
    
    rulesIV.alpha = 0.0;
    [UIView animateWithDuration:0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         rulesIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(IBAction) showCredits:(id)sender {
    playIV.image = nil;
    rulesIV.image = nil;
    creditsIV.image = [UIImage imageNamed:@"ankh_small.png"];
    
    creditsIV.alpha = 0.0;
    [UIView animateWithDuration:0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         creditsIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

//- (IBAction)longPressDetected:(UIGestureRecognizer *)sender {
//    

//}
@end
