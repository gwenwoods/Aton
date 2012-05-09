//
//  AppDelegate.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize startMenuViewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
       self.startMenuViewController = [[StartMenuViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
      //  self.startMenuViewController = [[StartMenuViewController alloc] initWithNibName:@"StartMenuViewController" bundle:nil];

    } else {
        self.startMenuViewController = [[StartMenuViewController alloc] initWithNibName:@"StartMenuViewController" bundle:nil];
    }
    self.window.rootViewController = self.startMenuViewController;
    
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.startMenuViewController.audioPlayerOpen stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.startMenuViewController.playerViewScreen != nil) {
        
        PlayerViewController *playerScreen = self.startMenuViewController.playerViewScreen;
        
        if (playerScreen.boardScreen == nil) {
            [self.startMenuViewController.playerViewScreen dismissModalViewControllerAnimated:NO];
            [self.startMenuViewController.view becomeFirstResponder];
            [self.startMenuViewController viewDidLoad];
        }
        
        playerScreen.audioEnterName = nil;
        playerScreen = nil;
    } else if (self.startMenuViewController.creditViewScreen != nil) {
        
        [self.startMenuViewController.creditViewScreen dismissModalViewControllerAnimated:NO];
        [self.startMenuViewController.view becomeFirstResponder];
        [self.startMenuViewController viewDidLoad];
        self.startMenuViewController.creditViewScreen = nil;
        
    } else if (self.startMenuViewController.ruleViewScreen != nil) {
        
        [self.startMenuViewController.ruleViewScreen dismissModalViewControllerAnimated:NO];
        [self.startMenuViewController.view becomeFirstResponder];
        [self.startMenuViewController viewDidLoad];
        self.startMenuViewController.ruleViewScreen = nil;
        
    } else {
        [self.startMenuViewController viewDidLoad];
    }

   NSLog(@"app will enter foreground");
     
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

/*    if (self.startMenuViewController.playerViewScreen != nil) {
        
        PlayerViewController *playerScreen = self.startMenuViewController.playerViewScreen;
        if (playerScreen.boardScreen == nil) {
            [self.startMenuViewController.playerViewScreen dismissModalViewControllerAnimated:NO];
            [self.startMenuViewController.view becomeFirstResponder];
            [self.startMenuViewController viewDidLoad];
        }
        
    } if (self.startMenuViewController.creditViewScreen != nil) {
        
        [self.startMenuViewController.creditViewScreen dismissModalViewControllerAnimated:NO];
        [self.startMenuViewController.view becomeFirstResponder];
        [self.startMenuViewController viewDidLoad];
        
    } else {
        [self.startMenuViewController viewDidLoad];
    }*/
    
  /*  if ([self.startMenuViewController.view isFirstResponder] == YES) {
         [self.startMenuViewController viewDidLoad];
    }*/
   
    NSLog(@"app will become active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
