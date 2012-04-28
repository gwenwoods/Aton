//
//  PlayerViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController {
    
    IBOutlet UITextField *textField_red;
    IBOutlet UILabel *playerName_red;
}

-(IBAction) backToMenu:(id)sender;
-(IBAction) updatePlayerNameRed:(id)sender;

@end
