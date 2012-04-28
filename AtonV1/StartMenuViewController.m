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

-(void) showPlayAnimation {
    playAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         playAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(void) showRulesAnimation {
    rulesAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         rulesAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}


-(void) showCreditsAnimation {
    creditsAnkhIV.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         creditsAnkhIV.alpha = 1.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

-(void) fadeCreditsAnimation {
    creditsAnkhIV.alpha = 1.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         creditsAnkhIV.alpha = 0.0;
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([self isWithinImgView:touchLocation:playIV]) {
        playAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = nil;
        [self showPlayAnimation];
    } else {
        playAnkhIV.image = nil;
    }
    
    
    if ([self isWithinImgView:touchLocation:rulesIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        creditsAnkhIV.image = nil;
        [self showRulesAnimation];
        
    } else {
        rulesAnkhIV.image = nil;
    }
    
    if ([self isWithinImgView:touchLocation:creditsIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        [self showCreditsAnimation];
        
    } else {
        creditsAnkhIV.image = nil;
    }

}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([self isWithinImgView:touchLocation:playIV]) {
        if (playAnkhIV.image == nil) {
            [self showPlayAnimation];
        }
        playAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        rulesAnkhIV.image = nil;
        creditsAnkhIV.image = nil;
        
    } else {
        playAnkhIV.image = nil;
    }

    
    if ([self isWithinImgView:touchLocation:rulesIV]) {
        playAnkhIV.image = nil;
        if (rulesAnkhIV.image == nil) {
            [self showRulesAnimation];
        }
        rulesAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        creditsAnkhIV.image = nil;
        
    } else {
        rulesAnkhIV.image = nil;
    }
    
    if ([self isWithinImgView:touchLocation:creditsIV]) {
        playAnkhIV.image = nil;
        rulesAnkhIV.image = nil;
        if (creditsAnkhIV.image == nil) {
            [self showCreditsAnimation];
        }
        creditsAnkhIV.image = [UIImage imageNamed:@"ankh_small.png"];
        
    } else {
     //   if (creditsAnkhIV.image != nil) {
     //       [self fadeCreditsAnimation];
     //   } else{
            creditsAnkhIV.image = nil;
     //   }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
            CGPoint touchLocation = [touch locationInView:self.view];
		    if ([self isWithinImgView:touchLocation:playIV]) {
                
                BoardViewController *screen = [[BoardViewController alloc] initWithNibName:@"BoardViewController_iPad" bundle:nil];
                screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:screen animated:YES];
                playAnkhIV.image = nil;
            }
            
            if ([self isWithinImgView:touchLocation:rulesIV]) {
                rulesAnkhIV.image = nil;
            }
            
            if ([self isWithinImgView:touchLocation:creditsIV]) {
                
                CreditViewController *screen = [[CreditViewController alloc] initWithNibName:nil bundle:nil];
                screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:screen animated:YES];
                creditsAnkhIV.image = nil;
            }
		}
	}
}

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
}

-(IBAction) toPlayerView:(id)sender {
    PlayerViewController *screen = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:screen animated:YES];
}
@end
