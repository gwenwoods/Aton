//
//  StartMenuViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"

@interface StartMenuViewController : UIViewController
{
    IBOutlet UIImageView *playIV, *rulesIV, *creditsIV;
    IBOutlet UIImageView *playAnkhIV, *rulesAnkhIV, *creditsAnkhIV;
    BOOL longPress;
}

@end
