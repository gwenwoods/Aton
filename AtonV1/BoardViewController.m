//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"


@implementation BoardViewController

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
    AtonPlayer *redPlayer = [[AtonPlayer alloc] initializeWithParameters:0 :nil:self];
    AtonPlayer *bluePlayer = [[AtonPlayer alloc] initializeWithParameters:1 :nil:self];
    
    int redStartNumArray[] = {1,2,3,4};
    [redPlayer initilizeCardElement:redStartNumArray];
    
    NSMutableArray *playerArray = [[NSMutableArray alloc] init];
    [playerArray addObject:redPlayer];
    [playerArray addObject:bluePlayer];
    
    touchElement = [[AtonTouchElement alloc] initializeWithParameters:self];
   // TempleSlot *testSlot = [[TempleSlot alloc] initializeWithParameters:0 :CGPointMake(290, 422) :self.view];
    
    temple1 = [[AtonTemple alloc] initializeWithParameters:TEMPLE_1:CGPointMake(236, 422) :self.view];
    
    NSMutableArray *templeArray = [[NSMutableArray alloc] init];
    [templeArray addObject:temple1];
    
    atonParameters = [[AtonGameParameters alloc] initializeWithParameters:playerArray :templeArray];
    
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
	UITouch *touch = [[event allTouches] anyObject];
    [AtonTouchBeganUtility checkTouch:touch:touchElement:atonParameters];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    [AtonTouchMovedUtility moveTouchElement:touch:touchElement:self.view];   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
            NSMutableArray *playerArray = [atonParameters playerArray];
		    [AtonTouchEndUtility playerPlaceCard:touch:touchElement:[playerArray objectAtIndex:0]];
		}
	}
}

@end
