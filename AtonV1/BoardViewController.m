//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"


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
    
    int redStartNumArray[] = {1,2,3,4};
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
    
    [AtonTouchMovedUtility moveTouchElement:touch:touchElement:self.view];
 /*   touchLocation = [touch locationInView:self.view];

    if ([self isWithinImgView:touchLocation:[touchElement touchIV]]) {
        CGPoint localLaction = [touchElement localLaction];
        UIImageView *tIV = [touchElement touchIV];
        int dx = (int)localLaction.x - (int)tIV.frame.size.width/2;
        int dy = (int)localLaction.y - (int)tIV.frame.size.height/2;
        tIV.center = CGPointMake(touchLocation.x -dx, touchLocation.y -dy);
    }*/
    
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

/*
-(BOOL) isWithinImgView:(CGPoint) point:(UIImageView*)iv1 {
	// check if iv0 is within iv1
	int x0 = point.x;
	int y0 = point.y;
	
	int x1 = iv1.center.x;
	int y1 = iv1.center.y;
	int w1 = [iv1 frame].size.width/2.0;
	int h1 = [iv1 frame].size.height/2.0;
	
	if ( (x0 > x1-w1) && (x0 < x1+w1) && (y0 > y1-h1) && (y0 < y1+h1) ) {
	    return YES;		
	}
	return NO;
}*/
@end
