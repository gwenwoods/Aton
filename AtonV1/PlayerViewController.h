//
//  PlayerViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"

@class PlayerViewController;

@protocol playerViewDelegate
-(void)clickedButton1:(PlayerViewController*) subController;
@end

@interface PlayerViewController : UIViewController<myDelegate> {
    
    IBOutlet UITextField *textField_red, *textField_blue;
  //  IBOutlet UILabel *playerName_red;
    
    NSString *redName, *blueName;
    __unsafe_unretained id delegatePlayerView;
}

-(IBAction) backToMenu:(id)sender;
//-(IBAction) updatePlayerNameRed:(id)sender;

@property (nonatomic, assign) id<playerViewDelegate> delegatePlayerView; 
@end
