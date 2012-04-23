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
    [AtonTouchBeganUtility checkTouch:event:touchElement:atonParameters:atonGameEngine];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [AtonTouchMovedUtility moveTouchElement:event:touchElement:self.view];   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {		
        if ([touch phase] == UITouchPhaseEnded) {
		    [AtonTouchEndUtility playerPlaceCard:touch:touchElement:atonParameters];
		}
	}
}

- (IBAction) toMenu:(id)sender {    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) doneAction:(id)sender {
    
    
    ScoreScarab *s1 = [atonParameters.scarabArray objectAtIndex:0];
    ScoreScarab *s2 = [atonParameters.scarabArray objectAtIndex:5];
   // [self animateCicleAlongPath:s1:s2];
    //[atonGameEngine imageFly:s1.blueIV :s2.blueIV];
    NSMutableArray *playerArray = [atonParameters playerArray];
    
    if (atonParameters.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        
        AtonPlayer *redPlayer = [[atonParameters playerArray] objectAtIndex:0];
        if ([[redPlayer emptyCardElementArray] count] < 4) {
            return;
        }
        atonParameters.gamePhaseEnum = GAME_PHASE_RED_CLOSE_CARD;
        [atonGameEngine run];
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        
        AtonPlayer *bluePlayer = [[atonParameters playerArray] objectAtIndex:1];
        if ([[bluePlayer emptyCardElementArray] count] < 4) {
            return;
        }
        atonParameters.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
        [atonGameEngine run];
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        
        
     /*   AtonPlayer *player= [playerArray objectAtIndex:atonParameters.atonRoundResult.firstPlayerEnum];
        NSString* playerName = [player playerName];
        int number = atonParameters.atonRoundResult.firstRemoveNum;
        msg = [msg stringByAppendingString:playerName];
        msg = [msg stringByAppendingString:[NSString stringWithFormat:@" should remove %i Blue Peep", number]];*/
        if ([allSelectedSlots count] != [atonParameters.atonRoundResult getFirstRemovePositiveNum]) {
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot removePeep];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:msg afterDelay:0.1];
        }
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != atonParameters.atonRoundResult.secondRemoveNum) {
       // if ([allSelectedSlots count] != 1) {
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot removePeep];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 4 result:\n Player Blue can place 2 Blue Peep" afterDelay:0.1];
        }
        
  /*      TempleSlot *selectedSlot = [TempleUtility findSelectedSlot:[atonParameters templeArray]];
        if (selectedSlot == nil) {
            return;
        }
        [selectedSlot removePeep];
        [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
        atonParameters.atonRoundResult.secondRemoveCount++;
        if (atonParameters.atonRoundResult.secondRemoveCount == 1) {
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 4 result:\n Player Blue can place 2 Blue Peep" afterDelay:0.1];
        } else {
            [atonGameEngine run]; 
        }*/
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
       // if ([allSelectedSlots count] != atonParameters.atonRoundResult.firstRemoveNum) {
        if ([allSelectedSlots count] != 2) {
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:OCCUPIED_BLUE];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 4 result:\n Player Red can place 1 Red Peep" afterDelay:0.1];
        }

        
   /*     TempleSlot *selectedSlot = [TempleUtility findSelectedSlot:[atonParameters templeArray]];
        if (selectedSlot == nil) {
            return;
        }
        [selectedSlot placePeep:OCCUPIED_BLUE];
        [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
        atonParameters.atonRoundResult.firstPlaceCount++;
        if (atonParameters.atonRoundResult.firstPlaceCount == 2) {
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Card 4 result:\n Player Red can place 1 Red Peep" afterDelay:0.1];
        } else {
            [atonGameEngine run]; 
        }*/
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != atonParameters.atonRoundResult.secondRemoveNum) {
       // if ([allSelectedSlots count] != 1) {
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:OCCUPIED_RED];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Round End" afterDelay:0.1];
        }
        
    /*    TempleSlot *selectedSlot = [TempleUtility findSelectedSlot:[atonParameters templeArray]];
        if (selectedSlot == nil) {
            return;
        }
        [selectedSlot placePeep:OCCUPIED_RED];
        [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
        atonParameters.atonRoundResult.secondPlaceCount++;
        if (atonParameters.atonRoundResult.secondPlaceCount == 1) {
            [atonParameters.gameManager performSelector:@selector(showCommunicationView:) withObject:@"Round End" afterDelay:0.1];
        } else {
            [atonGameEngine run]; 
        }
        */
    }
}

/*
- (void) animateCicleAlongPath:(ScoreScarab*) startScarab:(ScoreScarab*) endScarab {
    
   
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 8.0;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1000;
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint startPoint = startScarab.iv.center;
    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
    
    for (int i=1; i<=15; i++) {
        ScoreScarab *scarab = [atonParameters.scarabArray objectAtIndex:i];
        CGPoint endPoint = scarab.iv.center;
        CGPoint controlPoint = CGPointMake(120, endPoint.y-10);
        CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
    }

    for (int i=16; i<=25; i++) {
        ScoreScarab *scarab = [atonParameters.scarabArray objectAtIndex:i];
        CGPoint endPoint = scarab.iv.center;
        CGPoint controlPoint = CGPointMake(endPoint.x, -40);
        CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
    }
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    
    UIImageView *animationIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Blue_Cylinder.png"]];
    [self.view addSubview:animationIV];    
    //Add the animation to the animationIV - once you add the animation to the layer, the animation starts
    [animationIV.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    
}
 */
@end
