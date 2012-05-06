//
//  RuleViewController.m
//  AtonV1
//
//  Created by Wen Lin on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@end

@implementation RuleViewController

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
    
    //  [self.view setBackgroundColor:[UIColor redColor]];
    // scrollView.frame = CGRectMake(0, 0, 4096, 4096);
    [self.view setBackgroundColor:[UIColor blackColor]];
    scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:scrollView];
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(1024, 5600)];
    //  [scrollView setBackgroundColor:[UIColor blueColor]];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,1024,5600)];
    iv.image = [UIImage imageNamed:@"rule_all_middle.png"];
    [scrollView addSubview:iv];
    [scrollView bringSubviewToFront:iv];
    
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    returnButton.frame = CGRectMake(880.0, 660.0, 100.0, 40.0);
    returnButton.alpha = 0.5;
    returnButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:24];
   // returnButton.hidden = NO;
   // [returnButton setImage:[UIImage imageNamed:@"buttonDone.png"] forState:UIControlStateNormal];
    [returnButton setTitle:@"Back" forState:UIControlStateNormal];
    [returnButton setUserInteractionEnabled:YES];
    [returnButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:returnButton];
    [self.view bringSubviewToFront:returnButton];
    
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
    // Return YES for supported orientations
	//return YES;
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(IBAction) backToMenu:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
