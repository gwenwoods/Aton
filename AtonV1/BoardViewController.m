//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"

//@interface BoardViewController ()

//@end

@implementation BoardViewController

@synthesize touchElement;
@synthesize  redPlayer, bluePlayer;

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
    redPlayer = [[AtonPlayer alloc] initializeWithParameters:0 :nil:self];
    bluePlayer = [[AtonPlayer alloc] initializeWithParameters:1 :nil:self];
    
    int *redStartNumArray[] = {1,2,3,4};
 //   [redPlayer setStartCardNumArray:redStartNumArray];
 //   [redPlayer displayStartCards];
    [redPlayer initilizeCardElement:redStartNumArray];
    
    touchElement = [[AtonTouchElement alloc] initializeWithParameters:self];
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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [[event allTouches] anyObject];
	
	touchLocation = [touch locationInView:nil];
    UIImageView *tIV = [touchElement touchIV];
    tIV.center = CGPointMake(touchLocation.y , 768-touchLocation.x - tIV.frame.size.height/2.0);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [[event allTouches] anyObject];
    
    [AtonTouchBeganUtility playerArrangeCard:touch:touchElement:redPlayer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
		    [AtonTouchEndUtility playerPlaceCard:touch:touchElement:redPlayer];
		}
	}
}
@end
