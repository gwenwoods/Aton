//
//  AbstractExecutor.h
//  AtonV1
//
//  Created by Wen Lin on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TempleUtility.h"
#import "AtonGameParameters.h"
#import "AtonPlayer.h"

@protocol AbstractExecutorDelegate
- (void) engineRun;
@end

@interface AbstractExecutor : NSObject {
    __unsafe_unretained id <AbstractExecutorDelegate> executorDelegate;
 //   AtonGameParameters *para1;
}

@property (assign) id <AbstractExecutorDelegate> executorDelegate;
@end
