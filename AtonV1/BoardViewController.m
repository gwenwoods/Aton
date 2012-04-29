//
//  BoardViewController.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"


@implementation BoardViewController

//static int MESSAGE_DELAY_TIME = 0.5;
//static int AFTER_PEEP_DELAY_TIME = 2.0;

@synthesize delegate1;
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
        //delegate1 = [[myDelegate alloc]init];
        //delegate1 = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  //  NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/rooster.aiff", [[NSBundle mainBundle] resourcePath]]];
    //NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sheep.wav", [[NSBundle mainBundle] resourcePath]]];


    
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
    [delegate1 clickedButton:self];
 //   [self dismissModalViewControllerAnimated:YES];
    

}

- (IBAction) doneAction:(id)sender {
    [atonGameEngine playerDoneAction];
  //  [audioPlayer play];
 /*   NSMutableArray *playerArray = [atonParameters playerArray];
    
    if (atonParameters.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        
        AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
        if ([[redPlayer emptyCardElementArray] count] < 4) {
            return;
        }
        atonParameters.gamePhaseEnum = GAME_PHASE_RED_CLOSE_CARD;
        [atonGameEngine run];
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        
        AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
        if ([[bluePlayer emptyCardElementArray] count] < 4) {
            return;
        }
        atonParameters.gamePhaseEnum = GAME_PHASE_BLUE_CLOSE_CARD;
        [atonGameEngine run];
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != [atonParameters.atonRoundResult getFirstRemovePositiveNum]) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_REMOVE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
            
        } else {
            
            [TempleUtility removePeepsToDeathTemple:[atonParameters templeArray]:allSelectedSlots];
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_REMOVE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != [atonParameters.atonRoundResult getSecondRemovePositiveNum]) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_REMOVE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run];
            
        } else {
            
            [TempleUtility removePeepsToDeathTemple:[atonParameters templeArray]:allSelectedSlots];
             NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_FIRST_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != atonParameters.atonRoundResult.firstPlaceNum) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_FIRST_PLACE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            int occupiedEnum = OCCUPIED_RED;
            if (atonParameters.atonRoundResult.firstPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:occupiedEnum];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }

    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_SECOND_PLACE_PEEP) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([allSelectedSlots count] != atonParameters.atonRoundResult.secondPlaceNum) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_SECOND_PLACE_PEEP];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
        } else {
            int occupiedEnum = OCCUPIED_RED;
            if (atonParameters.atonRoundResult.secondPlayerEnum == PLAYER_BLUE) {
                occupiedEnum = OCCUPIED_BLUE;
            }
            
            for (int i=0; i < [allSelectedSlots count]; i++) {
                TempleSlot *selectedSlot = [allSelectedSlots objectAtIndex:i];
                [selectedSlot placePeep:occupiedEnum];
            }
            [TempleUtility disableAllTempleSlotInteraction:[atonParameters templeArray]];
            if ([TempleUtility isDeathTempleFull:[atonParameters templeArray]]) {
                [TempleUtility clearDeathTemple:[atonParameters templeArray]];
                atonParameters.atonRoundResult.templeScoreResultArray = [TempleUtility computeAllTempleScore:[atonParameters templeArray]];

                atonParameters.gamePhaseEnum = GAME_PHASE_ROUND_END_SCORE;
                [atonGameEngine run];
            } else {
                if ([atonGameEngine gameOverCondition] != nil) {
                    NSString *msg = [atonGameEngine gameOverCondition];
                    [atonParameters.gameManager performSelector:@selector(showFinalResultView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
                } else {
                    [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round End" afterDelay:AFTER_PEEP_DELAY_TIME];
                }
            }
            
        }
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_FIRST_REMOVE_4) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[atonParameters templeArray]:allSelectedSlots] == NO) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_ROUND_END_FIRST_REMOVE_4];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
            
        } else {
            
            [TempleUtility removePeepsToSupply:[atonParameters templeArray]:allSelectedSlots];
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:msg afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_ROUND_END_SECOND_REMOVE_4) {
        
        NSMutableArray *allSelectedSlots = [TempleUtility findAllSelectedSlots:[atonParameters templeArray]];
        if ([TempleUtility isSelectedOneFromEachTemple:[atonParameters templeArray]:allSelectedSlots] == NO) {
            NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_ROUND_END_SECOND_REMOVE_4];
            [atonParameters.gameManager performSelector:@selector(showHelpView:) withObject:msg afterDelay:MESSAGE_DELAY_TIME];
            [TempleUtility deselectAllTempleSlots:[atonParameters templeArray]];
            [atonGameEngine run]; 
            
        } else {
            
            [TempleUtility removePeepsToSupply:[atonParameters templeArray]:allSelectedSlots];
          //  NSString* msg = [atonParameters.atonRoundResult getMessageBeforePhase:GAME_PHASE_DISTRIBUTE_CARD];
            [atonParameters.gameManager performSelector:@selector(showGamePhaseView:) withObject:@"Round ... end ..." afterDelay:AFTER_PEEP_DELAY_TIME];
        }
        
    }*/
}

- (IBAction) exchangeCards:(id)sender {
    atonParameters.gameManager.exchangeCardsView.hidden = NO;
    [self.view bringSubviewToFront:atonParameters.gameManager.exchangeCardsView];
}

- (IBAction) exchangeCardsYes:(id)sender {
    
    if (atonParameters.gamePhaseEnum == GAME_PHASE_RED_LAY_CARD) {
        AtonPlayer *player = [[atonParameters playerArray] objectAtIndex:PLAYER_RED];
        player.exchangeCardsButton.hidden = YES;
        [player resetCard];
        [player distributeCards];
        [player performSelector:@selector(openCardsForArrange) withObject:nil afterDelay:3.0];
    
    } else if (atonParameters.gamePhaseEnum == GAME_PHASE_BLUE_LAY_CARD) {
        AtonPlayer *player = [[atonParameters playerArray] objectAtIndex:PLAYER_BLUE];
        player.exchangeCardsButton.hidden = YES;
        [player resetCard];
        [player distributeCards];
        [player performSelector:@selector(openCardsForArrange) withObject:nil afterDelay:3.0];
        
    }

    atonParameters.gameManager.exchangeCardsView.hidden = YES;
}

- (IBAction) exchangeCardsNo:(id)sender {
     atonParameters.gameManager.exchangeCardsView.hidden = YES;
}



@end
