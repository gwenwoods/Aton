//
//  GameCenterHelper.h
//  AtonV1
//
//  Created by Wen Lin on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHelper : NSObject{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}



+(void) test1;
+(GameCenterHelper *)sharedInstance;
-(void)authenticateLocalUser;
-(void)authenticationChanged;

//@property (assign, readonly) BOOL gameCenterAvailable;

@end
