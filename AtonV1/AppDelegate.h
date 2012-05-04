//
//  AppDelegate.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartMenuViewController.h"
#import "PlayerViewController.h"

//@class BoardViewController;
@class StartMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    AVAudioPlayer *audioPlayerOpen;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StartMenuViewController *startMenuViewController;

@end
