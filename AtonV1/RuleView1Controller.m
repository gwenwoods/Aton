//
//  RuleViewController.m
//  AtonV1
//
//  Created by Wen Lin on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RuleView1Controller.h"

@interface RuleView1Controller ()

@end

@implementation RuleView1Controller
@synthesize delegateRuleView;

static int PAGE_NUM = 6;

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

    [self.view setBackgroundColor:[UIColor blackColor]];
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,1024,748)];
    iv.image = [UIImage imageNamed:@"Aton_Rules_P1.png"];
    pageIndex = 0;
    [self.view addSubview:iv];
    
    //--------------
    // return button
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(910.0, 700.0, 100.0, 40.0);
    [returnButton setUserInteractionEnabled:YES];
    [returnButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:returnButton];
    [self.view bringSubviewToFront:returnButton];
    
    //---------------
    // gesture recognizer
    UISwipeGestureRecognizer *oneFingerSwipeLeft = 
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = 
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    //----------------
    // audio
    NSURL *urlFlip = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/page-flip-3.wav", [[NSBundle mainBundle] resourcePath]]];
	audioFlip = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFlip error:nil];
	audioFlip.numberOfLoops = 0;
    audioFlip.volume = 1.0;
    [audioFlip prepareToPlay];
    
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
   	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(IBAction) backToMenu:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
    [delegateRuleView dismissRuleViewWithAnimation:self];
}

- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer 
{ 
   // CGPoint point = [recognizer locationInView:[self view]];
    if (pageIndex == 5) {
        return;
    }
    pageIndex = (pageIndex+1)%PAGE_NUM;
    [self displayNextPage];
    //NSLog(@"Swipe down - start location: %f,%f", point.x, point.y);
}

- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer 
{ 
    if (pageIndex == 0) {
        return;
    }
    // CGPoint point = [recognizer locationInView:[self view]];
    pageIndex = (pageIndex-1+PAGE_NUM)%PAGE_NUM;
    [self displayPreviousPage];
    //NSLog(@"Swipe down - start location: %f,%f", point.x, point.y);
}

-(void) displayNextPage {
    [self setNewPageIV];
    [self imagesTransitionPushFromRight:iv:0.5];
    [audioFlip play];
}

-(void) displayPreviousPage {
    [self setNewPageIV];
    [self imagesTransitionPushFromLeft:iv:0.5];
    [audioFlip play];
}

-(void) setNewPageIV {
    
    if (pageIndex == 0) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P1.png"];
        
    } else if (pageIndex == 1) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P2.png"];
        
    } else if (pageIndex == 2) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P3.png"];
        
    } else if (pageIndex == 3) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P4.png"];
        
    } else if (pageIndex == 4) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P5.png"];
        
    } else if (pageIndex == 5) {
        iv.image = [UIImage imageNamed:@"Aton_Rules_P6.png"];
        
    } 
}

-(void) imagesTransitionPushFromRight:(UIImageView*) view:(float) transTime {
	CATransition *transition = [CATransition animation];
	transition.duration = transTime;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
	[view.layer addAnimation:transition forKey:nil];
}

-(void) imagesTransitionPushFromLeft:(UIImageView*) view:(float) transTime {
	CATransition *transition = [CATransition animation];
	transition.duration = transTime;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
	[view.layer addAnimation:transition forKey:nil];
}

@end
