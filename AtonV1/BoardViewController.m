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
	
	[AtonTouchMoveUtility playerArrangeCard:touch:redPlayer];
	
	//touchLocation = [touch locationInView:nil];
    //UIImageView *tIV = [touchElement touchIV];
   // tIV.center = CGPointMake(touchLocation.y , 768-touchLocation.x - tIV.frame.size.height/2.0);
    //[UIUpdate update:touchElement:gameStatus];
}
@end
