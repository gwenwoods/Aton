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


-(IBAction) playGame:(id)sender {
    
    if (playIV.image == nil) {
        playIV.image = [UIImage imageNamed:@"ankh_small.png"];
        rulesIV.image = nil;
        creditsIV.image = nil;
        return;
    }
    
    BoardViewController *screen = [[BoardViewController alloc] initWithNibName:@"BoardViewController_iPad" bundle:nil];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
}

-(IBAction) showRules:(id)sender {
    if (rulesIV.image == nil) {
        playIV.image = nil;
        rulesIV.image = [UIImage imageNamed:@"ankh_small.png"];
        creditsIV.image = nil;
        return;
    }
}

-(IBAction) showCredits:(id)sender {
    if (creditsIV.image == nil) {
        playIV.image = nil;
        rulesIV.image = nil;
        creditsIV.image = [UIImage imageNamed:@"ankh_small.png"];
        return;
    }
}

@end
