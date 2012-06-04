//
//  CreditViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreditViewController.h"

@implementation CreditViewController
@synthesize  delegateCreditView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *boardBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024,748)]; 
    boardBgIV.image = [UIImage imageNamed:@"aton_CreditsPage_new2_wQueenLogo.png"];
    [self.view addSubview:boardBgIV];
    [self.view sendSubviewToBack:boardBgIV];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
-(IBAction) backToMenu:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}*/


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [delegateCreditView dismissCreditViewWithAnimation:self];
   // [self dismissModalViewControllerAnimated:YES];
}

@end
