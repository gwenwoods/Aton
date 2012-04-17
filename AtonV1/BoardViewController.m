//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"


@implementation BoardViewController

@synthesize atonGameEngine;
@synthesize atonParameters;
@synthesize touchElement;
//@synthesize redPlayer, bluePlayer;

@synthesize temple1;

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
    
    touchElement = [[AtonTouchElement alloc] initializeWithParameters:self];
   
    atonParameters = [AtonGameInitializer initializeNewGame:self];
    atonGameEngine = [[AtonGameEngine alloc] initializeWithParameters:atonParameters];
    
    [atonGameEngine run];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [AtonTouchBeganUtility checkTouch:event:touchElement:atonParameters];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [AtonTouchMovedUtility moveTouchElement:event:touchElement:self.view];   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
            NSMutableArray *playerArray = [atonParameters playerArray];
		    [AtonTouchEndUtility playerPlaceCard:touch:touchElement:[playerArray objectAtIndex:0]];
		}
	}
}

- (IBAction) toMenu:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
